# List Custom JavaScripts for Processing Sentinel Hub Data

Custom Eval Scripts, that can be used in Sentinel Hub requests, for
processing data. This functions lists scripts available from
<https://github.com/sentinel-hub/custom-scripts>. They can be retrieved
with
[`dse_sh_get_custom_script()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_get_custom_script.md).

## Usage

``` r
dse_sh_custom_scripts(...)
```

## Arguments

- ...:

  Ignored

## Value

Returns a `data.frame` with custom scripts, containing a column with a
title and one with a relative URL.

## Details

Make sure that you have sufficient monthly quota left to process images.
You can check with
[`dse_usage()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_usage.md).

## References

- <https://custom-scripts.sentinel-hub.com/>

- <https://github.com/sentinel-hub/custom-scripts>

## See also

Other sentinelhub:
[`dse_sh_collections()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_collections.md),
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
  dse_sh_custom_scripts()
}
```
