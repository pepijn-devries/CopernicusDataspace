# Filter OData and STAC Requests Using Geometries

Filters OData and STAC rows that intersect with spatial feature `y`.

## Usage

``` r
# S3 method for class 'odata_request'
st_intersects(x, y, sparse = FALSE, ...)

# S3 method for class 'stac_request'
st_intersects(x, y, sparse = FALSE, ...)
```

## Arguments

- x:

  Either an `odata_request` class object, generated with
  [`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md)/[`dse_odata_bursts_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_bursts.md);
  or a `stac_request` generated with
  [`dse_stac_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_search_request.md).

- y:

  A spatial geometry of either class `sf` (see
  [`sf::st_as_sf()`](https://r-spatial.github.io/sf/reference/st_as_sf.html))
  or `sfc` (see
  [`sf::st_as_sfc()`](https://r-spatial.github.io/sf/reference/st_as_sfc.html)).
  It will always be transformed to WGS 84 projection (EPSG:4326).

- sparse:

  Argument inherited from generic definition. Ignored in this context

- ...:

  Ignored

## Value

Returns an object of the same class as `x`, with the geometry filter
added to it.

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
    dplyr::collect()

  dse_stac_search_request() |>
    st_intersects(bbox) |>
    dplyr::collect()
}
```
