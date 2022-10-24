library(tidyverse)
library(glue)
library(rvest)
library(gmailr)
library(jsonlite)
ISIN <- "IT0003934657"

pricenow <- scrapepriceBTP(ISIN = ISIN)
date <- Sys.time()
row <- data.frame(date, pricenow)
write_csv(row,paste0('data/pricenow.csv'),append = T)


CLIENT_ID_SECRET <- Sys.setenv(CLIENT_ID_SECRET = read_json("BTPalert.json")$installed$client_id)
CLIENT_SECRET_SECRET <- Sys.setenv(CLIENT_SECRET_SECRET = read_json("BTPalert.json")$installed$client_secret)
EMAILFROM_SECRET <- Sys.setenv(EMAILFROM_SECRET = "luigi.vinegar@gmail.com")
EMAILTO_SECRET <- Sys.setenv(EMAILTO_SECRET = "luigi.aceto@genre.com")

gm_auth_configure(key = Sys.getenv("CLIENT_ID_SECRET"), secret = Sys.getenv("CLIENT_SECRET_SECRET"))
options(
  gargle_oauth_cache = "./.secret",
  gargle_oauth_email = Sys.getenv("EMAILFROM_SECRET")
)
gm_auth(email = Sys.getenv("EMAILFROM_SECRET"))


targetprice <- 94

if (pricenow < targetprice) {
  sendgmailr(from = Sys.getenv("EMAILFROM_SECRET"), to = Sys.getenv("EMAILTO_SECRET"), subject = "good price", body = glue::glue("current price is {pricenow}"))
}

