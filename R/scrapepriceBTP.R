# Hello, scrapepriceBTP!
#
#
#' @description This is a function that scrapes BTP price from Borsa Italiana based on a provided ISIN.
#' @param BTP ISIN
#' @return price
#
#' @import dplyr
#' @import glue
#' @import stringr
#' @import rvest
#' @export


scrapepriceBTP <- function(ISIN){
  url <- glue("https://www.borsaitaliana.it/borsa/obbligazioni/mot/btp/scheda/{ISIN}.html?lang=it")
  url = URLencode(as.character(url))
  download.file(url, destfile = "scrapedpage.html", quiet=TRUE)
  webpage  <- read_html("scrapedpage.html")
  price <- webpage %>% html_nodes("strong") %>% .[[2]] %>% html_text() %>% stringr::str_replace(., ",", ".") %>% as.numeric()
  return(price)
}
