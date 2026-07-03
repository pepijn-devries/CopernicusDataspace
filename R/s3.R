#' @include login.R

#' @rdname dse_s3
#' @export
dse_s3 <- function(region    = "us-east-1", ...,
                   s3_key    = dse_s3_get_key(),
                   s3_secret = dse_s3_get_secret()) {
  paws::s3(
    credentials = list(
      creds = list(
        access_key_id     = s3_key,
        secret_access_key = s3_secret
      )
    ),
    endpoint = .odata_s3_endpoint,
    region   = region
  )
}

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
#' @param s3_key,s3_secret The s3 key and secret registered under your Data Space
#' Ecosystem account
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
#' @family s3
#' @export
dse_s3_download <- function(
    uri, destination, ..., s3_key = dse_s3_get_key(), s3_secret = dse_s3_get_secret()) {
  if (!grepl("^[s|S]3://", uri, ignore.case = TRUE))
    rlang::abort(c(
      x = "Not a valid S3 URI",
      i = "Make sure the path starts with 's3://'"
    ))
  uri <- gsub("^[s|S]3\\:\\/", "", uri)
  .download_s3(uri, destination, dse_s3(s3_key, s3_secret))
}

#' Convert Uniform Resource Identifier to Virtual System Identifier
#' 
#' Convert Uniform Resource Identifier (URI) to Virtual System
#' Identifier (VSI). The Copernicus Data Space Ecosystem returns
#' URIs for accessing assets. Packages that use the GDAL library
#' (e.g., `stars`, `terra` and `gdalraster`)
#' can use VSI to access raster data directly. Use this function
#' to convert such an URI to a VIS.
#' @param uri A Uniform Resource Identifier, pointing to an
#' S3 storage file. You can retrieve one with [dse_stac_get_uri()].
#' @param streaming A `logical` value that allows to toggle between
#' `"\\vsis3\\"` and `"\\vsis3_streaming\\"` (default). The latter is
#' faster for reading files from its resource, but does not allow
#' random access. The first supports random access, but is not as fast
#' at reading.
#' @returns A `character` string representing the VSI
#' @examples
#' if (interactive()) {
#'   dse_stac_get_uri(
#'     "S1A_IW_GRDH_1SDV_20241125T055820_20241125T055845_056707_06F55C_12F9_COG",
#'     "vh", "sentinel-1-grd") |>
#'     dse_s3_uri_to_vsi()
#' }
#' @family s3
#' @export
dse_s3_uri_to_vsi <- function(uri, streaming = TRUE) {
  vsi <- sprintf(
    "/vsis3%s/",
    ifelse(streaming, "_streaming", ""))
  gsub("s3://", vsi, uri)
}

#' Set-up S3 Configuration for GDAL Library
#' 
#' This function sets system environment variables, such
#' that the GDAL library can access the Copernicus Data Space
#' Ecosystem S3 storage. Note that these settings can be used
#' by any package depending on the GDAL library. Most notably:
#' `stars`, `terra`, and `gdalraster`.
#' @param ... Ignored
#' @param region [AWS Region](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/)
#' used in instantiating the S3 client
#' @inheritParams dse_s3_download
#' @returns Returns a `logical` value. `TRUE` if all variables
#' were successfully set. `FALSE` otherwise.
#' @examples
#' if (interactive() && dse_has_s3_secret() &&
#'     requireNamespace("stars")) {
#'   library(dplyr)
#'
#'   ## Get a Virtual System Interface to a tiff file:
#'   vsi <-
#'     dse_stac_get_uri(
#'       "S1A_IW_GRDH_1SDV_20241125T055820_20241125T055845_056707_06F55C_12F9_COG",
#'       "vh", "sentinel-1-grd") |>
#'       dse_s3_uri_to_vsi()
#' 
#'   ## Make sure to set gdal options with required S3 settings
#'   dse_s3_set_gdal_options()
#'    
#'   ## You can now read the file directly from the online storage
#'   ## without having to download it completely:
#'   cog <- stars::read_stars(vsi)
#'    
#'   ## You can also easily plot a downsampled version
#'   plot(cog, downsample = 50)
#' }
#' @family s3
#' @export
dse_s3_set_gdal_options <- function(
    region = "us-east-1", ...,
    s3_key = dse_s3_get_key(), s3_secret = dse_s3_get_secret()) {
  Sys.setenv(AWS_REGION            = region) &&
    Sys.setenv(AWS_ACCESS_KEY_ID     = s3_key) &&
    Sys.setenv(AWS_SECRET_ACCESS_KEY = s3_secret) &&
    Sys.setenv(AWS_VIRTUAL_HOSTING   = "FALSE") &&
    Sys.setenv(AWS_S3_ENDPOINT       =
                 gsub("^https://", "", .odata_s3_endpoint))
}

#' @examples
#' if (interactive() && dse_has_s3_secret()) {
#'   my_s3 <- dse_s3()
#'   my_s3$get_object(Bucket = "", Key = "") |> summary()
#' }
#' @export
dse_s3 <- function(region = "us-east-1", ...,
                   s3_key = dse_s3_get_key(), s3_secret = dse_s3_get_secret()) {
  paws::s3(
    credentials = list(
      creds = list(
        access_key_id     = s3_key,
        secret_access_key = s3_secret
      )
    ),
    endpoint = .odata_s3_endpoint,
    region   = region
  )
}