# load packages ----------------------------------------------------------------

library(tidyverse)
library(rvest)
library(glue)

# list of urls to be scraped ---------------------------------------------------

root <- "https://collections.ed.ac.uk/art/search/*:*/Collection:%22edinburgh+college+of+art%7C%7C%7CEdinburgh+College+of+Art%22?offset="
# For time we are onyl going up to the first 70
numbers <- seq(from = 0, to = 70, by = 10)
urls <- glue("{root}{numbers}")

# map over all urls and output a data frame ------------------------------------

uoe_art <- map_dfr(urls, scrape_page)



add_description <- function(indv_page_url){
  read_html(indv_page_url) %>%
    html_node("tr:nth-child(5) span") %>%
    html_text()%>%
    str_squish()
}

uoe_art <- uoe_art %>% mutate(description = map_chr(link,add_description))


# write out data frame ---------------------------------------------------------

write_csv(uoe_art, file = "data/uoe-art.csv")
