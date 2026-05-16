# Use Requests Builder to Send Processing Request to SentinelHub

Use [Sentinel Requests
Builder](https://shapps.dataspace.copernicus.eu/requests-builder/) to
compose a request. Copy the text from the 'Request Preview' panel and
submit with this function. Use
[`dse_sh_process()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_process.md)
when you want to define a request in R, without using a web browser.

## Usage

``` r
dse_sh_use_requests_builder(
  build,
  destination,
  ...,
  token = dse_access_token()
)
```

## Arguments

- build:

  A `character` string copied from the Request Preview panel at
  [Sentinel Requests
  Builder](https://shapps.dataspace.copernicus.eu/requests-builder/).
  See
  `system.file("requests-builder.txt", package = "CopernicusDataspace")`
  for an example of such a text. When you omit this argument, this
  function will attempt to retrieve the text from the system's
  clipboard.

- destination:

  A file name to store the downloaded image.

- ...:

  Ignored

- token:

  For authentication, many of the Data Space Ecosystem uses an access
  token. Either provide your access token, or obtain one automatically
  with
  [`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  (default). Without a valid token you will likely get an "access
  denied" error.

## Value

A `httr2_response` class object obtained after sending the request.

## References

- <https://shapps.dataspace.copernicus.eu/requests-builder/>

## See also

Other sentinelhub:
[`dse_sh_collections()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_collections.md),
[`dse_sh_custom_scripts()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_custom_scripts.md),
[`dse_sh_features()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_features.md),
[`dse_sh_get_custom_script()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_get_custom_script.md),
[`dse_sh_prepare_input()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_prepare_.md),
[`dse_sh_process()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_process.md),
[`dse_sh_queryables()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_queryables.md),
[`dse_sh_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_search_request.md)

## Examples

``` r
## Read text copied from 'Request Preview' panel on
## <https://shapps.dataspace.copernicus.eu/requests-builder/:
requests_builder <-
  system.file("requests-builder.txt", package = "CopernicusDataspace") |>
    readLines(warn = FALSE) |>
    paste(collapse = "\n")

if (interactive() && dse_has_client_info()) {
  dest <- tempfile(fileext = ".tiff")
  dse_sh_use_requests_builder(requests_builder, destination = dest)
}
```
