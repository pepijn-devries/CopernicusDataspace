.simplify <- function(x) {
  x <- lapply(x, tibble::enframe) |>
    lapply(tidyr::pivot_wider, names_from = "name", values_from = "value") |>
    dplyr:: bind_rows()
  unnest_col <-
    lapply(x, \(x) lengths(x) == 1) |>
    lapply(all) |>
    unlist()
  tidyr::unnest(x, names(unnest_col)[unnest_col])
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
  attributes(x) <- c(attributes(x), x)
  x
  
}