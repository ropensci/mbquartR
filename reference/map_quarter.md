# Quickly find MB quarter sections on a map

Map the output of
[`search_legal()`](https://docs.ropensci.org/mbquartR/reference/search_legal.md)
or
[`search_coord()`](https://docs.ropensci.org/mbquartR/reference/search_coord.md),
similar data frame, or a vector of legal land descriptions onto an
interactive Leaflet map.

## Usage

``` r
map_quarter(x, map.type = "Esri.WorldImagery")
```

## Arguments

- x:

  Output from
  [`search_legal()`](https://docs.ropensci.org/mbquartR/reference/search_legal.md)
  or
  [`search_coord()`](https://docs.ropensci.org/mbquartR/reference/search_coord.md),
  similar data frame, or a vector of legal land descriptions.

- map.type:

  Base map: see
  <https://leaflet-extras.github.io/leaflet-providers/preview/> for
  available options

## Value

A Leaflet map

## Details

Map displays the centre point and estimates the boundaries for quarter
sections.

Map locations using a data frame which must include a column named
`legal` containing legal land descriptions.

Map locations using a vector of legal land descriptions.

## Examples

``` r
search1 <- search_legal(x = c("NE-11-33-29W1", "SW-20-2-1W1"))
map_quarter(x = search1)
#> Polygons for quarter sections are approximate and are only meant as
#>     a visual aid.

search2 <- search_coord(long = c(-101.4656, -99.99768),
lat = c(51.81913, 49.928926))
map_quarter(x = search2)
#> Polygons for quarter sections are approximate and are only meant as
#>     a visual aid.

search3 <- c("NE-11-33-29W1", "SW-20-2-1W1")
map_quarter(x = search3)
#> Polygons for quarter sections are approximate and are only meant as
#>     a visual aid.
```
