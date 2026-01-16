# Download Asset From STAC Catalogue

Use
[`dse_stac_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_search_request.md)
to identify assets that can be downloaded. Use `dse_stac_download()` to
download an asset by its STAC id and asset name.

## Usage

``` r
dse_stac_download(
  asset_id,
  asset,
  collection = dse_stac_guess_collection,
  destination,
  ...,
  s3_key = dse_s3_key(),
  s3_secret = dse_s3_secret(),
  token = dse_access_token()
)
```

## Arguments

- asset_id:

  STAC id, used for locating the asset download details.

- asset:

  Name of the asset to download

- collection:

  The identifier for a collection. The default argument is the
  [`dse_stac_guess_collection()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_guess_collection.md)
  function which tries to guess the collection id from the `asset_id`. A
  more rigid approach is to provide the collection id as a `character`
  string.

- destination:

  Directory path where to store the downloaded file.

- ...:

  Ignored

- s3_key, s3_secret:

  The s3 key and secret registered under your Data Space Ecosystem
  account

- token:

  For authentication, many of the Dataspace Ecosystem uses an access
  token. Either provide your access token, or obtain one automatically
  with
  [`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  (default). Without a valid token you will likely get an "access
  denied" error.

## Value

Returns the path to the downloaded file.

## Examples

``` r
if (interactive() && (dse_has_s3_secret() || dse_has_client_info())) {
  dse_stac_download(
    asset_id = "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148",
    asset = "B01",
    destination = tempdir()
  )
}
```
