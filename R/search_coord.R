#' Search for the nearest quarter section using latitude and longitude
#'
#' Find the quarter section(s) and other legal division
#' types closest to provided coordinates. Returns the
#' legal land description. Users must use provide coordinates in the
#' decimal degree format.
#'
#' The longitudinal extent of Manitoba ranges from approximately -102.0 to
#' -88.9 degrees (negative values indicate western hemisphere).
#'
#' The latitudinal extent of Manitoba ranges from approximately 49.0 to 60.0
#' degrees (positive values indicate northern hemisphere).
#'
#' @details A legal land description consists of four values separated by a -
#' 1. Quarter Section (SW)
#' 2. Section (9)
#' 3. Township (8)
#' 4. Range (6E1)
#'
#' For example:
#' A legal land description of SW-9-8-6E1 can be interpreted as the Southwest
#' Quarter of Section 9, Township 8, Range 6 East of the 1st Meridian.
#'
#'#' Other land division types can have different naming conventions and include:
#'  - RL = River lot (e.g., RL-11-Oak Island)
#'  - Lot = Township lot (e.g., 10-54-27W1)
#'  - OT = Outer two mile lot (e.g., OT-11A-St. Clements)
#'  - PL = Parish lot (e.g., PL-R-St. Andrews)
#'  - SL = Settlement lot (e.g., SL-2-Roman Catholic Mission Property)
#'  - WL = Wood lot (e.g., WL-179-Portage La Prairie)
#'
#' @param long Numeric. Vector of longitudes (decimal degree) with resolution
#' up to one hundred thousandth of a degree. Values outside of bounds will
#' return error (-102.0 to -88.9 degrees).
#' @param lat Numeric. Vector of latitudes (decimal degree) with resolution up
#' to one hundred thousandth of a degree. Values outside of bounds will return
#' error (49.0 to 60.0 degrees).
#'
#' @return A tibble of the centre latitude and longitude coordinates,
#' corresponding legal land descriptions, land division type, the user provided
#' latitude and longitude coordinates, and distance in metres from the
#' provided coordinates to the centre of the closest quarter section.
#'
#' @export
#'
#' @examples
#' search_coord(long = c(-101.4656, -99.99768), lat = c(51.81913, 49.928926))
#' x <- data.frame(long = c(-101.4656, -99.9976), lat = c(51.81913, 49.92892))
#' search_coord(long = x$long, lat = x$lat)


search_coord <- function(long, lat) {

  if(!is.numeric(long) || !is.numeric(lat))
    stop("Longitude and latitude must be numbers.")

  if(!(all(long > -102.0016 & long < -88.947)))
    stop("Longitude values must be between -102.0 and -88.94.")

  if(!all(lat > 48.99267 & lat < 60.00007))
    stop("Latitude values must be between 49.0 and 60.0.")

  if(length(long) != length(lat))
    stop("Number of longitude and latitude coordinates must be equal.")

  master_data <- cache_load()
  search_df <- tibble::tibble(long = long, lat = lat) |>
    sf::st_as_sf(coords = c("long", "lat"),
                 crs = "+proj=longlat +datum=WGS84") |>
    sf::st_transform(crs = "EPSG:3158") |>
    dplyr::mutate(coords = as.data.frame(
      sf::st_coordinates(.data[["geometry"]]))) |>
    tidyr::unnest("coords") |>
    sf::st_drop_geometry() |>
    tibble::rowid_to_column("point") |>
    dplyr::mutate(dist = purrr::map2(
      .data[["X"]], .data[["Y"]],
      \(x, y) closest_centroid(master_data, x, y))) |>
    tidyr::unnest("dist") |>
    dplyr::mutate(dist = units::set_units(.data[["dist"]], "m")) |>
    dplyr::select("point", legal = "Informal Legal Description",
                  "x", "y",
                  type = "Type",
                  "dist") |>
    sf::st_as_sf(coords = c("x", "y"), crs = "EPSG:3158") |>
    sf::st_transform(crs = "+proj=longlat +datum=WGS84") |>
    dplyr::mutate(coords = as.data.frame(
      sf::st_coordinates(.data[["geometry"]]))) |>
    tidyr::unnest("coords") |>
    sf::st_drop_geometry() |>
    dplyr::rename("long" = "X", "lat" = "Y") |>
    dplyr::left_join(tibble::tibble(long_user = long, lat_user = lat) |>
                       tibble::rowid_to_column("point"), by = "point") |>
    dplyr::select(-"point") |>
    dplyr:: relocate("dist", .after = dplyr::last_col())

  if(max(as.numeric(search_df$dist)) >= 1000)
    stop("One or more coordinates greater than 1000m from nearest quarter",
         " section center. Please check your data.")

  if(max(as.numeric(search_df$dist)) > 600 && max(as.numeric(search_df$dist))
     < 1000)
    warning("One or more coordinates greater than 600m from nearest quarter",
            " section center. Please check your data.")
  search_df
}


#' Closest centroid
#'
#' Calculates the euclidean distance between provided coordinates and the the
#' center coordinates for each land parcel. Filters to find the closest point.
#'
#' @param master_data Dataframe. Full legal land description dataset
#' @param X Numeric. X coordinates in metres (EPSG:3857)
#' @param Y Numeric. Y coordinates in metres (EPSG:3857)
#'
#' @noRd
closest_centroid <- function(master_data, X, Y) {
  master_data |>
    sf::st_as_sf(coords = c("x", "y"),
                 crs = "EPSG:3857") |>
    sf::st_transform(crs = "EPSG:3158") |>
    dplyr::mutate(coords = as.data.frame(
      sf::st_coordinates(.data[["geometry"]]))) |>
    tidyr::unnest("coords") |>
    sf::st_drop_geometry() |>
    dplyr::rename("x" = "X", "y" = "Y") |>
    dplyr::bind_cols(X = X, Y = Y) |>
    dplyr::mutate(dist = ((X - .data[["x"]])^2 + (.data[["y"]] - Y) ^2)^0.5) |>
    dplyr::filter(.data[["dist"]] == min(.data[["dist"]])) |>
    dplyr::select(-"X", -"Y")
}
