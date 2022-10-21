# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#' @description
#' @param
#' @return
#
#' @import dplyr
#' @import gmailr
#' @examples



sendgmailr <- function(from, to, subject, body){
  emailtosend <-
    gm_mime() %>%
    gm_to(to) %>%
    gm_from(from) %>%
    gm_subject(subject) %>%
    gm_text_body(body) %>%
    gm_send_message()
}
