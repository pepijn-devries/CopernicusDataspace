#' @include geometry.R
NULL

#' Tidy Verbs for OData API and STAC Requests
#' 
#' Implementation of tidy generics for features supported by either OData or STAC
#' API requests.
#' They can be called on objects of either class: `odata_request` or `stac_request`.
#' The first is produced
#' by [dse_odata_products_request()] and [dse_odata_bursts_request()];
#' the latter by [dse_stac_search_request()].
#' 
#' The `odata_request` and `stac_request` class objects use lazy evaluation.
#' This means that functions are only evaluated after calling [dplyr::collect()]
#' on a request.
#' 
#' Note that you should not call the functions exported in this package directly.
#' Instead, call the generics as declared in the `dplyr` package. This is
#' illustrated by the examples.
#' 
#' ## Slice Head
#' In order to manage server traffic, the OData API never returns more than
#' 20 rows. If you want to obtain results beyond the first 20 rows, you need
#' to specify the `skip` argument.
#' 
#' The STAC API limits its results to the first 10 rows. You can expand that limit
#' with [dplyr::slice_head()]. For STAC the number of rows is capped at 10,000 records.
#' 
#' ## Deviations
#' Due to limitations posed by the OData API, some tidyverse verbs deviate
#' from its tidy standards. Most notably:
#' 
#'  * [dplyr::select()]: Cannot change the order of columns. It will only
#'    affact which columns are selected. Also, tidy selection helpers like
#'    [dplyr::any_of()] and [dplyr::all_of()] are NOT supported
#'  * [dplyr::arrange()]: OData only allows to sort up to 32 columns.
#'    Adding more columns will produce a warning.
#'  * Grouping is not supported
#'  * Only tidy methods documented on this page are supported for `odata_request`
#'    and `stac_request` objects. If you want to apply the full spectrum of
#'    tidyverse methods, call `dplyr::collect()` on the `stac_request`/`odata_request`
#'    object first. That will return a normal `data.frame`, which can be
#'    manipulated further.
#' @param .data,x An object of either class `odata_request` or `stac_request`.
#' These are produced by
#' [dse_odata_products_request()], [dse_odata_bursts_request()] and
#' [dse_stac_search_request()]
#' @param n Maximum number of rows to return.
#' @param skip Number of rows to skip when collecting results. The API
#' never returns more than 20 rows. Specify the number of rows to skip
#' in order to get results beyond the first 20 rows.
#' @param by,.by,.by_group,.preserve,prop Arguments inherited from generic
#' `dplyr` functions. Ignored in the current context as either grouping
#' is not allowed for an OData API request or is otherwise not supported.
#' @param ... Data masking expressions, or arguments passed to embedded functions
#' @returns All functions (except `collect()`) return a modified
#' `stac_request`/`odata_request`
#' object, containing the lazy tidy operations. `collect()` will return a
#' `data.frame()` yielding the result of the request.
#' @examples
#' library(dplyr)
#' if (interactive()) {
#'   dse_odata_products_request() |>
#'     filter(contains(Name, "WRR")) |>
#'     select("Id", "Name") |>
#'     arrange(Id, desc(Name)) |>
#'     slice_head(n = 5) |>
#'     collect()
#'
#'   dse_stac_search_request("sentinel-1-grd") |>
#'     filter(`sat:orbit_state` == "ascending") |>
#'     arrange("id") |>
#'     collect()
#' }
#' @name tidy_verbs
#' @rdname tidy_verbs
NULL

#' @rdname tidy_verbs
#' @name filter
#' @export
filter.odata_request <-
  function (.data, ..., .by = NULL, .preserve = FALSE) {
    new_filters <- rlang::enquos(..., .named = TRUE)
    .data$odata$filters <- c(.data$odata$filters, new_filters)
    .data
  }

#' @rdname tidy_verbs
#' @name filter
#' @export
filter.stac_request <-
  function (.data, ..., .by = NULL, .preserve = FALSE) {
    old_filter <- .data$body$data$filter
    if (length(old_filter) == 1 && is.na(old_filter)) old_filter <- NULL
    new_filter <-
      .translate_filters(rlang::enquos(..., .named = TRUE)[[1]], "stac")
    if (!is.null(old_filter)) {
      new_filter <- list(
        args = c(old_filter, new_filter),
        op = "and"
      )
    }
    .data |>
      httr2::req_body_json_modify(
        filter = new_filter
      )
  }

