# listONSdata.R

website <-"https://www.ons.gov.uk/timeseriestool" |> xml2::read_html()

 no_ts_data <- website |>
   rvest::html_element(css = "h2") |>
   rvest::html_text2() |>
   gsub(pattern = " time series data",replacement = "") |>
   gsub(pattern = ",", replacement ="") |>
   as.numeric()

 no_of_pages <- no_ts_data


max <- website %>%
  html_element(css = "ul.pagination > li:nth-last-child(2)") %>%
  html_text() %>%
  as.numeric()
