#' @include tidyverse.R
#' @include login.R
#' @include account.R
#' @include req_perform.R
NULL

.odata_error <- function(resp) {
  body <- resp |> httr2::resp_body_json()
  result <- body$detail
  if (is.null(result)) {
    if (resp$status_code == 401) {
      c("Ensure that you have specified a token",
        "Ensure your token hasn't expired (call `memoise::forget(dse_access_token)`)")
    } else {
      "Details not returned"
    }
  } else {
    if (rlang::is_named(result)) result$message else as.character(result)
  }
}

#' Create a OData Request for a Data Space Ecosystem Product
#' 
#' OData is an application programming interface (API) used to disseminate Copernicus
#' Data Space Ecosystem products. This function creates a request for this service,
#' which can be used to obtain a `data.frame` with product information. This request
#' supports several tidyverse methods for filtering and arranging the data.
#' 
#' You can apply some tidyverse functions (see [tidy_verbs]) to `odata_request`
#' object returned by [dse_odata_products_request()]. These apply lazy evaluation.
#' Meaning that they are just added to the object and are only evaluated after
#' calling either [dplyr::compute()] or [dplyr::collect()] (see examples).
#' @param ... Ignored in case of `dse_odata_products_request()`. Dots are passed
#' to embedded [dplyr::filter()] in case of `dse_odata_products()`
#' @param expand Additional information to be appended to the result.
#' Should be any of `"Attributes"`, `"Assets"`, or `"Locations"`. Note that,
#' these columns are not affected by [dplyr::select()] calls (before calling
#' [dplyr::collect()]).
#' @returns Returns an `odata_request` class object in case of
#' `dse_odata_products_request()`, which is an extension of [httr2::request()].
#' In case of `dse_odata_products()` a `data.frame` listing requested products is
#' returned.
#' @references <https://documentation.dataspace.copernicus.eu/APIs/OData.html>
#' @examples
#' if (interactive()) {
#'   bbox <-
#'     sf::st_bbox(
#'       c(xmin = 5.261, ymin = 52.680, xmax = 5.319, ymax = 52.715),
#'       crs = 4326) |>
#'       sf::st_as_sfc()
#' 
#'   dse_odata_products_request() |>
#'     dplyr::filter(
#'       `ContentDate/Start` > "2025-01-01") |>
#'     sf::st_intersects(bbox) |>
#'     dplyr::arrange(dplyr::desc(Id)) |>
#'     dplyr::slice_head(n = 100) |>
#'     dplyr::collect()
#' }
#' @export
dse_odata_products_request <- function(..., expand) {
  exp_f <- if (missing(expand)) {
    I
  } else {
    match.arg(expand, c("Attributes", "Assets", "Locations"), TRUE)
    \(x) {
      httr2::req_url_query(x, `$expand` = expand, .multi = "explode")
    }
  }
  result <-
    .odata_url |>
    paste("Products", sep = "/") |>
    httr2::request() |>
    exp_f()
  class(result) <- union(c("odata_request", "odata_products_request"), class(result))
  result
}

#' @rdname dse_odata_products_request
#' @export
dse_odata_products <- function(..., expand = NULL) {
  dse_odata_products_request(expand = expand) |>
    dplyr::filter(...) |>
    dplyr::collect()
}

