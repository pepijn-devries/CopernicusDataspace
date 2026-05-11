# Convert Uniform Resource Identifier to Virtual System Identifier

Convert Uniform Resource Identifier (URI) to Virtual System Identifier
(VSI). The Copernicus Data Space Ecosystem returns URIs for accessing
assets. Packages that use the GDAL library (e.g., `stars`, `terra` and
`gdalraster`) can use VSI to access raster data directly. Use this
function to convert such an URI to a VIS.

## Usage

``` r
dse_s3_uri_to_vsi(uri, streaming = TRUE)
```

## Arguments

- uri:

  A Uniform Resource Identifier, pointing to an S3 storage file. You can
  retrieve one with
  [`dse_stac_get_uri()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_get_uri.md).

- streaming:

  A `logical` value that allows to toggle between `"\\vsis3\\"` and
  `"\\vsis3_streaming\\"` (default). The latter is faster for reading
  files from its resource, but does not allow random access. The first
  supports random access, but is not as fast at reading.

## Value

A `character` string representing the VSI

## See also

Other s3:
[`dse_has_s3_secret()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md),
[`dse_s3_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_download.md),
[`dse_s3_set_gdal_options()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_set_gdal_options.md)

## Examples

``` r
if (interactive()) {
  dse_stac_get_uri(
    "S1A_IW_GRDH_1SDV_20241125T055820_20241125T055845_056707_06F55C_12F9_COG",
    "vh", "sentinel-1-grd") |>
    dse_s3_uri_to_vsi()
}
```