#' @rdname tidy_verbs
#' @name compute
#' @export
compute.odata_request <-
  function(x, skip = 0L, ...) {
    x |>
      .parse_filters() |>
      .parse_arrange() |>
      .parse_slice() |>
      .parse_select() |>
      httr2::req_url_query(`$skip` = skip)
  }

#' @rdname tidy_verbs
#' @name collect
#' @export
collect.odata_request <-
  function(x, skip = 0L, ...) {
    result <-
      x |>
      dplyr::compute(skip = skip) |>
      req_perform(...) |>
      httr2::resp_body_json()
    at <- result[setdiff(names(result), "value")]
    result <-
      result$value |>
      .simplify() |>
      dplyr::mutate(
        dplyr::across(dplyr::any_of("Assets"), ~ {
          lapply(., .simplify)
        }),
        dplyr::across(dplyr::any_of(c("Locations", "Attributes")), \(y) {
          .simplify(y) |>
            dplyr::rowwise() |>
            dplyr::group_split()
        })
      )
    attributes(result) <- c(attributes(result), at)
    at <- c(at, meta_columns = dplyr::select(result, dplyr::starts_with("@odata")))
    result <- dplyr::select(result, !dplyr::starts_with("@odata"))
    result
  }

#' @rdname tidy_verbs
#' @name collect
#' @export
collect.stac_request <-
  function(x, ...) {
    items <- 
      httr2::req_perform(x) |>
      httr2::resp_body_json()
    .stac_items(items)
  }

#' @rdname tidy_verbs
#' @name arrange
#' @export
arrange.odata_request <-
  function(.data, ..., .by_group = FALSE) {
    new_arrange <- rlang::enquos(..., .named = TRUE)
    .data$odata$arrange <- c(.data$odata$arrange, new_arrange)
    .data
  }

#' @rdname tidy_verbs
#' @name arrange
#' @export
arrange.stac_request <-
  function(.data, ..., .by_group = FALSE) {
    my_arrange <-
      rlang::enquos(..., .named = TRUE) |>
      .column_select(allow_desc = TRUE)
    dsc <- attr(my_arrange, "is_desc")
    my_arrange <- lapply(seq_len(length(my_arrange)), \(i){
      list(field = my_arrange[[i]], direction = ifelse(dsc[[i]], "desc", "asc"))
    })
    
    if (is.na(.data$body$data$sortby)) .data$body$data$sortby <- NULL
    httr2::req_body_json_modify(
      .data,
      sortby = c(.data$body$data$sortby, my_arrange)
    )
  }

#' @rdname tidy_verbs
#' @name slice_head
#' @export
slice_head.odata_request <-
  function(.data, ..., n, prop, by = NULL) {
    if (!is.null(.data$odata$slice_head))
      warning("Previously defined slice will be replaced with latest")
    if (!missing(prop))
      rlang::abort(c(
        x = "'prop' argument is not implemented for OData requests",
        i = "Use 'n' instead."))
    .data$odata$slice_head <- n
    .data
  }

#' @rdname tidy_verbs
#' @name slice_head
#' @export
slice_head.stac_request <-
  function(.data, ..., n, prop, by = NULL) {
    if (!missing(prop))
      rlang::abort(c(
        x = "'prop' argument is not implemented for STAC requests",
        i = "Use 'n' instead."))
    
    httr2::req_body_json_modify(.data, limit = n)
  }

#' @rdname tidy_verbs
#' @name select
#' @export
select.odata_request <-
  function(.data, ...) {
    new_select <- rlang::enquos(..., .named = TRUE)
    .data$odata$select <- c(.data$odata$select, new_select)
    .data
  }

#' @rdname tidy_verbs
#' @name select
#' @export
select.stac_request <-
  function(.data, ...) {
    new_select <-
      rlang::enquos(..., .named = TRUE) |>
      .column_select()
    if (is.na(.data$body$data$fields)) .data$body$data$fields <- NULL
    new_select <- c(.data$body$data$fields$include, new_select)
    .data |>
      httr2::req_body_json_modify(
        fields = list(
          include = as.list(new_select)
        )
      )
  }

