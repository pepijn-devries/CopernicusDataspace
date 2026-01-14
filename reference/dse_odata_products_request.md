# Create a OData Request for a Data Space Ecosystem Product

OData is an application programming interface (API) used to disseminate
Copernicus Data Space Ecosystem products. This function creates a
request for this service, which can be used to obtain a `data.frame`
with product information. This request supports several tidyverse
methods for filtering and arranging the data.

## Usage

``` r
dse_odata_products_request(..., expand)

dse_odata_products(..., expand = NULL)
```

## Arguments

- ...:

  Ignored in case of `dse_odata_products_request()`. Dots are passed to
  embedded
  [`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html)
  in case of `dse_odata_products()`

- expand:

  Additional information to be appended to the result. Should be any of
  `"Attributes"`, `"Assets"`, or `"Locations"`. Note that, these columns
  are not affected by
  [`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html)
  calls (before calling
  [`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)).

## Value

Returns an `odata_request` class object in case of
`dse_odata_products_request()`, which is an extension of
[`httr2::request()`](https://httr2.r-lib.org/reference/request.html). In
case of `dse_odata_products()` a `data.frame` listing requested products
is returned.

## Details

You can apply some tidyverse functions (see
[tidy_verbs](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md))
to `odata_request` object returned by `dse_odata_products_request()`.
These apply lazy evaluation. Meaning that they are just added to the
object and are only evaluated after calling either
[`dplyr::compute()`](https://dplyr.tidyverse.org/reference/compute.html)
or
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
(see examples).

## References

<https://documentation.dataspace.copernicus.eu/APIs/OData.html>

## Examples

``` r
if (interactive()) {
  bbox <-
    sf::st_bbox(
      c(xmin = 5.261, ymin = 52.680, xmax = 5.319, ymax = 52.715),
      crs = 4326) |>
      sf::st_as_sfc()

  dse_odata_products_request() |>
    dplyr::filter(
      `ContentDate/Start` > "2025-01-01") |>
    sf::st_intersects(bbox) |>
    dplyr::arrange(dplyr::desc(Id)) |>
    dplyr::slice_head(n = 100) |>
    dplyr::collect()
}
```
