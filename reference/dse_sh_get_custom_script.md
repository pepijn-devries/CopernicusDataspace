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

## Examples

``` r
if (interactive()) {
  dse_sh_get_custom_script("/sentinel-2/tonemapped_natural_color/")
}
```
