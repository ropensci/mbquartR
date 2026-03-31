# Search for the coordinates of MB quarter sections

Find the centre coordinates of quarter sections and other legal division
types using the legal land description.

## Usage

``` r
search_legal(x)
```

## Arguments

- x:

  Character. Vector of quarter section legal land descriptions you wish
  to search for.

## Value

A tibble of legal land descriptions, division type, and corresponding
latitude and longitude coordinates.

## Details

A legal land description for a quarter section consists of four values
separated by a -

1.  Quarter Section (SW)

2.  Section (9)

3.  Township (8)

4.  Range (6E1)

For example: A legal land description of SW-9-8-6E1 can be interpreted
as the Southwest Quarter of Section 9, Township 8, Range 6 East of the
1st Meridian.

`search_legal()` takes legal land descriptions and locates the centre
coordinates of the quarter sections. You can include leading zeroes
(e.g., NE-01-012-12E1) or not (e.g., NE-1-12-12E1). The data set used in
this package includes three meridians (W1, E1, and E2); however, most
commonly searched for quarter sections use the East 1 (E1) or West 1
(W1) meridians. If the meridian number is not included it will default
to 1. For example, a search for NW-36-89-11E will by default search for
NW-36-89-11E1 despite NW-36-89-11E2 existing in the data set.

Other land division types can have different naming conventions and
include:

- RL = River lot (e.g., RL-11-Oak Island)

- Lot = Township lot (e.g., 10-54-27W1)

- OT = Outer two mile lot (e.g., OT-11A-St. Clements)

- PL = Parish lot (e.g., PL-R-St. Andrews)

- SL = Settlement lot (e.g., SL-2-Roman Catholic Mission Property)

- WL = Wood lot (e.g., WL-179-Portage La Prairie)

## Examples

``` r
search_legal(x = c("NE-11-33-29W", "SW-20-2-1W"))
#> # A tibble: 2 × 4
#>   legal         type      long   lat
#>   <chr>         <chr>    <dbl> <dbl>
#> 1 NE-11-33-29W1 Quarter -101.   51.8
#> 2 SW-20-2-1W1   Quarter  -97.6  49.1
```
