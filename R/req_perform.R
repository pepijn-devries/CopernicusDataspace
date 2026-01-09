#' Perform a Request to Get a Response
#' 
#' A wrapper around [httr2::req_perform()], which can also handle
#' `odata_request` class objects. Check [httr2::req_perform()]
#' for details.
#' @param req Either a [httr2::request()] class object or an `odata_request`
#' class object. The latter can be created with [dse_odata_products_request()] and
#' [dse_odata_bursts_request()].
#' @inheritParams httr2::req_perform
#' @param mock A mocking function. If supplied, this function is called with the
#' request. It should return either NULL (if it doesn't want to handle the request)
#' or a response (if it does). See [httr2::with_mock()]/ local_mock() for more details.
#' @returns Returns a `httr2::response` class object
#' @export
req_perform <- function(
    req,
    path = NULL,
    verbosity = NULL,
    mock = getOption("httr2_mock", NULL),
    error_call = rlang::current_env()) {
  
  if (inherits(req, "odata_request")) {
    
    req |>
      httr2::req_error(body = .odata_error) |>
      httr2::req_perform(path = path, verbosity = verbosity,
                         mock = mock, error_call = error_call)
    
  } else {
    
    httr2::req_perform(req = req, path = path, verbosity = verbosity,
                       mock = mock, error_call = error_call)
    
  }
}

