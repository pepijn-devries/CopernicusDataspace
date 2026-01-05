# TODO

TODO

## Usage

``` r
dse_stac_search(..., token = dse_access_token())
```

## Arguments

- ...:

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

## Examples

``` r
if (interactive()) {
  dse_stac_search_filter() #TODO
  dse_stac_search() #TODO
}
```