#' List OData Product Nodes (i.e. Files and Directories)
#' 
#' If you know the product `Id`, you can use this function to retrieve
#' information about nodes (i.e. files and directories) within the product.
#' @param product A product identifier (`Id`)
#' @param node_path Path of nodes separated by forward slashes (`"/"`).
#' Path for which to list nodes. Default is `""`, which is the root of
#' the product
#' @param recursive A `logical` value. If set to `TRUE`, it will recursively
#' list all nested nodes. Default is `FALSE`.
#' @param ... Ignored
#' @returns A `data.frame` with information on the requested node(s)
#' @examples
#' if (interactive()) {
#'   nodes <- dse_odata_product_nodes("c8ed8edb-9bef-4717-abfd-1400a57171a4")
#'   nodes <- dse_odata_product_nodes("c8ed8edb-9bef-4717-abfd-1400a57171a4",
#'                                    recursive = TRUE)
#' }
#' @export
dse_odata_product_nodes <- function(product, node_path = "", recursive = FALSE, ...) {
  if (length(node_path) != 1) stop("Argument `node_path` should only have one element")
  
  print(node_path) #TODO
  
  .path_to_url(product, node_path) |>
    paste("Nodes", sep = "/") |>
    httr2::request() |>
    httr2::req_error(body = .odata_error) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  if (length(result$result) == 0) return(dplyr::tibble())
  result <- .simplify(result$result)
  if (recursive) {
    result <-
      dplyr::bind_rows(
        result,
        result |>
          dplyr::filter(ChildrenNumber > 0) |>
          dplyr::pull("Nodes.uri") |>
          stringr::str_extract_all("(?<=/Nodes\\()(.*?)(?=\\))") |>
          lapply(paste, collapse = "/") |>
          unlist() |>
          lapply(\(x) dse_odata_product_nodes(product, x, recursive = TRUE, token = token))
      )
  }
  return (result)
}

.dse_odata_attributes <- function(...) {
  result <-
    .odata_url |>
    paste("Attributes", sep = "/") |>
    httr2::request() |>
    httr2::req_error(body = .odata_error) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  nm <- names(result)
  result |>
    .simplify2() |>
    tidyr::pivot_longer(
      dplyr::everything(),
      names_to = "Collection",
      values_to = "Attributes") |>
    dplyr::mutate(
      Attributes =
        lapply(.data$Attributes, \(x) dplyr::bind_rows(lapply(x, as.data.frame)))
    ) |>
    tidyr::unnest("Attributes") |>
    dplyr::rename(AttributeName = "Name", AttributeValueType = "ValueType")
}

#' List OData Attributes
#' 
#' Collect a list of OData attributes that can be used for
#' filtering products with [dse_odata_products_request()].
#' @param ... Ignored
#' @returns A `data.frame` listing all attributes for each collection.
#' @examples
#' if (interactive()) {
#'   dse_odata_attributes()
#' }
#' @export
dse_odata_attributes <- memoise::memoise(.dse_odata_attributes)

#' Download Data Space Ecosystem Products Through OData API
#' 
#' Use [dse_odata_products()] or [dse_odata_products_request()],
#' [dse_odata_bursts()] or [dse_odata_bursts_request()] to find
#' a product or burst information. Use this function to download the product(s)
#' or burst information.
#' 
#' @param request A request containing products or burst data that you wish to download.
#' Use [dse_odata_products_request()] or [dse_odata_bursts_request()] to formulate
#' product or burst specifications.
#' @param destination A `character` string specifying the directory path,
#' where to store downloaded products
#' @param ... Arguments passed to [dse_s3()].
#' @inheritParams dse_s3
#' @returns Returns `NULL` invisibly.
#' @examples
#' if (interactive() && dse_has_s3_secret()) {
#'   dse_odata_download(
#'     dse_odata_products(Name == "S1C_AUX_PP2_V20241204T000000_G20251024T110034.SAFE"),
#'     destination = tempdir())
#'   dse_odata_download(
#'     dse_odata_products(
#'       Name ==
#'         "S1A_IW_OCN__2SDH_20250707T210608_20250707T210625_059983_07739B_893E.SAFE"),
#'     destination = tempdir())
#'   dse_odata_download(
#'     dse_odata_products(
#'       Id %in% c("c8ed8edb-9bef-4717-abfd-1400a57171a4",
#'                 "86288a07-560c-364f-b8ce-669d95f06fa0")),
#'     destination = tempdir())
#' }
#' @export
dse_odata_download <- function(request, destination, ...,
                              s3_key = dse_s3_key(), s3_secret = dse_s3_secret()) {
  product_details <- request |> dplyr::collect()
  ps3 <- dse_s3(..., s3_key = s3_key, s3_secret = s3_secret)
  .download_s3 <- function(s3_path) {
    prefix  <- gsub("^/eodata/", "", s3_path)
    objects <- ps3$list_objects("eodata", Prefix = prefix)
    keys    <- lapply(objects$Contents, `[[`, "Key") |> unlist()
    lapply(keys, \(k) {
      dest <- file.path(destination, gsub(paste0(dirname(prefix), "[/]"), "", k))
      if (!dir.exists(dirname(dest))) {
        dirresult <- dir.create(dirname(dest), recursive = TRUE)
        if (!dirresult) stop("Failed to create subdirectory for download file")
      }
      ps3$download_file("eodata", k, dest)
    })
  }

  lapply(product_details$S3Path, .download_s3)
  return (invisible())
}