.parse_filters <- function(.data) {
  filters <- .data$odata$filters
  geoms   <- .data$odata$geoms
  if (!is.null(filters)) {
    filters <-
      filters |>
      lapply(.translate_filters) |>
      unlist()
  }
  if (!is.null(geoms)) {
    geoms <-
      geoms |>
      lapply(.translate_geoms) |>
      unlist() |>
      sprintf(fmt = "OData.CSC.Intersects(area=geography'SRID=4326;%s')")
  }
  if (is.null(filters) && is.null(geoms)) return(.data)
  filters <- c(filters, geoms) |>
    paste(collapse = " and ")
  .data |>
    httr2::req_url_query(`$filter` = filters)
}

.parse_arrange <- function(.data) {
  my_arrange <- .data$odata$arrange
  if (is.null(my_arrange)) return(.data)
  my_arrange <-
    .column_select(my_arrange, allow_desc = TRUE)
  dsc <- attr(my_arrange, "is_desc")
  if (length(my_arrange) > 32L) {
    rlang::warn(c(
      "Cannot arrange OData by more than 32 columns",
      "Ignoring all but first 32 elements"),
      .frequency = "regularly",
      .frequency_id = "odata_arrange")
    my_arrange <- my_arrange[1:32]
  }
  my_arrange <-
    cbind(my_arrange, ifelse(dsc, " desc", "")) |>
    apply(1L, paste, collapse = "") |>
    paste(collapse = ",")
  .data |>
    httr2::req_url_query(`$orderby` = my_arrange)
}

.parse_slice <- function(.data) {
  my_slice <- .data$odata$slice_head
  if (is.null(my_slice)) return(.data)
  if (length(my_slice) != 1)
    rlang::abort(c(
      x = "Multiple values for 'n' specified",
      i = "Use only one value for 'n'"
    ))
  my_slice <- as.integer(my_slice)
  .data |>
    httr2::req_url_query(
      `$top` = my_slice
    )
}

.column_select <- function(q, allow_desc = FALSE) {
  result <-
    lapply(q, \(xpr) {
      result <- NULL
      is_desc <- FALSE
      if (allow_desc && rlang::is_call(xpr[[2]]) &&
          identical(rlang::eval_tidy(xpr[[2]][[1]]), dplyr::desc)) {
        is_desc <- TRUE
        xpr <- rlang::as_quosure(xpr[[2]][[2]], .GlobalEnv)
      }
      if (rlang::is_call(xpr[[2]])) {
        result <- if ((identical(rlang::eval_tidy(xpr[[2]][[1]]), `[[`)) ||
                      (identical(rlang::eval_tidy(xpr[[2]][[1]]), `$`)) &&
                      rlang::as_string(xpr[[2]][[2]]) == ".data")
          rlang::as_string(xpr[[2]][[3]]) else
            if (identical(c, rlang::eval_tidy(xpr[[2]][[1]])))
              rlang::eval_tidy(xpr[[2]])
        if (is.null(result))
          stop(sprintf("Sorry, '%s' is not implemented in this context",
                       rlang::as_string(xpr[[2]][[1]])))
        attr(result, "is_desc") <- is_desc
        result
      } else {
        result <-
          if (rlang::is_string(xpr[[2]]))
            rlang::eval_tidy(xpr) else
              rlang::as_string(xpr[[2]])
        attr(result, "is_desc") <- is_desc
        result
      }
    })
  attribs <- lapply(result, attr, "is_desc") |> unname() |> unlist()
  result <- unname(result) |> unlist()
  if (allow_desc) attr(result, "is_desc") <- attribs
  result
}

.parse_select <- function(.data) {
  my_select <- .data$odata$select
  if (is.null(my_select)) return(.data)
  sel <- .column_select(.data$odata$select)
  .data |>
    httr2::req_url_query(
      `$select` = paste(sel, collapse = ",")
    )
}

