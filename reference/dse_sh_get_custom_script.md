# Retrieve Custom JavaScripts to be Used by Sentinel Hub

Sentinel Hub uses JavaScripts to process satellite images. There is a
repository with such custom scripts. They can be listed with
[`dse_sh_custom_scripts()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_custom_scripts.md).
Use the relative URL (relUrl) from that list to obtain the actual script
with this function.

## Usage

``` r
dse_sh_get_custom_script(rel_url)
```

## Arguments

- rel_url:

  A relative URL found with
  [`dse_sh_custom_scripts()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_custom_scripts.md).

## Value

A `character` string containing JavaScript code. This script can be used
with
[`dse_sh_process()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_process.md)

## See also

Other sentinelhub:
[`dse_sh_collections()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_collections.md),
[`dse_sh_custom_scripts()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_custom_scripts.md),
[`dse_sh_features()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_features.md),
[`dse_sh_prepare_input()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_prepare_.md),
[`dse_sh_process()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_process.md),
[`dse_sh_queryables()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_queryables.md),
[`dse_sh_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_search_request.md),
[`dse_sh_use_requests_builder()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_use_requests_builder.md)

## Examples

``` r
if (interactive()) {
  dse_sh_get_custom_script("/sentinel-2/tonemapped_natural_color/")
}
```
