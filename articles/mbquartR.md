# mbquartR

``` r
library(mbquartR)
```

## mbquartR

[![Codecov test
coverage](https://codecov.io/gh/ropensci/mbquartR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/ropensci/mbquartR?branch=main)
[![R-CMD-check](https://github.com/ropensci/mbquartR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ropensci/mbquartR/actions/workflows/R-CMD-check.yaml)
[![pkgcheck](https://github.com/ropensci/mbquartR/workflows/pkgcheck/badge.svg)](https://github.com/ropensci/mbquartR/actions?query=workflow%3Apkgcheck)

The goal of `mbquartR` is to provide an easy way to download the
Manitoba Original Survey Legal Descriptions data from
[DataMB](https://geoportal.gov.mb.ca/) and then to locate quarter
sections, and other types of land division types, in the province of
Manitoba. You can search by legal land description (e.g., NE-11-33-29W1)
or by lat/long coordinates (e.g., -101.4656, 51.81913). There is also a
convenient map function that plots the centres and an outline of the
quarter sections on a map.

The Manitoba Original Survey Legal Descriptions data set covers the
entire province of Manitoba and there are over 900,000 parcels of land
that have a legal land description. `mbquartR` was created for those who
work with geospatial data in Manitoba, particularly those who are
working with rural or farm parcels of land where the legal land
description is commonly used as the method of identifying the location.
`mbquartR` also allows users to quickly go back and forth between
geographic coordinates and the legal land description. Most mapping
applications (e.g., Google Maps) can not find or route to a legal land
description, but you can with coordinates!

### Installation

You can install the development version of `mbquartR` like so:

``` r
install.packages("mbquartR", repos = "https://ropensci.r-universe.dev")
```

### What is a quarter section?

A quarter section in Manitoba is a land unit measuring 160 acres (~64.8
ha), representing a quarter of a square mile. It originates from the
[Dominion Land Survey
system](https://en.wikipedia.org/wiki/Dominion_Land_Survey), introduced
in the late 19th century to organize the European settlement and
colonization of Western Canada. The grid system covers most of the
province of Manitoba and organizes land into a hierarchy of quarter
sections, sections, townships, and ranges.

- A quarter section is square parcel of land measuring 1/4 mile by 1/4
  mile
- A section is a square parcel of land measuring 1 mile by 1 mile and
  consists of four quarter sections, where each quarter section is
  indicated by the cardinal direction of the corners of the section (NW,
  NE, SW, SE)
- A township consists of a grid of 36 sections, where sections are
  numbered in an “S” pattern, starting in the northeast corner with
  section 1 and ending in the southeast corner with section 36
- A range is a vertical column of townships running north-south and are
  numbered east or west of a designated Principal Meridian

#### How do legal land descriptions for quarter section work in Manitoba?

A legal land description for a quarter section consists of four values
separated by a -

1.  Quarter Section (SW)
2.  Section (9)
3.  Township (8)
4.  Range (6E1)

For example: A legal land description of SW-9-8-6E1 can be interpreted
as the Southwest Quarter of Section 9, Township 8, Range 6 East of the
1st Meridian.

### Other land division types

Quarter sections are the most common type of land division in Manitoba
but there are other types. The size, shape, and naming convention of
these other types of land divisions can be different.

These include:

- RL = River lot (e.g., RL-11-Oak Island)
- Lot = Township lot (e.g., 10-54-27W1)
- OT = Outer two mile lot (e.g., OT-11A-St. Clements)
- PL = Parish lot (e.g., PL-R-St. Andrews)
- SL = Settlement lot (e.g., SL-2-Roman Catholic Mission Property)
- WL = Wood lot (e.g., WL-179-Portage La Prairie)

These other types of land division can also be search for using
[`search_legal()`](https://docs.ropensci.org/mbquartR/reference/search_legal.md)

### Usage

#### Download the data set from DataMB

To use the search functions you must first download a dataset that has
both the legal land descriptions and the coordinates of the center for
each quarter section in Manitoba.

``` r
quarters_dl()
```

These are basic examples which shows you the two common ways to search
for quarter sections:

#### Search using lat/long coordinates

This function takes your coordinates (decimal degrees) and locates the
nearest centre of a quarter section based on the euclidean distance
between two points. Given that most quarter sections are a half mile
square (804.7m by 804.7m) the furthest distance from the center to
corner is ~570m. You will get a warning if any distances are greater
than 600m and an error is the distance is greater than 1000m. The tibble
that is returned provides the legal land descriptions, centre
coordinates, user provided coordinates, and the distance from the
coordinates provided to the closest quarter section centre.

``` r
search_coord(long = c(-101.4656, -99.99768), lat = c(51.81913, 49.928926))
#> # A tibble: 2 × 7
#>   legal         type      long   lat long_user lat_user  dist
#>   <chr>         <chr>    <dbl> <dbl>     <dbl>    <dbl>   [m]
#> 1 NE-11-33-29W1 Quarter -101.   51.8    -101.      51.8  29.9
#> 2 NW-15-11-19W1 Quarter -100.0  49.9    -100.0     49.9 211.
```

#### Search using legal land descriptions

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
#> # A tibble: 2 × 4
#>   legal         type      long   lat
#>   <chr>         <chr>    <dbl> <dbl>
#> 1 NE-11-33-29W1 Quarter -101.   51.8
#> 2 SW-20-2-1W1   Quarter  -97.6  49.1
```

#### Map quarter sections

You can also quickly plot the center coordinates and an outline
(polygon) of located quarter sections on an interactive map. Outlines
are only provided for quarter sections as the the dimensions and
orientation of the other land division types vary.

``` r
example <- search_legal(x = c("NE-1-12-12E1", "NE-11-33-29W1"))
map_quarter(example)
#> Polygons for quarter sections are approximate and are only meant as
#>     a visual aid.
```
