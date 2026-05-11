# List OData Attributes

Collect a list of OData attributes that can be used for filtering
products with
[`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md).

## Usage

``` r
dse_odata_attributes(...)
```

## Arguments

- ...:

  Ignored

## Value

A `data.frame` listing all attributes for each collection.

## See also

Other odata:
[`dse_odata_bursts_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_bursts.md),
[`dse_odata_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_download.md),
[`dse_odata_download_path()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_download_path.md),
[`dse_odata_product_nodes()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_product_nodes.md),
[`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md),
[`dse_odata_quicklook()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_quicklook.md)

## Examples

``` r
if (interactive()) {
  dse_odata_attributes()
}
```
