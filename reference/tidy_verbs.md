# Tidy Verbs for OData API and STAC Requests

Implementation of tidy generics for features supported by either OData
or STAC API requests. They can be called on objects of either class:
`odata_request` or `stac_request`. The first is produced by
[`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md)
and
[`dse_odata_bursts_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_bursts.md);
the latter by
[`dse_stac_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_search_request.md).

## Usage

``` r
filter.odata_request(.data, ..., .by = NULL, .preserve = FALSE)

filter.stac_request(.data, ..., .by = NULL, .preserve = FALSE)

compute.odata_request(x, skip = 0L, ...)

collect.odata_request(x, skip = 0L, ...)

collect.stac_request(x, ...)

arrange.odata_request(.data, ..., .by_group = FALSE)

arrange.stac_request(.data, ..., .by_group = FALSE)

slice_head.odata_request(.data, ..., n, prop, by = NULL)

slice_head.stac_request(.data, ..., n, prop, by = NULL)

select.odata_request(.data, ...)

select.stac_request(.data, ...)
```

## Arguments

- .data, x:

  An object of either class `odata_request` or `stac_request`. These are
  produced by
  [`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md),
  [`dse_odata_bursts_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_bursts.md)
  and
  [`dse_stac_search_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_stac_search_request.md)

- ...:

  Data masking expressions, or arguments passed to embedded functions

- skip:

  Number of rows to skip when collecting results. The API never returns
  more than 20 rows. Specify the number of rows to skip in order to get
  results beyond the first 20 rows.

- n:

  Maximum number of rows to return.

- by, .by, .by_group, .preserve, prop:

  Arguments inherited from generic `dplyr` functions. Ignored in the
  current context as either grouping is not allowed for an OData API
  request or is otherwise not supported.

## Value

All functions (except `collect()`) return a modified
`stac_request`/`odata_request` object, containing the lazy tidy
operations. `collect()` will return a
[`data.frame()`](https://rdrr.io/r/base/data.frame.html) yielding the
result of the request.

## Details

The `odata_request` and `stac_request` class objects use lazy
evaluation. This means that functions are only evaluated after calling
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
on a request.

Note that you should not call the functions exported in this package
directly. Instead, call the generics as declared in the `dplyr` package.
This is illustrated by the examples.

### Slice Head

In order to manage server traffic, the OData API never returns more than
20 rows. If you want to obtain results beyond the first 20 rows, you
need to specify the `skip` argument.

The STAC API limits its results to the first 10 rows. You can expand
that limit with
[`dplyr::slice_head()`](https://dplyr.tidyverse.org/reference/slice.html).
For STAC the number of rows is capped at 10,000 records.

### Deviations

Due to limitations posed by the OData API, some tidyverse verbs deviate
from its tidy standards. Most notably:

- [`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html):
  Cannot change the order of columns. It will only affact which columns
  are selected. Also, tidy selection helpers like
  [`dplyr::any_of()`](https://dplyr.tidyverse.org/reference/reexports.html)
  and
  [`dplyr::all_of()`](https://dplyr.tidyverse.org/reference/reexports.html)
  are NOT supported

- [`dplyr::arrange()`](https://dplyr.tidyverse.org/reference/arrange.html):
  OData only allows to sort up to 32 columns. Adding more columns will
  produce a warning.

- Grouping is not supported

- Only tidy methods documented on this page are supported for
  `odata_request` and `stac_request` objects. If you want to apply the
  full spectrum of tidyverse methods, call
  [`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
  on the `stac_request`/`odata_request` object first. That will return a
  normal `data.frame`, which can be manipulated further.

## Examples

``` r
library(dplyr)
if (interactive()) {
  dse_odata_products_request() |>
    filter(contains(Name, "WRR")) |>
    select("Id", "Name") |>
    arrange(Id, desc(Name)) |>
    slice_head(n = 5) |>
    collect()

  #TODO stac example
}
```
