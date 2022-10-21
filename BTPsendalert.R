library(tidyverse)
library(glue)
library(rvest)
library(gmailr)
ISIN <- "IT0003934657"

pricenow <- scrapepriceBTP(ISIN = ISIN)
date <- Sys.time()
row <- data.frame(date, pricenow)
write_csv(row,paste0('data/pricenow.csv'),append = T)

gm_auth_configure(path = "BTPalert.json")
GMAILR_APP <- "BTPalert.json"
# usethis::edit_r_environ()
# gm_auth_configure()
gm_auth(email = "luigi.vinegar@gmail.com")


targetprice <- 93

if (pricenow < targetprice) {
  sendgmailr(from = "luigi.vinegar@gmail.com", to = "luigi.aceto@genre.com", subject = "good price", body = glue::glue("current price is {pricenow}"))
}

