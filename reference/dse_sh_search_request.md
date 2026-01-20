# Create a Request for the SentinelHub Catalogue

In order to perform a search using the STAC API, you first need to
create a request using `dse_sh_search_request()`. This creates a
[`httr2::request()`](https://httr2.r-lib.org/reference/request.html) to
which tidy verbs
[`?tidy_verbs`](https://pepijn-devries.github.io/CopernicusDataspace/reference/tidy_verbs.md)
can be applied (e.g.,
[`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html)
and
[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html).
Results are retrieved by calling
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
on the request.

## Usage

``` r
dse_sh_search_request(
  collection,
  bbox,
  datetime,
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

Returns a `sentinel_request` class object, which inherits from the
[`httr2::request`](https://httr2.r-lib.org/reference/request.html)
class. Call
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
on it to retrieve results.

## References

- <https://docs.sentinel-hub.com/api/latest/api/catalog/>

## Examples

``` r
if (interactive() && dse_has_client_info()) {
  library(dplyr)
  
  dse_sh_search_request(
    collection = "sentinel-2-l2a",
    bbox       = c(5.261, 52.680, 5.319, 52.715),
    datetime   = c("2025-01-01 UTC", "2025-01-31 UTC")
  ) |>
    filter(`eo:cloud_cover` <= 10) |>
    collect()
}
```
