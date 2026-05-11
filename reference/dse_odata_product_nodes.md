# List OData Product Nodes (i.e. Files and Directories)

If you know the product `Id`, you can use this function to retrieve
information about nodes (i.e. files and directories) within the product.

## Usage

``` r
dse_odata_product_nodes(product, node_path = "", recursive = FALSE, ...)
```

## Arguments

- product:

  A product identifier (`Id`)

- node_path:

  Path of nodes separated by forward slashes (`"/"`). Path for which to
  list nodes. Default is `""`, which is the root of the product

- recursive:

  A `logical` value. If set to `TRUE`, it will recursively list all
  nested nodes. Default is `FALSE`.

- ...:

  Ignored

## Value

A `data.frame` with information on the requested node(s)

## See also

Other odata:
[`dse_odata_attributes()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_attributes.md),
[`dse_odata_bursts_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_bursts.md),
[`dse_odata_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_download.md),
[`dse_odata_download_path()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_download_path.md),
[`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md),
[`dse_odata_quicklook()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_quicklook.md)

## Examples

``` r
if (interactive()) {
  nodes <- dse_odata_product_nodes("c8ed8edb-9bef-4717-abfd-1400a57171a4")
  nodes <- dse_odata_product_nodes("c8ed8edb-9bef-4717-abfd-1400a57171a4",
                                   recursive = TRUE)
}
```
