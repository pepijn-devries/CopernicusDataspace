# List Sentinel Hub Collections

List collections that are available from the Sentinel Hub.

## Usage

``` r
dse_sh_collections(...)
```

## Arguments

- ...:

  Ignored

## Value

Returns a `data.frame` with information about the collections available
from the Sentinel Hub

## See also

Other sentinelhub:
[`dse_sh_custom_scripts()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_custom_scripts.md),
[`dse_sh_features()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_features.md),
[`dse_sh_get_custom_script()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_get_custom_script.md),
[`dse_sh_prepare_input()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_prepare_.md),
[`dse_sh_process()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_process.md),
[`dse_sh_queryables()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_queryables.md),
[`dse_sh_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_search_request.md),
[`dse_sh_use_requests_builder()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_use_requests_builder.md)

## Examples

``` r
if (interactive()) {
  dse_sh_collections()
}
```
