# Get a Summary of all Data Space Ecosystem Collections

Use the STAC API to get a summary of all collections available from the
interface.

## Usage

``` r
dse_stac_collections(collection, ...)
```

## Arguments

- collection:

  A specific collection for which to obtain summary information. If
  missing (default), all collections are returned.

- ...:

  Ignored

## Value

Returns a `data.frame` with the requested information

## Examples

``` r
if (interactive()) {
  dse_stac_collections()
  dse_stac_collections("sentinel-2-l2a")
}
```
