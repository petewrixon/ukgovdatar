call_ons_api_query <- R6Class("call_ons_api_query",
  public = list(
    parsed_url = NULL,
    response = NULL,
    response_df = NULL,
    initialize = function(url = NULL, query = NULL) {
      self$parsed_url <- parse_url(url)
      self$parsed_url[["query"]] <- query
      rest_url <- build_url(self$parsed_url)
      self$response <- httr::GET(rest_url)
      self$response_df <- self$response %>%
        content(type = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        as.data.frame()
    }
  )
)

