# Download a Quicklook for a Product

Downloads a 'quicklook' for a product. If the `rstudioapi` package is
installed, it will attempt to open the image in the Viewer panel.

## Usage

``` r
dse_odata_quicklook(product, destination, ...)
```

## Arguments

- product:

  Identifier (Id) for the product for which to obtain a quicklook.

- destination:

  A destination path where to store the image.

- ...:

  Ignored

## Value

Returns `NULL` invisibly

## See also

Other odata:
[`dse_odata_attributes()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_attributes.md),
[`dse_odata_bursts_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_bursts.md),
[`dse_odata_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_download.md),
[`dse_odata_download_path()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_download_path.md),
[`dse_odata_product_nodes()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_product_nodes.md),
[`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md)

## Examples

``` r
if (interactive()) {
  dse_odata_quicklook(
    "91822f33-b15c-5b60-aa39-6d9f6f5c773b",
    tempfile(fileext = ".jpg"))
}
```
