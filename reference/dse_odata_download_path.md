# TODO

TODO Often doesn't work

## Usage

``` r
dse_odata_download_path(
  product,
  destination,
  compressed = TRUE,
  ...,
  token = dse_access_token()
)
```

## Arguments

- product:

  TODO

- destination:

  TODO

- compressed:

  A `logical` value. If set to`TRUE` (default), the product will be
  downloaded as a zipped archive file.

- ...:

  TODO

- token:

  TODO

## Examples

``` r
if (interactive() && dse_has_client_info()) {
  ##TODO examples not always working
  dse_odata_download_path(
    "85d8fe9d-cf8e-4c51-b4fd-7b811b514673",
    tempfile(fileext = ".nc"), compressed = FALSE)

  dse_odata_download_path(
    "002f0c9e-8a4c-465b-9e03-479475947630",
    tempfile(fileext = ".zip"))
}
```
