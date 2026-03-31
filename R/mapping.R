
#' Quickly find MB quarter sections on a map
#'
#' Map the output of `search_legal()` or `search_coord()`, similar
#' data frame, or a vector of legal land descriptions onto an interactive
#' Leaflet map.
#'
#' @details
#' Map displays the centre point and estimates the boundaries for
#' quarter sections.
#'
#' Map locations using a data frame which must include a column named `legal`
#' containing legal land descriptions.
#'
#' Map locations using a vector of legal land descriptions.
#'
#' @param x Output from `search_legal()` or `search_coord()`, similar
#' data frame, or a vector of legal land descriptions.
#'
#' @param map.type Base map: see
#' <https://leaflet-extras.github.io/leaflet-providers/preview/> for available
#' options
#'
#' @return A Leaflet map
#' @export
#'
#' @examples
#'
#' search1 <- search_legal(x = c("NE-11-33-29W1", "SW-20-2-1W1"))
#' map_quarter(x = search1)
#'
#' search2 <- search_coord(long = c(-101.4656, -99.99768),
#' lat = c(51.81913, 49.928926))
#' map_quarter(x = search2)
#'
#' search3 <- c("NE-11-33-29W1", "SW-20-2-1W1")
#' map_quarter(x = search3)
#' @importFrom rlang .env

map_quarter <- function(x, map.type = "Esri.WorldImagery") {

  master_data <- cache_load()

  if(inherits(x, "data.frame")) {
    if(!"legal" %in% names(x)) {
      stop("Data frame must have column 'legal'", call. = FALSE)
    }
    x <- x$legal
  }

  if(any(stringr::str_detect(x, "E$")))
    warning(
      "One or more of the legal land descriptions has an ambiguous ",
      "meridian value E and is assumed to be east of prime meridian (E1).",
      "\nTo stop messages please specify meridians as E1 or E2 ",
      "(e.g., NW-36-89-11E1).")

  x <- x |>
    stringr::str_replace_all("\\b0+","") |> ## Remove leading zeros
    stringr::str_replace("E$", "E1") |> ## Assumes E is E1 and not E2
    stringr::str_replace("W$", "W1") ## Only one western meridian in MB W1


  if(any(!x %in% master_data$`Informal Legal Description`)) {
    stop("One or more of the legal land descriptions could not be found."
         , call. = FALSE)
  }

  Centre <- centroid(x)

  Polygon <- polygon(x)

  pal <- viridis::viridis(length(unique(x)))

  values_point <- purrr::set_names(pal, unique(x))
  values_poly <- values_point[Polygon$legal]

  if(nrow(Polygon) == 0){
    mapview::mapview(Centre, col.regions = values_point,
                     map.type = map.type, homebutton = FALSE) |>
      print()

  } else{
      mapview::mapview(Polygon, col.regions = values_poly,
                       map.type = map.type, color = "black",
                       homebutton = FALSE, lwd = 2) +
      mapview::mapview(Centre, col.regions = values_point,
                       map.type = map.type, color = "black",
                       homebutton = FALSE) |>
      print()
  }
}

#' Find centre coordinates
#'
#' Finds the center coordinates for the supplied legal land description.
#'
#' @param x Output from `search_legal()` or `search_coord()`, similar
#'   data frame, or a vector of legal land descriptions.
#'
#' @return Tibble. Simple feature collection with legal land description and
#'   associated point geometry
#'
#' @noRd
centroid <- function(x) {
  master_data <- cache_load()
  master_data |>
    dplyr::rename(legal = "Informal Legal Description") |>
    dplyr::filter(.data[["legal"]] %in% .env$x) |>
    tidyr::drop_na("x" | "y") |>
    sf::st_as_sf(coords = c("x", "y"), crs = "EPSG:3857") |>
    sf::st_transform(crs = "+proj=longlat +datum=WGS84") |>
    dplyr::select("legal", "geometry")
}

#' Creates polygons for quarter sections
#'
#' Creates approximate polygons for quarter sections for the supplied legal
#' land description. Does not create polygons for other land divisions
#'
#' @param x Output from `search_legal()` or `search_coord()`, similar
#'   data frame, or a vector of legal land descriptions.
#'
#' @return Tibble. Simple feature collection with legal land description and
#'   associated polygon geometries for quarter section only. Other land
#'   division types are filtered out.
#'
#' @noRd

polygon <- function(x) {
  master_data <- cache_load()
  polygon <-  master_data |>
    dplyr::rename(legal = "Informal Legal Description") |>
    dplyr::filter(.data[["legal"]] %in% .env$x) |>
    sf::st_as_sf(coords = c("x", "y"), crs = "EPSG:3857")

  if(!all(polygon$Type != "Quarter"))
    message("Polygons for quarter sections are approximate and are only meant as
    a visual aid.")

  if(!all(polygon$Type == "Quarter"))
    warning("One or more of the legal land descriptions provided are a type of
    land division other than a quarter section and the polygon can not be
    estimated.", call. = FALSE)

  polygon <- polygon |>
    dplyr::filter(.data[["Type"]] == "Quarter") |>
    sf::st_transform(crs = "+proj=longlat +datum=WGS84")|>
    #dplyr::select("legal", "geometry") |>
    sf::st_buffer(t,
                  dist = 402.336,
                  endCapStyle = "SQUARE") |>
    dplyr::group_by(.data[["legal"]], .data[["Type"]]) |>
    tidyr::nest() |>
    dplyr::mutate(bbox = purrr::map(.data[["data"]],
                                    ~sf::st_as_sfc(sf::st_bbox(.x)))) |>
    dplyr::ungroup() |>
    tidyr::unnest("bbox") |>
    sf::st_as_sf() |>
    dplyr::mutate(bbox = dplyr::case_when(Type != "Quarter" ~ NA,
                                              TRUE ~ bbox)) |>
    dplyr::select(-"data", -"Type")
}

