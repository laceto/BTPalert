library(tidyverse)
library(glue)
library(rvest)
ISIN <- "IT0003934657"

pricenow <- scrapepriceBTP(ISIN = ISIN)
date <- Sys.time()
row <- data.frame(date, pricenow)
write_csv(row,paste0('data/pricenow.csv'),append = T)

targetprice <- 93

if (pricenow < targetprice) {
  sendgmailr(from = "luigi.vinegar@gmail.com", to = "luigi.aceto@genre.com", subject = "good price", body = glue::glue("current price is {pricenow}"))
}
