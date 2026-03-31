# Two examples of using mbquartR

## Introduction

The `mbquartR` package was created to help people easily identify,
search, and locate parcels of land using the Manitoba legal
descriptions. These legal land descriptions originate from the [Dominion
Land Survey system](https://en.wikipedia.org/wiki/Dominion_Land_Survey),
introduced in the late 19th century to organize the European settlement
and colonization of Western Canada.

There are two main ways in which the `mbquartR` can be used.

1.  Search for and locate parcels of land using legal land descriptions
    (e.g., SW-9-8-6E1)

or

2.  Search for legal land description using coordinates (latitude and
    longitude)

**Note:** The examples below are fictitious scenarios designed to
highlight the functionality of the `mbquartR` package. The identified
land parcels and coordinates are not intended for any official or
practical use.

### Example 1: Using legal land description to find the locations of archived soil samples

Since 1926, the [Manitoba Soil
Survey](https://www.gov.mb.ca/agriculture/soil/soil-survey/index.html)
has been working to quantify and map soil properties (texture, parent
material, stoniness, pH, and salinity etc) to support sustainable
agricultural development across the province. Part of the soil survey
has included collecting soil samples for chemical analysis (Carbon
content). This has resulted in a rich archive of soil samples spanning
more than eight decades. Recently there has been interest in reanalyzing
these archived soil samples using new technology. However, the location
of many older soil samples is identified solely by the quarter section
description.

For many people, including myself, we are not familiar enough with land
survey system to easily locate it. There are over 900,000 entries in the
Manitoba Original Survey Legal Descriptions data covering more than
600,000 km². Most mapping services are also unable to search for legal
land description (e.g., Google Maps) which makes identifying where these
soil sample were taken very difficult!

For an explanation of quarter sections and other land types, please
visit the [Get
started](https://docs.ropensci.org/mbquartR/articles/mbquartR.html)
page.

#### Scenario:

Here is a small data set that includes the soil organic carbon content
(%) of four topsoil samples (0-15 cm depth) collected in 1980 as part of
the Soil Survey at four different locations only identified by their
legal land description. I would like to know where these soil samples
were taken so I have some additional context for interpreting the data.
Three of these samples were collected in Quarter Sections (most common
type of land division) and one was collected in a River Lot

``` r
soil_soc <- data.frame(
  soc = c(1.72, 2.35, 3.08, 3.94),
  legal = c("SW-14-8-2E1", "NE-22-08-1E", "NW-10-9-1E1", "RL-22-St. Norbert"))
soil_soc
#>    soc             legal
#> 1 1.72       SW-14-8-2E1
#> 2 2.35       NE-22-08-1E
#> 3 3.08       NW-10-9-1E1
#> 4 3.94 RL-22-St. Norbert
```

#### Download the data set

Your first step is to load the package and then download the Manitoba
Original Survey Legal Descriptions data from
[DataMB](https://geoportal.gov.mb.ca/) which `mbquartR` helps you do.

Load `mbquartR`

``` r
library(mbquartR)
```

Download data set

``` r
quarters_dl()
```

#### Search

We can now use
[`search_legal()`](https://docs.ropensci.org/mbquartR/reference/search_legal.md)
to find the center coordinates (latitude and longitude) for each of the
parcels of land in our data frame. To use this function you need to
supply a vector that contains the legal land descriptions of interest.
This will return data frame that includes the type of land division and
the coordinates of the centre.

``` r
location_1 <- search_legal(x = soil_soc$legal)
#> Warning in search_legal(x = soil_soc$legal): One or more of the legal land descriptions has an ambiguous meridian value E and is assumed to be east of prime meridian (E1).
#> To stop messages please specify meridians as E1 or E2 (e.g., NW-36-89-11E1).
location_1
#> # A tibble: 4 × 4
#>   legal             type     long   lat
#>   <chr>             <chr>   <dbl> <dbl>
#> 1 NE-22-8-1E1       Quarter -97.4  49.7
#> 2 NW-10-9-1E1       Quarter -97.4  49.7
#> 3 SW-14-8-2E1       Quarter -97.2  49.7
#> 4 RL-22-St. Norbert RL      -97.1  49.7
```

#### Map

We can also use
[`map_quarter()`](https://docs.ropensci.org/mbquartR/reference/map_quarter.md)
to quickly plot the center coordinates on a map. Because quarter
sections are a square of known dimensions a polygon is also displayed
showing the approximate borders. This is not done for other land
divisions because the dimensions and orientation are inconsistent.

``` r
map_quarter(location_1)
#> Polygons for quarter sections are approximate and are only meant as
#>     a visual aid.
#> Warning: One or more of the legal land descriptions provided are a type of
#>     land division other than a quarter section and the polygon can not be
#>     estimated.
```

### Example 2: Using coordinates to find parcels of land

As an agri-environmental scientist I take a lot of soil samples on farms
as part of research projects and I always geo-locate sampling sites so I
can revisit them at a later date. When reporting results back to
producers/farmers it is often easiest to refer to locations by their
legal land descriptions because these descriptions are familiar and are
tied to how farmers manage their land. The example below presents a
small data frame of surface soil sample P concentrations (ppm), all
collected from the watershed, along with their corresponding
coordinates.

``` r
soil_p <- data.frame(
  lat = c(49.333854, 49.338577, 49.356048, 49.372180),
  long = c(-98.376486, -98.376862, -98.304846, -98.254691),
  p_conc = c(8.75, 12.30, 17.45, 22.60),
  sample_id = factor(seq(1, 4, 1)))
soil_p
#>        lat      long p_conc sample_id
#> 1 49.33385 -98.37649   8.75         1
#> 2 49.33858 -98.37686  12.30         2
#> 3 49.35605 -98.30485  17.45         3
#> 4 49.37218 -98.25469  22.60         4
```

#### Search

Using
[`search_coord()`](https://docs.ropensci.org/mbquartR/reference/search_coord.md)
we provide coordinates, in decimal degrees, and it searches for the
quarter section, or other land division type, based on the shortest
euclidean distance to the centre of a parcel of land. Because the data
being search is so big this function can take a little while to run.
This function returns the legal land description, land division type,
the center coordinates, user coordinates, and the distance between the
user provided coordinates and the centre coordinates. In the example
below I have collected soil samples from two different farm fields that
happen to be within the same quarter section

``` r
location_2 <- search_coord(lat = soil_p$lat, long = soil_p$long)
location_2
#> # A tibble: 4 × 7
#>   legal       type     long   lat long_user lat_user dist
#>   <chr>       <chr>   <dbl> <dbl>     <dbl>    <dbl>  [m]
#> 1 NW-29-4-7W1 Quarter -98.4  49.3     -98.4     49.3 414.
#> 2 NW-29-4-7W1 Quarter -98.4  49.3     -98.4     49.3 370.
#> 3 SE-2-5-7W1  Quarter -98.3  49.4     -98.3     49.4 361.
#> 4 SE-7-5-6W1  Quarter -98.3  49.4     -98.3     49.4 168.
```

#### Map

For a quick reference I can quickly plot the centre coordinates and the
approximate boundaries of these quarter sections using
[`map_quarter()`](https://docs.ropensci.org/mbquartR/reference/map_quarter.md).

``` r
map_quarter(location_2)
#> Polygons for quarter sections are approximate and are only meant as
#>     a visual aid.
```

I can also add my sampling locations to the map by first converting my
original data frame to an `sf` object.

``` r
point <- sf::st_as_sf(soil_p, coords = c("long", "lat"),
                      crs = "+proj=longlat +datum=WGS84")
```

Then adding this `sf` object as an additional layer

``` r
map_quarter(location_2) + 
  mapview::mapview(point, col.regions = "black", 
                   color = "black", legend =FALSE)
#> Polygons for quarter sections are approximate and are only meant as
#>     a visual aid.
```