.odata_operators <- dplyr::tibble(
  r_code = list(`==`, `!=`, `>`, `>=`, `<`, `<=`, `&`, `|`, `!`, is.na, dplyr::contains),
  api_code = c("%s eq %s", "%s ne %s", "%s gt %s", "%s ge %s", "%s lt %s", "%s le %s",
               "%s and %s", "%s or %s", "not (%s)", "%s eq null", "contains(%s,%s)")
)

## STAC uses cq2-json schema.
.stac_operators <- dplyr::tibble(
  r_code = list(`==`, `!=`, `>`, `>=`, `<`, `<=`, `&`, `|`, `!`, is.na, `%in%`,
                dplyr::between),
  api_code = c("=", "<>", ">", ">=", "<", "<=", "and", "or", "not",
               "isNull", "in", "between")
)

.match_function <- function(expr, format = "odata") {
  base <- if (format == "odata") .odata_operators else
    if (format == "stac") .stac_operators
  result <- NA_integer_
  for (i in seq_len(nrow(base))) {
    if (identical(base$r_code[[i]], rlang::eval_tidy(expr))) {
      result <- i
      break
    }
  }
  return (result)
}

.translate_filters <- function(quo, format = "odata") {
  expr <- rlang::quo_get_expr(quo)
  if (is.call(expr)) {
    idx <- .match_function(expr[[1]], format)
    op <- ""
    if (!is.na(idx)) {
      op <- if (format == "odata") .odata_operators$api_code[idx] else
        if (format == "stac") .stac_operators$api_code[idx]
      if (rlang::is_call(expr[[2]])) {
        left <- .translate_filters(rlang::as_quosure(expr[[2]], environment()), format)
        if (format == "odata") left <- sprintf("(%s)", left)
      } else {
        left <- as.character(expr[[2]])
      }
    }
    if (is.na(idx)) {
      if (identical(c, eval(expr[[1]]))) {
        result <- rlang::eval_tidy(expr)
        if (format == "odata") {
          if (is.character(result)) result <- sprintf("'%s'", result)
          return (paste(result, collapse = ","))
        } else if (format == "stac") {
          return (result)
        }
      } else if (identical(`%in%`, eval(expr[[1]])) && format == "odata") {
        paste(
          sprintf("%s eq %s", as.character(expr[[2]]), rlang::eval_tidy(expr[[3]])),
          collapse = " or ") |>
          sprintf(fmt = "(%s)")
      } else if (identical(`$`, eval(expr[[1]])) || identical(`[[`, eval(expr[[1]]))) {
        if (rlang::as_string(expr[[2]]) == ".data") {
          return(rlang::as_string(expr[[3]]))
        } else if (rlang::as_string(expr[[2]]) == ".env") {
          expr <- rlang::as_quosure(expr[[3]], .GlobalEnv)
        }
        rlang::eval_tidy(expr)
      } else {
        rlang::eval_tidy(expr)
      }
    } else {
      if (length(expr) < 3) {
        return(
          list( args = left, op = op )
        )
        return(sprintf(op, left))
      } else {
        if (rlang::is_call(expr[[3]])) {
          right <- .translate_filters(rlang::as_quosure(expr[[3]], environment()), format)
        } else {
          right <- eval(expr[[3]])
        }
        left_check <- left
        if (is.list(left_check)) left_check <- left_check$args[[1]]$property
        if (is.null(left_check)) left_check <- ""
        if (grepl("date", left_check, ignore.case = TRUE)) {
          right <- lubridate::as_datetime(right, tz = "")
          right <- lubridate::format_ISO8601(right, usetz = TRUE)
        }
        if (is.character(right) && format == "odata")
          right <- sprintf("(%s)", right)
      }
      if (format == "odata") {
        return(sprintf(op, left, right))
      } else if (format == "stac") {
        if (is.character(left)) {
          left <- strsplit(left, "[.]")[[1]]
          domain <- "property"
          if (length(left) > 1) {
            if (left[[1]] != "properties") stop("Unknown domain")
            left <- left[[2]]
          }
          left <- structure(list(left), names = domain)
        }
        list(
          args = list(
            left,
            right
          ),
          op = op
        )
      }
    }
  }
}
