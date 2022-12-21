# listONSdata.R

website <-"https://www.ons.gov.uk/timeseriestool" |> xml2::read_html()

x <- website %>% html_element(css = "h2") %>% html_text2() %>% gsub(.,""," time series data") #%>% gsub(.,"",",")

max <- website %>%
  html_element(css = "ul.pagination > li:nth-last-child(2)") %>%
  html_text() %>%
  as.numeric()
