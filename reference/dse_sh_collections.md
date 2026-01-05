# List Sentinel hub collections

TODO

TODO

## Usage

``` r
dse_sh_collections(...)

dse_sh_queryables(collection, ..., token = dse_access_token())
```

## Arguments

- ...:

  TODO

- collection:

  TODO

- token:

  For authentication, many of the Dataspace Ecosystem uses an access
  token. Either provide your access token, or obtain one automatically
  with
  [`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  (default). Without a valid token you will likely get an "access
  denied" error.

## Value

TODO

TODO

## Examples

``` r
if (interactive()) {
  dse_sh_collections()
  if (dse_has_client_info()) {
    qt <- dse_sh_querytables("sentinel-2-l1c")
  }
}
#TODO
```
