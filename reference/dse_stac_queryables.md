# Get Queryables for a STAC collection

When searching through a collection with
[`dse_stac_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_search_request.md),
it can be helpful to know which elements can be used to filter the
search results (using
[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html)).
Calling `dse_stac_queryables()` tells you which aspects are available
for querying and expected formats.

## Usage

``` r
dse_stac_queryables(collection, ...)
```

## Arguments

- collection:

  Name of the collection for which to get the queryables.

- ...:

  Ignored

## Value

Returns a named list with information about elements that can be used to
query the `collection`

## Examples

``` r
if (interactive()) {
  dse_stac_queryables("sentinel-1-grd")
}
```
