#' @include login.R

.download_s3 <- function(s3_path, destination, ps3) {
  prefix  <- gsub("^/eodata/", "", s3_path)
  objects <- ps3$list_objects("eodata", Prefix = prefix)
  keys    <- lapply(objects$Contents, `[[`, "Key") |> unlist()
  lapply(keys, \(k) {
    fn   <- gsub(paste0(dirname(prefix), "[/]"), "", k)
    dest <- file.path(destination, fn)
    if (!dir.exists(dirname(dest))) {
      dirresult <- dir.create(dirname(dest), recursive = TRUE)
      if (!dirresult) stop("Failed to create subdirectory for download file")
    }
    ps3$download_file("eodata", k, dest)
    return(fn)
  })
}

#' Download Asset Through Uniform Resource Identifier
#' 
#' When the Uniform Resource Identifier (URI, starting with "s3://") for
#' an asset is known, this function can be used to download it
#' @param uri A Uniform Resource Identifier (URI, starting with "s3://").
#' You can look for them in the STAC catalogue, either using a
#' [web browser](https://browser.stac.dataspace.copernicus.eu/) or
#' [dse_stac_search_request()] (see example).
#' @param destination Destination path to a directory where to store the downloaded file(s)
#' @param ... Ignored
#' @inheritParams dse_s3
#' @returns A vector of file names stored at `destination`
#' @examples
#' if (interactive() && dse_has_s3_secret()) {
#'   library(dplyr)
#'
#'   ## Retrieve a URI for a specific asset through the STAC
#'   ## catalogue:   
#'   my_uri <-
#'     dse_stac_search_request(
#'       ids = "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148") |>
#'         select("assets.B01.href") |>
#'         arrange("id") |>
#'         collect() |>
#'         pull("assets") |>
#'         unlist()
#'   
#'   dse_s3_download(my_uri, tempdir())
#'
#' }
#' @export
dse_s3_download <- function(
    uri, destination, ..., s3_key = dse_s3_key(), s3_secret = dse_s3_secret()) {
  if (!grepl("^[s|S]3://", uri, ignore.case = TRUE))
    rlang::abort(c(
      x = "Not a valid S3 URI",
      i = "Make sure the path starts with 's3://'"
    ))
  uri <- gsub("^[s|S]3\\:\\/", "", uri)
  ds3 <- dse_s3(s3_key = s3_key, s3_secret = s3_secret)
  .download_s3(uri, destination, ds3) |> unlist()
}