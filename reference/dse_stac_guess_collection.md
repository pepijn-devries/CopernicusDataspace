# Guess the Collection id from an Asset id

As the STAC catalogue contains a large number of records, your request
may receive a timeout error. To prevent this it is best to narrow down
your requests to specific collections. This function is a helper
function that tries to guess the collection id from an asset id. Note
that this method is not highly reliable, and it is always best to
manually provide a collection id to a request.

## Usage

``` r
dse_stac_guess_collection(asset_id)
```

## Arguments

- asset_id:

  An asset identifier name, used to guess its parent collection id.

## Value

A `character` string with a guessed collection id. Or `NA` in case it
cannot make a guess.

## See also

Other stac:
[`dse_stac_client()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_client.md),
[`dse_stac_collections()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_collections.md),
[`dse_stac_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_download.md),
[`dse_stac_get_uri()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_get_uri.md),
[`dse_stac_queryables()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_queryables.md),
[`dse_stac_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_search_request.md)

## Examples

``` r
dse_stac_guess_collection(
  "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148")
#> [1] "sentinel-2-l1c"
```
