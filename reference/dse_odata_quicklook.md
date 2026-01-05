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

## Examples

``` r
if (interactive()) {
  dse_odata_quicklook(
    "f4a87522-dd81-4c40-856e-41d40510e3b6",
    tempfile(fileext = ".jpg"))
}
```
