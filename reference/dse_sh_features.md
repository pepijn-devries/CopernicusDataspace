# List Sentinel Hub Features

List Sentinel Hub features for a specified period and region.

## Usage

``` r
dse_sh_features(
  collection,
  bbox,
  datetime,
  limit = 10,
  ...,
  token = dse_access_token()
)
```

## Arguments

- collection:

  A collection for which to list the features. See
  [`dse_sh_collections()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_sh_collections.md)
  for a list of Sentinel Hub collections.

- bbox:

  An object that can be converted into a `bbox` class object (see
  [`sf::st_bbox()`](https://r-spatial.github.io/sf/reference/st_bbox.html)).

- datetime:

  A date-time object, or a vector of two date time objects (in case of a
  range). Or an object that can be converted into a datetime object.

- limit:

  The number of records to which the output is limited. Should be
  between 1 and 100, and defaults to 10.

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

Returns a `data.frame` listing features available on SentinelHub for
processing.

## Examples

``` r
if (interactive() && dse_has_client_info()) {
  dse_sh_features(
    collection = "sentinel-2-l2a",
    bbox       = c(5.261, 52.680, 5.319, 52.715),
    datetime   = c("2025-01-01 UTC", "2025-01-07 UTC"))
}
```
