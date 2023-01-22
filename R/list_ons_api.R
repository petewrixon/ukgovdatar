#' Title
#'
#' @param variables
#'
#' @return
#' @export
#'
#' @examples
list_ons_timeseries <- function() {

  url = "https://api.ons.gov.uk/timeseries"

  api_call <- httr::GET(url)

  if(api_call$status_code == 429){
    api_wait(api_call)
    api_call <- httr::GET(url)
  }

  item_count <- api_call %>%
    httr::content() %>%
    .$totalItems

  item_per_page <- 100

  no_iterations <- ceiling(item_count / item_per_page)

  pb = txtProgressBar(min = 0, max = no_iterations, initial = 1)

  for (i in c(1:no_iterations)) {

    query <- list(limit = item_per_page, start_id = i*item_per_page+1)

    ons_api_response <- call_ons_api_query$new(url = url, query = query)

    if ("errors.code" %in% colnames(ons_api_response$response_df)){
      while(ons_api_response$response_df$errors.code == 429){
      api_wait(ons_api_response$response)
      ons_api_response <- call_ons_api_query$new(url = url, query = query)

      }

    }


    if (i > 1) {
      df <- rbind(df, ons_api_response$response_df)
    } else {
      df <- ons_api_response$response_df
    }
    setTxtProgressBar(pb, value = i)
  }

  return(df)
}

api_wait <- function(api_response){
  wait_time = as.numeric(headers(api_response)$`retry-after`)+3
  print(sprintf("API rate limit reached, waiting %i seconds before resuming",wait_time))
  Sys.sleep(wait_time)
  print("Continuing REST query.")
}
#onsGET <- function(url){
#
# response <- httr::GET(url)
# df_query <- httr::content(response, "text", encoding = "UTF-8") |>
#   jsonlite::fromJSON(flatten = TRUE) |>
#   as.data.frame()
#
# return(df_query)
# }
#
# get_pased_uri <- function(){
#   path <- "https://api.ons.gov.uk/timeseries"
#   uri <- httr::parse_url(path)
#   return(uri)
# }
