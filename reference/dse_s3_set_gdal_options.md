# Set-up S3 Configuration for GDAL Library

This function sets system environment variables, such that the GDAL
library can access the Copernicus Data Space Ecosystem S3 storage. Note
that these settings can be used by any package depending on the GDAL
library. Most notably: `stars`, `terra`, and `gdalraster`.

## Usage

``` r
dse_s3_set_gdal_options(
  region = "us-east-1",
  ...,
  s3_key = dse_s3_get_key(),
  s3_secret = dse_s3_get_secret()
)
```

## Arguments

- region:

  [AWS
  Region](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/)
  used in instantiating the S3 client

- ...:

  Ignored

- s3_key, s3_secret:

  The s3 key and secret registered under your Data Space Ecosystem
  account

## Value

Returns a `logical` value. `TRUE` if all variables were successfully
set. `FALSE` otherwise.

## See also

Other s3:
[`dse_has_s3_secret()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md),
[`dse_s3_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_download.md),
[`dse_s3_uri_to_vsi()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3_uri_to_vsi.md)

## Examples

``` r
if (interactive() && dse_has_s3_secret() &&
    requireNamespace("stars")) {
  library(dplyr)

  ## Get a Virtual System Interface to a tiff file:
  vsi <-
    dse_stac_get_uri(
      "S1A_IW_GRDH_1SDV_20241125T055820_20241125T055845_056707_06F55C_12F9_COG",
      "vh", "sentinel-1-grd") |>
      dse_s3_uri_to_vsi()

  ## Make sure to set gdal options with required S3 settings
  dse_s3_set_gdal_options()
   
  ## You can now read the file directly from the online storage
  ## without having to download it completely:
  cog <- stars::read_stars(vsi)
   
  ## You can also easily plot a downsampled version
  plot(cog, downsample = 50)
}
```
