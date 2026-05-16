# Set Copernicus Data Space Ecosystem Access Token for GDAL Driver

This function sets system environment variables, such that the GDAL
library can access the Copernicus Data Space Ecosystem https storage.
Note that these settings can be used by any package depending on the
GDAL library. Most notably: `stars`, `terra`, and `gdalraster`.

## Usage

``` r
dse_set_gdal_token(token = dse_access_token())
```

## Arguments

- token:

  For authentication, many of the Data Space Ecosystem uses an access
  token. Either provide your access token, or obtain one automatically
  with
  [`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  (default). Without a valid token you will likely get an "access
  denied" error.

## Value

Returns a `logical` value. `TRUE` if all variables were successfully
set. `FALSE` otherwise.

## See also

Other authentication:
[`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md),
[`dse_get_token_details()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_get_token_details.md),
[`dse_has_s3_secret()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_s3.md),
[`dse_usage()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_usage.md)

## Examples

``` r
if (interactive() && dse_has_client_info() &&
    requireNamespace("stars")) {
  uri <-
    dse_stac_get_uri(
      "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148",
      "B01", type = "odata")
   
  dse_set_gdal_token()

  ## As this URI is zipped, it need to be downloaded.
  ## But you can access it directly:
  jp2 <- stars::read_stars(uri)
}
```
