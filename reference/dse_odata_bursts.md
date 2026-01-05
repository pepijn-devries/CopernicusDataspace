# Create a OData Request for a Data Space Ecosystem Bursts Data

Obtain metadata for burst data associated with specific products.

## Usage

``` r
dse_odata_bursts_request(...)

dse_odata_bursts(...)
```

## Arguments

- ...:

  Ignored

## Value

Returns a `data.frame` with burst information.

## Details

For more details about bursts check the [burst API
documentation](https://documentation.dataspace.copernicus.eu/APIs/Sentinel-1%20SLC%20Burst.html).

You can apply some tidyverse functions (see
[tidy_verbs](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md))
to `odata_request` object returned by `dse_odata_bursts_request()`.
These apply lazy evaluation. Meaning that they are just added to the
object and are only evaluated after calling either
[`dplyr::compute()`](https://dplyr.tidyverse.org/reference/compute.html)
or
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
(see examples).

## Examples

``` r
if (interactive()) {
  dse_odata_bursts(ParentProductId == "879d445c-2c67-5b30-8589-b1f478904269")
}
```
