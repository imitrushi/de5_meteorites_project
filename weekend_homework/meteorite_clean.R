# load tidyverse and read in data ----

library(tidyverse)

meteorite_landings_clean <- read_csv("meteorite_landings.csv")


# rename columns ----
meteorite_landings_clean <- meteorite_landings_clean %>% 
  rename(mass_g = "mass (g)", geo_location = GeoLocation)

# remove parenthesis from 'geo_location'values
meteorite_landings_clean <- meteorite_landings_clean %>% 
  mutate(geo_location = str_replace(geo_location, pattern = "\\(", replacement = "")) %>% 
  mutate(geo_location = str_replace(geo_location, pattern = "\\)", replacement = ""))

# split column into two ----
meteorite_landings_clean <- meteorite_landings_clean %>% 
  separate(geo_location, c("latitude", "longitude"), sep = ",")

# change type to numeric ----
meteorite_landings_clean <- meteorite_landings_clean %>% 
  mutate(latitude = as.numeric(latitude)) %>% 
  mutate(longitude = as.numeric(longitude))

# replace NA with 0 ----
meteorite_landings_clean <-meteorite_landings_clean %>%
  mutate(latitude = coalesce(latitude, 0)) %>% 
  mutate(longitude = coalesce(longitude, 0))

# filter out meteorites lighter than 1kg and arrange by year ----
meteorite_landings_clean <- meteorite_landings_clean %>% 
  filter(mass_g < 1000) %>% 
  group_by(year) %>% 
  arrange(year)

# write the clean file
write_csv(meteorite_landings_clean, "meteorite_landings_clean.csv")

