# Get Dataspace Account Information

In order to guarantee good performance for all users, the Sentinel Hub
applies [rate
limiting](https://docs.sentinel-hub.com/api/latest/api/overview/rate-limiting/).
This policy enforces monthly quotas to your usage. To check your quota
and current usage, you can call `dse_usage()` or
`dse_user_statistics()`.

## Usage

``` r
dse_usage(..., token = dse_access_token())

dse_user_statistics(
  range = "DAYS-31",
  resolution = "DAILY",
  token = dse_access_token()
)
```

## Arguments

- ...:

  Ignored

- token:

  For authentication, many of the Dataspace Ecosystem uses an access
  token. Either provide your access token, or obtain one automatically
  with
  [`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)
  (default). Without a valid token you will likely get an "access
  denied" error.

- range:

  Specify a time range for which to obtain user statistics. The API
  expects a string starting with a capitalised time unit (`"DAYS"`,
  `"HOURS"`), followed by a dash ("-") and an integer value specifying
  the length of the period. Default is `"DAYS-31"`.

- resolution:

  Specifying a temporal resolution for the user statistics. should be
  one of `"DAILY"` (default), `"MONTHLY"`, or `"HOURLY"`.

## Value

A `data.frame` with requested information for the user associated with
the provided `token`.

## See also

[`dse_access_token()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_access_token.md)

## Examples

``` r
if (interactive() && dse_has_client_info()) {
  dse_usage()
  dse_user_statistics()
}
```