.path_to_url <- function(product, node_path) {
  node_path <-
    strsplit(node_path, "/") |>
    unlist() |>
    sprintf(fmt = "Nodes(%s)") |>
    paste(collapse = "/")
  
  result <-
    .odata_url |>
    paste(sprintf("Products(%s)", product), node_path, sep = "/")
}

#' Alternative Route to Download OData Products
#' 
#' TODO
#' @param product TODO
#' @param node_path TODO
#' @param destination TODO
#' @param compressed A `logical` value (default is `FALSE`). If set to`TRUE`,
#' the product will be downloaded as a zipped archive file. Note that
#' compression is not supported by all products. In those cases you will
#' get a 404 error.
#' @param ... Ignored
#' @inheritParams dse_usage
#' @returns Returns a `httr2_response` class object
#' @examples
#' if (interactive() && dse_has_client_info()) {
#'   dse_odata_download_path(
#'     "617cc4fb-bb72-4589-9ac7-c19a0d89ef2d",
#'     tempfile(fileext = ".zip"))
#'   dse_odata_download_path(
#'     "2f497806-0101-5eea-83fa-c8f68bc56b0c",
#'     paste("DEM1_SAR_DTE_90_20101213T034716_20130408T035028_ADS_000000_5033.DEM",
#'           "Copernicus_DSM_30_S09_00_E026_00", "DEM",
#'           "Copernicus_DSM_30_S09_00_E026_00_DEM.dt1", sep = "/"),
#'     tempfile(fileext = ".dt1")
#'   )
#'   dse_odata_download_path(
#'     "7724d5b9-7c74-426c-b2f2-d30c7bcfc868",
#'     tempfile(fileext = ".zip"), compressed = TRUE)
#' }
#' @export
dse_odata_download_path <- function(
    product, node_path, destination, compressed = FALSE, ...,
    token = dse_access_token()) {

  .path_to_url(product, node_path) |>
    paste(ifelse(compressed, "$zip", "$value"), sep = "/") |>
    httr2::request() |>
    httr2::req_progress() |>
    .add_token(token) |>
    ## Make sure that authentication is passed on to any redirect:
    httr2::req_options(unrestricted_auth = 1) |>
    httr2::req_error(body = .odata_error) |>
    httr2::req_perform(path = destination)
}

#' Download a Quicklook for a Product
#' 
#' Downloads a 'quicklook' for a product. If the `rstudioapi` package is installed,
#' it will attempt to open the image in the Viewer panel.
#' @param product Identifier (Id) for the product for which to obtain a quicklook.
#' @param destination A destination path where to store the image.
#' @param ... Ignored
#' @returns Returns `NULL` invisibly
#' @examples
#' if (interactive()) {
#'   dse_odata_quicklook(
#'     "91822f33-b15c-5b60-aa39-6d9f6f5c773b",
#'     tempfile(fileext = ".jpg"))
#' }
#' @export
dse_odata_quicklook <- function(product, destination, ...) {
  assets <-
    dse_odata_products(.data$Id == .env$product, expand = "Assets") |>
    dplyr::pull("Assets") |>
    dplyr::bind_rows() |>
    dplyr::filter(dplyr::if_any("Type", \(x) x == "QUICKLOOK"))
  if (nrow(assets) == 0)
    rlang::abort(c(
      x = "This product does not have a 'quicklook'",
      i = "Try again with a different product"
    ))
  assets$DownloadLink |>
    httr2::request() |>
    httr2::req_perform(path = destination)
  if (requireNamespace("rstudioapi") && rstudioapi::isAvailable()) {
    rstudioapi::viewer(destination)
  } else {
    file.show(destination)
  }
  return(invisible())
}