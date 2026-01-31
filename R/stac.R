## https://stac.dataspace.copernicus.eu/v1/api.html

#' @include tidyverse.R
#' @include helpers.R
#' @include account.R
#' @include req_perform.R
#' @include s3.R
NULL

.stac_base_url <- "https://stac.dataspace.copernicus.eu/v1"

.stac_get <- function(endpoint = "") {
  .stac_base_url |>
    paste(endpoint, sep = "/") |>
    httr2::request() |>
    httr2::req_error(body = .stac_error) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

.dse_stac_client <- function(...) {
  .stac_get("") |>
    .simplify2()
}

.stac_error <- function(resp) {
  if (httr2::resp_content_type(resp) == "application/json") {
    details <-
      resp |>
      httr2::resp_body_json()
    if ("code" %in% names(details))
      return (sprintf("%s: %s", details$code, details$description))
    loc <- lapply(details$detail, \(x) do.call(paste, c(x$loc, sep = "/"))) |> unlist()
    msg <- lapply(details$detail,`[[`, "msg") |> unlist()
    cbind(loc, msg) |> apply(1, paste, collapse = ": ", simplify = FALSE) |> unlist()
  } else {
    return("No error details returned by server")
  }
}

#' Obtain Information About the STAC Client
#' 
#' Returns information about the STAC client used in the Data Space Ecosystem
#' @param ... Ignored
#' @returns Returns a `data.frame` with the requested information
#' @examples
#' if (interactive()) {
#'   dse_stac_client()
#' }
#' @export
dse_stac_client <- memoise::memoise(.dse_stac_client)

.dse_stac_collections <- function(collection, ...) {
  arg <- "collections"
  if (!missing(collection)) arg <- paste(arg, collection, sep = "/")
  result  <- .stac_get(arg)
  if (any(names(result) == "collections")) {
    attribs <- result[names(result) != "collections"]
    result  <- result$collections |> .simplify(do_unnest = FALSE)
    attr(result, "request") <- attribs
  } else {
    result <- .simplify(result, do_unnest = FALSE)
  }
  result
}

#' Get a Summary of all Data Space Ecosystem Collections
#' 
#' Use the STAC API to get a summary of all collections available
#' from the interface.
#' @param collection A specific collection for which to obtain summary information.
#' If missing (default), all collections are returned.
#' @param ... Ignored
#' @returns Returns a `data.frame` with the requested information
#' @examples
#' if (interactive()) {
#'   dse_stac_collections()
#'   dse_stac_collections("sentinel-2-l2a")
#' }
#' @export
dse_stac_collections <- memoise::memoise(.dse_stac_collections)

.dse_stac_api_specs <- function(...) .stac_get("api")

.get_schema <- function(ref, api) {
  ref <- gsub("#", "api", ref)
  ref <- gsub("/", "$", ref)
  rlang::parse_expr(ref) |> rlang::eval_tidy()
}

.dse_fix_list <- function(target, source, api) {
  lapply(names(target), \(nm) {
    types <- target[[nm]]$anyOf |> .simplify()
    if ((is.null(source[[nm]]) || all(is.na(source[[nm]]))) && "null" %in% types$type) {
      if ("array" %in% types$type) {
        itms_nm  <- c("prefixItems", "items")
        itms_nm  <- itms_nm[itms_nm %in% names(types)]
        itms_idx <- which(types$type == "array")
        itms <- do.call(c, types[[itms_nm]])
        if (!any(c("$ref", "type") %in% names(itms))) {
          return(rep(NA, length(types)))
        } else {
          if ("string" %in% itms)
            return(NA) else {
              return(NA)
            }
        }
      } else {
        ## object e.g. intersects
        return(NA)
      }
    } else {
      target[[nm]] <- source[[nm]]
      if (grepl("date", nm)) {
        target[[nm]] <- lubridate::as_datetime(target[[nm]], tz = "")
        target[[nm]] <- lubridate::format_ISO8601(target[[nm]], usetz = TRUE)
      }
      if ("integer" %in% types$type) target[[nm]] <-   as.integer(target[[nm]])
      if ("number"  %in% types$type) target[[nm]] <-   as.numeric(target[[nm]])
      if ("string"  %in% types$type) target[[nm]] <- as.character(target[[nm]])
      if ("object"  %in% types$type) {
        schema <-
          .get_schema(types$additionalProperties[[1]]$propertyNames[["$ref"]], api)
        target[[nm]] <- .dse_fix_list(schema, target[[nm]], api)
      }
      if ("array" %in% types$type) target[[nm]] <- as.list(target[[nm]]) else {
        if (length(target[[nm]]) > 1)
          rlang::abort(c(x = sprintf("'%s' should have a length of 1 not %i",
                                     nm, length(target[[nm]]))))
      }
      return(target[[nm]])
    }
  })
}

.dse_stac_search_filter <- function(...) {
  api_props <- .dse_stac_api_specs()
  filt <- api_props$components$schemas$SearchPostRequest$properties
  args <- list(...)
  if (any(!names(args) %in% names(filt)))
    rlang::warn(sprintf("Ignoring unknown filter arguments: %s",
                        sprintf("'%s'", names(args)[!names(args) %in% names(filt)]) |>
                          paste(collapse = ", ")))
  result <- .dse_fix_list(filt, args, api_props)
  names(result) <- names(filt)
  result[["filter-lang"]] <- "cql2-json"
  result[["filter-crs"]] <- "http://www.opengis.net/def/crs/OGC/1.3/CRS84"
  class(result) <- union("stac_search", class(result))
  result
}

#' Create a Request for a STAC Search in the Data Space Ecosystem
#' 
#' In order to perform a search using the STAC API, you first need to
#' create a request using [dse_stac_search_request()]. This creates
#' a [httr2::request()] to which tidy verbs `?tidy_verbs` can be applied
#' (e.g., [dplyr::select()], [dplyr::filter()] and [dplyr::arrange()].
#' Results are retrieved by calling [dplyr::collect()] on the request.
#' 
#' If you prefer a graphical user interface, you can alternatively use
#' the [STAC web browser](https://browser.stac.dataspace.copernicus.eu/).
#' @param collections Restrict the search to the collections listed here.
#' @param ids Restrict the search to ids listed here.
#' @param ... Arguments appended to search filter request body.
#' @returns Returns a `data.frame` with search results.
#' @examples
#' if (interactive()) {
#'   library(dplyr)
#'   library(sf)
#'   
#'   bbox <-
#'     sf::st_bbox(
#'       c(xmin = 5.261, ymin = 52.680, xmax = 5.319, ymax = 52.715),
#'       crs = 4326)
#'
#'   dse_stac_search_request("sentinel-2-l1c") |>
#'     filter(`eo:cloud_cover` < 10) |>
#'     collect()
#'
#'   dse_stac_search_request("sentinel-1-grd") |>
#'     filter(`sat:orbit_state` == "ascending") |>
#'     arrange("id") |>
#'     st_intersects(bbox) |>
#'     collect()
#' }
#' @export
dse_stac_search_request <- function(collections, ids, ...) {
  if (missing(collections)) collections <- NA
  if (missing(ids)) ids <- NA
  filt <- .dse_stac_search_filter(collections = collections, ids = ids, ...)
  filt$intersects <- NULL # Mutually exclusive. Added by st_intersects()
  filt$bbox       <- NULL # Mutually exclusive. Added by st_intersects()
  result <-
    .stac_base_url |>
    paste("search", sep = "/") |>
    httr2::request() |>
    httr2::req_method("POST") |>
    httr2::req_body_json(filt) |>
    httr2::req_error(body = .stac_error)
  class(result) <- union("stac_request", class(result))
  result
}

#' Download Asset From STAC Catalogue
#' 
#' Use [dse_stac_search_request()] to identify assets that can be downloaded.
#' Use [dse_stac_download()] to download an asset by its STAC id and asset name.
#' @param asset_id STAC id, used for locating the asset download details.
#' @param asset Name of the asset to download
#' @param collection The identifier for a collection. The default argument
#' is the [dse_stac_guess_collection()] function which tries to guess the
#' collection id from the `asset_id`. A more rigid approach is to provide
#' the collection id as a `character` string.
#' @param destination Directory path where to store the downloaded file.
#' @param ... Ignored
#' @inheritParams dse_usage
#' @inheritParams dse_s3
#' @returns Returns the path to the downloaded file.
#' @examples
#' if (interactive() && (dse_has_s3_secret() || dse_has_client_info())) {
#'   dse_stac_download(
#'     asset_id = "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148",
#'     asset = "B01",
#'     destination = tempdir()
#'   )
#' }
#' @export
dse_stac_download <- function(
    asset_id, asset, collection = dse_stac_guess_collection, destination, ...,
    s3_key    = dse_s3_key(),
    s3_secret = dse_s3_secret(),
    token     = dse_access_token()) {

  type <- if (s3_key != "" && s3_secret != "") "s3" else
    if (!is.null(token)) "odata" else
      rlang::abort(c(
        x = "Need authentication details in order to download asset",
        i = ("Pass either S3 key and secret or OData access token")
      ))
  uri <- dse_stac_get_uri(asset_id, asset, collection, type)
  local_path <- attr(uri, "local_path")
  
  if (is.null(local_path)) fn <- NULL else
    fn <- file.path(destination, basename(local_path))
  
  if (s3_key != "" && s3_secret != "") {
    if (is.null(fn))
      fn <- file.path(destination, basename(uri))
    dse_s3_download(uri, destination,
                    s3_key = s3_key, s3_secret = s3_secret)
    return(fn)
  } else if (!is.null(token)) {
    if (is.null(fn))
      fn <- file.path(destination, basename(uri))
    uri |>
      httr2::request() |>
      .add_token(token) |>
      httr2::req_perform(path = fn)
    return(fn)
  }
}

#' Get a Uniform Resource Identifier (URI) for an Asset in a Product
#' 
#' Get a Uniform Resource Identifier (URI) for an asset in a product.
#' This can be used to download a file manually or connect to the
#' asset directly straight from the source.
#' @inheritParams dse_stac_download
#' @param type Which type of URI should be returned? Defaults
#' to `"s3"`. Use `"odata"` to get the alternative https URI.
#' @returns Returns the URI as a `character` string.
#' If available, the local path for an asset is returned as attribute.
#' @examples
#' if (interactive()) {
#'   dse_stac_get_uri(
#'     asset_id = "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148",
#'     asset = "B01"
#'   )
#' }
#' @export
dse_stac_get_uri <- function(
    asset_id, asset, collection = dse_stac_guess_collection,
    type = "s3", ...) {
  if (is.function(collection)) collection <- collection(asset_id)
  
  asset_info <-
    dse_stac_search_request(ids = asset_id, collections = collection) |>
    dplyr::select(!!paste0("assets.", asset)) |>
    dplyr::arrange("id") |>
    dplyr::collect()
  
  if (nrow(asset_info) == 0)
    rlang::abort(
      c(x = "Asset not found",
        i = "Ensure that you have specified the correct asset id and collection")
    )
  asset_info <- asset_info |>
    dplyr::pull("assets") |>
    dplyr::bind_rows()
  
  local_path <- asset_info[[paste0(asset, ".file:local_path")]]
  el <- ifelse(type == "s3", ".href", ".alternate.https.href")
  result <- asset_info[[paste0(asset, el)]]
  attr(result, "local_path") <- local_path
  result
}

.dse_stac_queryables <- function(collection, ...) {
  result <-
    .stac_base_url |>
    paste("collections", collection, "queryables", sep = "/") |>
    httr2::request() |>
    httr2::req_error(body = .stac_error) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}

#' Get Queryables for a STAC Collection
#' 
#' When searching through a collection with [dse_stac_search_request()], it
#' can be helpful to know which elements can be used to filter the search
#' results (using [dplyr::filter()]). Calling [dse_stac_queryables()] tells
#' you which aspects are available for querying and expected formats.
#' @param collection Name of the collection for which to get the queryables.
#' @param ... Ignored
#' @returns Returns a named list with information about elements that can be used
#' to query the `collection`
#' @examples
#' if (interactive()) {
#'   dse_stac_queryables("sentinel-1-grd")
#' }
#' @export
dse_stac_queryables <- memoise::memoise(.dse_stac_queryables)

.collection_codes <-
  data.frame(
    code = c(
      "^S1.\\_.._SLC\\_\\_",
      "^S1.\\_.._GRHD\\_",
      "^S1.\\_RTC\\_",
      "^S2.\\_MSIL1C\\_",
      "^S2.\\_MSIL2A\\_",
      "^S2.\\_GRI_L1C_",
      "^S3.\\_OL\\_1\\_EFR\\_",
      "^S3.\\_OL\\_2\\_LFR\\_",
      "^S3.\\_SL\\_1\\_RBT\\_",
      "^S3.\\_SR\\_2\\_LAN\\_",
      "^COP-DEM\\_",
      "^Copernicus\\_DSM\\_...\\_30",
      "^SRTM\\_"
    ),
    collection_id = c(
      "sentinel-1-slc",
      "sentinel-1-grd",
      "sentinel-1-rtc",
      "sentinel-2-l1c",
      "sentinel-2-l2a",
      "sentinel-2-gri-l1c",
      "sentinel-3-olci-l1-efr",
      "sentinel-3-olci-l2-lfr-ntc",
      "sentinel-3-slstr-l1-rbt",
      "sentinel-3-sral-l2-lan",
      "cop-dem",
      "cop-dem-glo-30-dged-cog",
      "srtm-dem"
    )
  )

#' Guess the Collection id from an Asset id
#' 
#' As the STAC catalogue contains a large number of records, your request
#' may receive a timeout error. To prevent this it is best to narrow down
#' your requests to specific collections. This function is a helper function
#' that tries to guess the collection id from an asset id. Note that this
#' method is not highly reliable, and it is always best to manually provide
#' a collection id to a request.
#' 
#' @param asset_id An asset identifier name, used to guess its parent
#' collection id.
#' @returns A `character` string with a guessed collection id. Or `NA` in
#' case it cannot make a guess.
#' @examples
#' dse_stac_guess_collection(
#'   "S2A_MSIL1C_20260109T132741_N0511_R024_T39XVL_20260109T142148")
#' @export
dse_stac_guess_collection <- function(asset_id) {
  idx <- lapply(asset_id, stringr::str_detect, pattern = .collection_codes$code) |>
    lapply(which)
  if (any(lengths(idx) == 0)) {
    rlang::warn(c(
      "Couldn't guess the collection id",
      i = "Please provide the collection id manually"
    ))
  }
  lapply(idx, \(i) {
    if (length(i) == 0) return(NA)
    .collection_codes$collection_id[[i]]
  }) |> unlist()
}