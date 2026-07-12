# Get a Summary of all Data Space Ecosystem Collections

Use the STAC API to get a summary of all collections available from the
interface.

## Usage

``` r
dse_stac_collections(collection, limit = 1000L, ...)
```

## Arguments

- collection:

  A specific collection for which to obtain summary information. If
  missing (default), all collections are returned.

- limit:

  Maximum number of collections to be returned.

- ...:

  Ignored

## Value

Returns a `data.frame` with the requested information

## See also

Other stac:
[`dse_stac_client()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_client.md),
[`dse_stac_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_download.md),
[`dse_stac_get_uri()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_get_uri.md),
[`dse_stac_guess_collection()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_guess_collection.md),
[`dse_stac_queryables()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_queryables.md),
[`dse_stac_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_search_request.md)

## Examples

``` r
if (interactive()) {
  dse_stac_collections()
  dse_stac_collections("sentinel-2-l2a")
}
```
