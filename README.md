
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mbquartR

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/alex-koiter/mbquartR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/alex-koiter/mbquartR?branch=main)
[![R-CMD-check](https://github.com/alex-koiter/mbquartR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/alex-koiter/mbquartR/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of `mbquartR` is to provide an easy way to locate quarter
sections in the province of Manitoba. You can search by legal land
description (e.g., NE-11-33-29W1) or by lat/long coordinates (e.g.,
-101.4656, 51.81913). There is also a convenient map function that plots
the centres of the quarter sections on a map.

For more details checkout the [mbquartR
website](http://alexkoiter.ca/mbquartR/).

## Installation

You can install the development version of `mbquartR` like so:

``` r
# install.packages("devtools")
devtools::install_github("alex-koiter/mbquartR")
```

## How do legal land descriptions work in Manitoba?

A legal land description consists of four values separated by a -

1.  Quarter Section (SW)
2.  Section (9)
3.  Township (8)
4.  Range (6E1)

For example: A legal land description of SW-9-8-6E1 can be interpreted
as the Southwest Quarter of Section 9, Township 8, Range 6 East of the
1st Meridian.

## Usage

### Download the data set from Data MB

To use the search functions you must first download a dataset that has
both the legal land descriptions and the coordinates of the center for
each quarter section in Manitoba

``` r
quarters_dl()
```

These are basic examples which shows you the two common ways to search
for quarter sections:

### Search using lat/long coordinates

This function takes your coordinates and locates the nearest centre of a
quarter section based on the euclidean distance between two points.
Given that most quarter sections are a half mile square (804.7m by
804.7m) the furthest distance from the center to corner is ~570m. You
will get a warning if any distances are greater than 600m and an error
is the distance is greater than 1000m. The tibble that is returned
provides the legal land descriptions, centre coordinates, and the
distance from the coordinates provided to the closest quarter section
centre.

``` r
library(mbquartR)

search_coord(long = c(-101.4656, -99.99768), lat = c(51.81913, 49.928926))
#> # A tibble: 2 × 4
#>   legal          long   lat  dist
#>   <chr>         <dbl> <dbl>   [m]
#> 1 NE-11-33-29W1 -101.  51.8  48.4
#> 2 NW-15-11-19W1 -100.  49.9 329.
```

### Search using legal land descriptions

This function takes legal land descriptions and locates the centre
coordinates of the quarter sections. You can include leading zeroes
(e.g., NE-01-012-12E1) or not (e.g., NE-1-12-12E1). The data set used in
this package includes three meridians (W1, E1, and E2); however, most
commonly searched for quarter sections use the East 1 (E1) or West 1
(W1) meridians. If the meridian number is not included it will default
to 1. For example, a search for NW-36-89-11E will by default search for
NW-36-89-11E1 despite NW-36-89-11E2 existing in the data set.

``` r

search_legal(x = c("NE-11-33-29W1", "SW-20-02-1W1"))
#> # A tibble: 2 × 3
#>   legal           long   lat
#>   <chr>          <dbl> <dbl>
#> 1 NE-11-33-29W1 -101.   51.8
#> 2 SW-20-2-1W1    -97.6  49.1
```

### Map legal land descriptions

You can also quickly plot located quarter sections on an interactive map

``` r
example <- search_legal(x = c("NE-1-12-12E1", "NE-11-33-29W1"))
map_quarter(example)
```
