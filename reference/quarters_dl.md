# Download the MB quarter section data

Downloads the full list of quarter sections and coordinates from the
Manitoba Geoportal. Note that when the Geoportal is unavailable, data is
downloaded from an archived version from the package repository on
Github.

## Usage

``` r
quarters_dl(force = FALSE, ask = TRUE, quiet = FALSE)
```

## Arguments

- force:

  Logical. If TRUE, forces a re-download of the data. Note this data
  shouldn't require regular (or any) updates.

- ask:

  Logical. If TRUE, ask to create the cache folder for MB quarter
  section data

- quiet:

  Logical. If TRUE, suppresses status messages while downloading the
  data

## Value

Nothing. But has the side effect of downloading a .csv file of Manitoba
Original Survey Legal Descriptions and coordinates to the cache folder
(`cache_dir()`).

## Details

This data set should be static.

## Examples

``` r
if (FALSE) { # interactive()
quarters_dl()

}
```
