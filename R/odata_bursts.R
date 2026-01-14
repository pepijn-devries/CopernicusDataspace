#' @include tidyverse.R
#' @include login.R
#' @include odata_products.R
NULL

#' @rdname dse_odata_bursts
#' @export
dse_odata_bursts_request <- function(...) {
  result <-
    .odata_url |>
    paste("Bursts", sep = "/") |>
    httr2::request()
  class(result) <- union(c("odata_request", "odata_bursts_request"), class(result))
  result
}

#' Create a OData Request for a Data Space Ecosystem Bursts Data
#' 
#' Obtain metadata for burst data associated with specific products.
#' 
#' For more details about bursts check the
#' [burst API documentation](https://documentation.dataspace.copernicus.eu/APIs/Sentinel-1%20SLC%20Burst.html).
#' 
#' You can apply some tidyverse functions (see [tidy_verbs]) to `odata_request`
#' object returned by [dse_odata_bursts_request()]. These apply lazy evaluation.
#' Meaning that they are just added to the object and are only evaluated after
#' calling either [dplyr::compute()] or [dplyr::collect()] (see examples).
#' @param ... Ignored
#' @returns Returns a `data.frame` with burst information.
#' @examples
#' if (interactive()) {
#'   dse_odata_bursts(ParentProductId == "879d445c-2c67-5b30-8589-b1f478904269")
#'   
#'   burst_req <-
#'     dse_odata_bursts_request(ParentProductId == "879d445c-2c67-5b30-8589-b1f478904269")
#'   
#'   ## Note that these are large files and may take a while to download:
#'   dse_odata_download(
#'     burst_req,
#'     tempdir()
#'   )
#' }
#' @export
dse_odata_bursts <- function(...) {
  dse_odata_bursts_request() |>
    dplyr::filter(...) |>
    dplyr::collect()
}
