library(tidyverse)
library(glue)
library(rvest)
library(gmailr)
library(jsonlite)
ISIN <- "IT0003934657"

scrapepriceBTP <- function(ISIN){
  url <- glue("https://www.borsaitaliana.it/borsa/obbligazioni/mot/btp/scheda/{ISIN}.html?lang=it")
  url = URLencode(as.character(url))
  download.file(url, destfile = "scrapedpage.html", quiet=TRUE)
  webpage  <- read_html("scrapedpage.html")
  price <- webpage %>% html_nodes("strong") %>% .[[2]] %>% html_text() %>% stringr::str_replace(., ",", ".") %>% as.numeric()
  return(price)
}

pricenow <- scrapepriceBTP(ISIN = ISIN)
date <- Sys.time()
row <- data.frame(date, pricenow)
write_csv(row,paste0('data/pricenow.csv'),append = T)
pricenow

# CLIENT_ID_SECRET <- Sys.setenv(CLIENT_ID_SECRET = read_json("BTPalert.json")$installed$client_id)
# CLIENT_SECRET_SECRET <- Sys.setenv(CLIENT_SECRET_SECRET = read_json("BTPalert.json")$installed$client_secret)
# EMAILFROM_SECRET <- Sys.setenv(EMAILFROM_SECRET = "luigi.vinegar@gmail.com")
# EMAILTO_SECRET <- Sys.setenv(EMAILTO_SECRET = "luigi.aceto@genre.com")

gm_auth_configure(key = Sys.getenv("CLIENT_ID_SECRET"), secret = Sys.getenv("CLIENT_SECRET_SECRET"))
options(
  # gargle_oauth_cache = "./.secret",
  gargle_oauth_email = Sys.getenv("EMAILFROM_SECRET")
)
gm_auth(email = Sys.getenv("EMAILFROM_SECRET"))


targetprice <- 95

sendgmailr <- function(from, to, subject, body){
  emailtosend <-
    gm_mime() %>%
    gm_to(to) %>%
    gm_from(from) %>%
    gm_subject(subject) %>%
    gm_text_body(body) %>%
    gm_send_message()
}

if (pricenow < targetprice) {
  sendgmailr(from = Sys.getenv("EMAILFROM_SECRET"), to = Sys.getenv("EMAILTO_SECRET"), subject = "good price", body = glue::glue("current price is {pricenow}"))
}

