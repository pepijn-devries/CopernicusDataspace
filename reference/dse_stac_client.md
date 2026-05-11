# Obtain Information About the STAC Client

Returns information about the STAC client used in the Data Space
Ecosystem

## Usage

``` r
dse_stac_client(...)
```

## Arguments

- ...:

  Ignored

## Value

Returns a `data.frame` with the requested information

## See also

Other stac:
[`dse_stac_collections()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_collections.md),
[`dse_stac_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_download.md),
[`dse_stac_get_uri()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_get_uri.md),
[`dse_stac_guess_collection()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_guess_collection.md),
[`dse_stac_queryables()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_queryables.md),
[`dse_stac_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_search_request.md)

## Examples

``` r
if (interactive()) {
  dse_stac_client()
}
```
