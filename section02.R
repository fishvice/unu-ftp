## ---- echo = FALSE, message = FALSE--------------------------------------
knitr::opts_chunk$set(collapse = T, comment = "#>")
options(dplyr.print_min = 4L, dplyr.print_max = 4L)

## ---- message = FALSE----------------------------------------------------
library(dplyr)

## ------------------------------------------------------------------------
d <- read.csv("http://www.hafro.is/~einarhj/data/fish.csv", stringsAsFactors = FALSE) %>%
  full_join(read.csv("http://www.hafro.is/~einarhj/data/stations.csv", stringsAsFactors = FALSE)) %>%
  tbl_df()
glimpse(d)

## ------------------------------------------------------------------------
select(d, sample.id, station.id)

## ------------------------------------------------------------------------
x <- select(d, sample.id, station.id)

## ------------------------------------------------------------------------
select(d, date:temperature)

## ------------------------------------------------------------------------
select(d, -(date:temperature))

## ---- eval = FALSE-------------------------------------------------------
## d %>% select(sample.id, station.id)
## d %>% select(date:temperature)
## d %>% select(-(date:temperature))

## ---- eval = FALSE-------------------------------------------------------
## d %>% rename(depth.in.meters = depth)

## ------------------------------------------------------------------------
d %>%
  rename(length.in.centimeters = length,
         depth.in.meters = depth) %>%
  select(sample.id, length.in.centimeters, depth.in.meters)

## ---- eval = FALSE-------------------------------------------------------
## d %>%
##   rename(id -> id.sample.id,
##          l = length,
##          d  = depth) %>%
##   select(id, l, d)

## ------------------------------------------------------------------------
d %>% filter(species == "Cod")

## ---- eval = FALSE-------------------------------------------------------
## d %>% filter(species == "Cod" | species == "Redfish")

## ---- eval = FALSE-------------------------------------------------------
## d %>% filter(species %in% c("Cod","Redfish"))

## ------------------------------------------------------------------------
d %>% filter(species %in% c("Cod","Redfish"), sex == "Female")

## ------------------------------------------------------------------------
d %>% slice(1001:1002)

## ---- eval = FALSE-------------------------------------------------------
## ?sample_n
## ?sample_frac
## ?top_n

## ------------------------------------------------------------------------
d %>%
  select(sample.id, date:temperature) %>%
  distinct()

## ------------------------------------------------------------------------
d %>%
  select(sample.id, date:temperature) %>%
  distinct() %>%
  arrange(depth)

## ---- eval=FALSE---------------------------------------------------------
## d %>%
##   select(sample.id, date:temperature) %>%
##   distinct() %>%
##   arrange(desc(depth))

## ---- eval = FALSE-------------------------------------------------------
## d %>%
##   select(sample.id, date:temperature) %>%
##   distinct() %>%
##   arrange(-depth)

## ------------------------------------------------------------------------
d %>%
  mutate(derived.weight = 0.01 * length^3) %>%
  select(sample.id, length, weight, derived.weight)

## ------------------------------------------------------------------------
d %>%
  mutate(temperature = temperature + 273.15) %>%
  select(sample.id, temperature) %>%
  arrange(temperature)

## ------------------------------------------------------------------------
d %>%
  mutate(weight = ifelse(is.na(weight), 0.01 * length^3, weight)) %>%
  select(sample.id, length, weight)

## ------------------------------------------------------------------------
d %>% 
  filter(!is.na(length)) %>%
  summarise(no.measured   = n(),
            no.stations   = n_distinct(sample.id),
            no.species    = n_distinct(species),
            mean.length   = mean(length),
            sd.length     = sd(length),
            no.big.fish   = sum(length > 130))

## ------------------------------------------------------------------------
d %>% count(species)

## ------------------------------------------------------------------------
d %>% 
  filter(!is.na(length)) %>%
  group_by(species) %>%
  summarise(no.measured   = n(),
            no.stations   = n_distinct(sample.id),
            mean.length   = mean(length),
            no.length_bin = n_distinct(length),
            no.big.fish   = sum(length > 130))

## ----echo = FALSE--------------------------------------------------------
options(dplyr.print_min = 10L, dplyr.print_max = 10L)

## ------------------------------------------------------------------------
st <- data_frame(sample.id = c(1,       2,    3,    4),
                 year      = c(2014, 2014, 2015, 2015))
fi <- data_frame(sample.id = c(1,   1,  3,  4,   5),
                 species   = c(1,   2,  1,  1,   3),
                 length    = c(10, 15,  5, 10, 100))
st %>% left_join(fi)
fi %>% left_join(st)
st %>% right_join(fi)
st %>% inner_join(fi)
st %>% full_join(fi)

