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

## See also

Other odata:
[`dse_odata_attributes()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_attributes.md),
[`dse_odata_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_download.md),
[`dse_odata_download_path()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_download_path.md),
[`dse_odata_product_nodes()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_product_nodes.md),
[`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md),
[`dse_odata_quicklook()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_quicklook.md)

Other odata:
[`dse_odata_attributes()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_attributes.md),
[`dse_odata_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_download.md),
[`dse_odata_download_path()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_download_path.md),
[`dse_odata_product_nodes()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_product_nodes.md),
[`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md),
[`dse_odata_quicklook()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_quicklook.md)

## Examples

``` r
if (interactive() && dse_has_s3_secret()) {
  dse_odata_bursts(ParentProductId == "879d445c-2c67-5b30-8589-b1f478904269")
  
  burst_req <-
    dse_odata_bursts_request(ParentProductId == "879d445c-2c67-5b30-8589-b1f478904269")
  
  ## Note that these are large files and may take a while to download:
  dse_odata_download(
    burst_req,
    tempdir()
  )
}
```
