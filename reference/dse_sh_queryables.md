# List Queryable Fields on Sentinel Hub

Return queryable fields for a specific collection on Sentinel Hub. This
is useful information when composing a query with
[`dse_sh_prepare_input()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_prepare_.md).
Use
[`dse_sh_collections()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_collections.md)
to list available collections.

## Usage

``` r
dse_sh_queryables(collection, ..., token = dse_access_token())
```

## Arguments

- collection:

  Collection id for which to obtain queryable fields.

- ...:

  Ignored.

- token:

  For authentication, many of the Dataspace Ecosystem uses an access
  token. Either provide your access token, or obtain one automatically
  with
  [`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  (default). Without a valid token you will likely get an "access
  denied" error.

## Value

Returns a named `list`, with information about queryable fields for the
specified `collection`.

## Examples

``` r
if (interactive() && dse_has_client_info()) {
  dse_sh_queryables("sentinel-2-l1c")
}
```
