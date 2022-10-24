# Hello, sendgmailr!
#
#' @description This is a function that send an email.
#' @param from email address
#' @param to email address
#' @param subject of the email
#' @param body of the email
#
#' @import dplyr
#' @import gmailr
#' @export



sendgmailr <- function(from, to, subject, body){
  emailtosend <-
    gm_mime() %>%
    gm_to(to) %>%
    gm_from(from) %>%
    gm_subject(subject) %>%
    gm_text_body(body) %>%
    gm_send_message()
}
