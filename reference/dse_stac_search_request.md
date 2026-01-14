# Create a Request for a STAC Search in the Data Space Ecosystem

In order to perform a search using the STAC API, you first need to
create a request using `dse_stac_search_request()`. This creates a
[`httr2::request()`](https://httr2.r-lib.org/reference/request.html) to
which tidy verbs
[`?tidy_verbs`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
can be applied (e.g.,
[`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html),
[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html)
and
[`dplyr::arrange()`](https://dplyr.tidyverse.org/reference/arrange.html).
Results are retrieved by calling
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
on the request.

## Usage

``` r
dse_stac_search_request(collections, ids, ...)
```

## Arguments

- collections:

  Restrict the search to the collections listed here.

- ids:

  Restrict the search to ids listed here.

- ...:

  Arguments appended to search filter request body.

## Value

Returns a `data.frame` with search results.

## Details

If you prefer a graphical user interface, you can alternatively use the
[STAC web browser](https://browser.stac.dataspace.copernicus.eu/).

## Examples

``` r
if (interactive()) {
  library(dplyr)
  library(sf)
  
  bbox <-
    sf::st_bbox(
      c(xmin = 5.261, ymin = 52.680, xmax = 5.319, ymax = 52.715),
      crs = 4326)

  dse_stac_search_request("sentinel-2-l1c") |>
    filter(`eo:cloud_cover` < 10) |>
    collect()

  dse_stac_search_request("sentinel-1-grd") |>
    filter(`sat:orbit_state` == "ascending") |>
    arrange("id") |>
    st_intersects(bbox) |>
    collect()
}
```
