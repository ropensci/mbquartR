# Search for the nearest quarter section using latitude and longitude

Find the quarter section(s) and other legal division types closest to
provided coordinates. Returns the legal land description. Users must use
provide coordinates in the decimal degree format.

## Usage

``` r
search_coord(long, lat)
```

## Arguments

- long:

  Numeric. Vector of longitudes (decimal degree) with resolution up to
  one hundred thousandth of a degree. Values outside of bounds will
  return error (-102.0 to -88.9 degrees).

- lat:

  Numeric. Vector of latitudes (decimal degree) with resolution up to
  one hundred thousandth of a degree. Values outside of bounds will
  return error (49.0 to 60.0 degrees).

## Value

A tibble of the centre latitude and longitude coordinates, corresponding
legal land descriptions, land division type, the user provided latitude
and longitude coordinates, and distance in metres from the provided
coordinates to the centre of the closest quarter section.

## Details

The longitudinal extent of Manitoba ranges from approximately -102.0 to
-88.9 degrees (negative values indicate western hemisphere).

The latitudinal extent of Manitoba ranges from approximately 49.0 to
60.0 degrees (positive values indicate northern hemisphere).

A legal land description consists of four values separated by a -

1.  Quarter Section (SW)

2.  Section (9)

3.  Township (8)

4.  Range (6E1)

For example: A legal land description of SW-9-8-6E1 can be interpreted
as the Southwest Quarter of Section 9, Township 8, Range 6 East of the
1st Meridian.

\#' Other land division types can have different naming conventions and
include:

- RL = River lot (e.g., RL-11-Oak Island)

- Lot = Township lot (e.g., 10-54-27W1)

- OT = Outer two mile lot (e.g., OT-11A-St. Clements)

- PL = Parish lot (e.g., PL-R-St. Andrews)

- SL = Settlement lot (e.g., SL-2-Roman Catholic Mission Property)

- WL = Wood lot (e.g., WL-179-Portage La Prairie)

## Examples

``` r
search_coord(long = c(-101.4656, -99.99768), lat = c(51.81913, 49.928926))
#> # A tibble: 2 × 7
#>   legal         type      long   lat long_user lat_user  dist
#>   <chr>         <chr>    <dbl> <dbl>     <dbl>    <dbl>   [m]
#> 1 NE-11-33-29W1 Quarter -101.   51.8    -101.      51.8  29.9
#> 2 NW-15-11-19W1 Quarter -100.0  49.9    -100.0     49.9 211. 
x <- data.frame(long = c(-101.4656, -99.9976), lat = c(51.81913, 49.92892))
search_coord(long = x$long, lat = x$lat)
#> # A tibble: 2 × 7
#>   legal         type      long   lat long_user lat_user  dist
#>   <chr>         <chr>    <dbl> <dbl>     <dbl>    <dbl>   [m]
#> 1 NE-11-33-29W1 Quarter -101.   51.8    -101.      51.8  29.9
#> 2 NW-15-11-19W1 Quarter -100.0  49.9    -100.0     49.9 211. 
```
