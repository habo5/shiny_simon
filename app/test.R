library(tidyverse)
passat <- readxl::read_excel("C:/Users/hajer/OneDrive/Documents/GitHub/shiny_simon/app/passat.xlsx") %>%
  filter(year >= 2014)
passat$year
