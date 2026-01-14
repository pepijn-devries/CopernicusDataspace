.simplify <- function(x, do_unnest = TRUE, what = "") {
  if (any(c("Product", "product") %in% names(x))) {
    nm <- names(x)
    nm[nm == "Product"] <- "product"
    names(x) <- nm
  }
  
  if (rlang::is_named(x)) {
    result <- tibble::enframe(x) |>
      tidyr::pivot_wider(names_from = "name", values_from = "value")
  } else {
    is_unnamed <- length(x) > 0 && all(!(lapply(x, rlang::is_named) |> unlist()))
    if (is_unnamed) {
      return(list(lapply(x, .simplify)))
    } else {
      result <-
        lapply(x, \(y) {
          tibble::enframe(y) |>
            tidyr::pivot_wider(names_from = "name", values_from = "value")
        }) |>
        dplyr::bind_rows()
    }
  }
  result <- result |>
    dplyr::mutate(
      dplyr::across(dplyr::everything(), ~ {
        if (lapply(.x, is.list) |> unlist() |> all()) {
          if (lapply(.x, rlang::is_named) |> unlist() |> all()) {
            lapply(.x, .simplify, what = dplyr::cur_column())
          } else {
            .x
          }
        } else {
          if (all(lengths(.x) == 1))
            unlist(.x) else
              .x
        }
      })
    )
  if (do_unnest) {
    tibble_columns <-
      lapply(result, \(y) lapply(y, tibble::is_tibble) |> unlist() |> all()) |> unlist()
    tibble_columns[names(tibble_columns) %in%
                     c("assets", "properties.cube:variables", "geometry")] <- FALSE
    if (any(tibble_columns)) {
      tidyr::unnest(result, names(tibble_columns)[tibble_columns], names_sep = ".")
    } else result
  } else result
}

.simplify2 <- function(x) {
  lapply(x, \(y) {
    if (length(y) != 1) list(y) else y
  }) |>
    tibble::as_tibble()
}

.add_token <- function(x, token) {
  x |>
    httr2::req_headers(
      authorization = paste("Bearer", token$access_token)
    )
}

.stac_items <- function(x) {
  attrib_names <- c("type", "links", "numberReturned")
  attribs <- x[attrib_names]
  x <- (x[setdiff(names(x), attrib_names)][[1]]) |>
    .simplify()
  .x <- NULL
  simplify_sub <- function(y, i) {
    if (i %in% names(y)) {
      dplyr::bind_cols(y |> dplyr::select(-.env$i),
                       y[[i]] |> .simplify() |>
                         dplyr::rename_with(~paste(i, .x, sep = ".")))
    } else y
  }

  x <-
    x |>
    simplify_sub("properties")
  
  attributes(x) <- c(attributes(x), x)
  x
  
}