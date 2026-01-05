# Perform a Request to Get a Response

A wrapper around
[`httr2::req_perform()`](https://httr2.r-lib.org/reference/req_perform.html),
which can also handle `odata_request` class objects. Check
[`httr2::req_perform()`](https://httr2.r-lib.org/reference/req_perform.html)
for details.

## Usage

``` r
req_perform(
  req,
  path = NULL,
  verbosity = NULL,
  mock = getOption("httr2_mock", NULL),
  error_call = rlang::current_env()
)
```

## Arguments

- req:

  Either a
  [`httr2::request()`](https://httr2.r-lib.org/reference/request.html)
  class object or an `odata_request` class object. The latter can be
  created with
  [`dse_odata_products_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_products_request.md)
  and
  [`dse_odata_bursts_request()`](https://pepijn-devries.github.io/CopernicusDataspace/reference/dse_odata_bursts.md).

- path:

  Optionally, path to save body of the response. This is useful for
  large responses since it avoids storing the response in memory.

- verbosity:

  How much information to print? This is a wrapper around
  [`req_verbose()`](https://httr2.r-lib.org/reference/req_verbose.html)
  that uses an integer to control verbosity:

  - `0`: no output

  - `1`: show headers

  - `2`: show headers and bodies

  - `3`: show headers, bodies, and curl status messages.

  Use
  [`with_verbosity()`](https://httr2.r-lib.org/reference/with_verbosity.html)
  to control the verbosity of requests that you can't affect directly.

- mock:

  A mocking function. If supplied, this function is called with the
  request. It should return either NULL (if it doesn't want to handle
  the request) or a response (if it does). See
  [`httr2::with_mock()`](https://httr2.r-lib.org/reference/with_mocked_responses.html)/
  local_mock() for more details.

- error_call:

  The execution environment of a currently running function, e.g.
  `caller_env()`. The function will be mentioned in error messages as
  the source of the error. See the `call` argument of
  [`abort()`](https://rlang.r-lib.org/reference/abort.html) for more
  information.

## Value

Returns a
[`httr2::response`](https://httr2.r-lib.org/reference/response.html)
class object
