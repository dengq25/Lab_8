# load packages ----------------------------------------------------------------

library(tidyverse)
library(rvest)

# set url ----------------------------------------------------------------------

first_url <- "https://collections.ed.ac.uk/art/search/*:*/Collection:%22edinburgh+college+of+art%7C%7C%7CEdinburgh+College+of+Art%22?offset=0"

# read first page --------------------------------------------------------------

page <- read_html(first_url)

# scrape titles ----------------------------------------------------------------

# scrape titles
titles <- page %>%
  html_nodes(".iteminfo") %>%
  html_node("h3 a") %>%
  html_text() %>%
  str_squish()

# scrape links -----------------------------------------------------------------

# scrape links
links <- page %>%
  html_nodes(".iteminfo") %>%
  html_node("h3 a") %>%
  html_attr("href") %>%
  str_replace(
    pattern = "^\\./record",
    replacement = "https://collections.ed.ac.uk/art/record"
  )

# scrape artists ---------------------------------------------------------------

artists <- page %>%
  html_nodes(".iteminfo") %>%
  html_node(".artist") %>%
  html_text() %>%
  str_squish()

# put together in a data frame -------------------------------------------------

first_ten <- tibble(
  title = titles,
  artist = artists,
  link = links
)

# scrape second ten paintings --------------------------------------------------

second_url <- "https://collections.ed.ac.uk/art/search/*:*/Collection:%22edinburgh+college+of+art%7C%7C%7CEdinburgh+College+of+Art%22?offset=10"

page <- read_html(second_url)

# scrape titles (second page)
titles2 <- page %>%
  html_nodes(".iteminfo") %>%
  html_node("h3 a") %>%
  html_text() %>%
  str_squish()

# scrape artists (second page)
artists2 <- page %>%
  html_nodes(".iteminfo") %>%
  html_node(".artist") %>%
  html_text() %>%
  str_squish()

# scrape links (second page)
links2 <- page %>%
  html_nodes(".iteminfo") %>%
  html_node("h3 a") %>%
  html_attr("href") %>%
  str_replace(
    pattern = "^\\./record",
    replacement = "https://collections.ed.ac.uk/art/record"
  )

second_ten <- tibble(title = titles2,
                     artist = artists2,
                     link = links2
)
first_twenty <- bind_rows(first_ten, second_ten)
nrow(first_twenty)
write_csv(first_twenty, "data/uoe-art.csv")

