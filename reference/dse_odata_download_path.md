# Alternative Route to Download OData Products

Downloading data using the OData API is probably fastest by using
[`dse_odata_download()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_download.md).
As an alternative, you can use this function which uses the https
protocol to download a product.

## Usage

``` r
dse_odata_download_path(
  product,
  node_path = "",
  destination,
  ...,
  token = dse_access_token()
)
```

## Arguments

- product:

  Hexadecimal id of the product to be downloaded

- node_path:

  Path to a specific file in the product. When left blank (`""`) The
  function will attempt to download the entire product as a zip archive.

- destination:

  Path to a directory where to store the downloaded file

- ...:

  Ignored

- token:

  For authentication, many of the Dataspace Ecosystem uses an access
  token. Either provide your access token, or obtain one automatically
  with
  [`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  (default). Without a valid token you will likely get an "access
  denied" error.

## Value

Returns a `httr2_response` class object. It's body will hold the
filename of the downloaded file

## Examples

``` r
if (interactive() && dse_has_client_info()) {

  dse_odata_download_path(
    product     = "2f497806-0101-5eea-83fa-c8f68bc56b0c",
    node_path   = 
      paste("DEM1_SAR_DTE_90_20101213T034716_20130408T035028_ADS_000000_5033.DEM",
            "Copernicus_DSM_30_S09_00_E026_00", "DEM",
            "Copernicus_DSM_30_S09_00_E026_00_DEM.dt1", sep = "/"),
    destination = tempdir()
  )
  
  dse_odata_download_path(
    product     = "ce4576eb-975b-40ff-8319-e04b00d8d444",
    destination = tempdir())

}
```
