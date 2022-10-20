# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#' @description
#' @param
#' @return
#
#' @import dplyr
#' @import glue
#' @import stringr
#' @examples



scrapepriceBTP <- function(ISIN){
  url <- glue("https://www.borsaitaliana.it/borsa/obbligazioni/mot/btp/scheda/{ISIN}.html?lang=it")
  url = URLencode(as.character(url))
  download.file(url, destfile = "scrapedpage.html", quiet=TRUE)
  webpage  <- read_html("scrapedpage.html")
  price <- webpage %>% html_nodes("strong") %>% .[[2]] %>% html_text() %>% stringr::str_replace(., ",", ".") %>% as.numeric()
  return(price)
}
