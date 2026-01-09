# Download Asset Through Uniform Resource Identifier

When the Uniform Resource Identifier (URI, starting with "s3://") for an
asset is known, this function can be used to download it

## Usage

``` r
dse_s3_download(
  uri,
  destination,
  ...,
  s3_key = dse_s3_key(),
  s3_secret = dse_s3_secret()
)
```

## Arguments

- uri:

  A Uniform Resource Identifier (URI, starting with "s3://"). You can
  look for them in the STAC catalogue, either using a [web
  browser](https://browser.stac.dataspace.copernicus.eu/) or
  [`dse_stac_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_search_request.md)
  (see example).

- destination:

  Destination path where to store the downloaded file

- ...:

  Ignored

- s3_key, s3_secret:

  The s3 key and secret registered under your Data Space Ecosystem
  account

## Value

Returns `NULL` invisibly.

## Examples

``` r
if (interactive() && dse_has_s3_secret()) {
  library(dplyr)

  ## Retrieve a URI for a specific asset through the STAC
  ## catalogue:   
  my_uri <-
    dse_stac_search_request(
      ids = "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148") |>
        select("assets.B01.href") |>
        arrange("id") |>
        collect() |>
        pull("assets") |>
        unlist()
  
  dse_s3_download(my_uri, tempdir())

}
```
