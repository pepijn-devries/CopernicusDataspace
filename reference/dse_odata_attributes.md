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

## Examples

``` r
if (interactive()) {
  dse_odata_attributes()
}
```
