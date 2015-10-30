## ---- echo = FALSE, message = FALSE--------------------------------------
knitr::opts_chunk$set(collapse = T, comment = "#>", warning = FALSE, message = FALSE)
options(dplyr.print_min = 4L, dplyr.print_max = 4L)

## ---- message = FALSE----------------------------------------------------
library(dplyr)
library(lubridate)
library(ggplot2)

## ------------------------------------------------------------------------
d.all <- read.csv("http://www.hafro.is/~einarhj/data/fish.csv", stringsAsFactors = FALSE) %>%
  left_join(read.csv("http://www.hafro.is/~einarhj/data/stations.csv", stringsAsFactors = FALSE)) %>%
  tbl_df()
glimpse(d.all)
d.all %>%
  group_by(species) %>%
  summarise(n = n()) %>%
  arrange(desc(n))

## ------------------------------------------------------------------------
d <- d.all %>%
  sample_frac(1/5, replace = FALSE)

## ------------------------------------------------------------------------
d %>%
  group_by(species) %>%
  summarise(n = n()) %>%
  arrange(desc(n))

## ------------------------------------------------------------------------
p <- ggplot()

## ---- eval = FALSE-------------------------------------------------------
## class(p)
## str(p)

## ---- warning = FALSE----------------------------------------------------
p + layer(data = d,
          mapping=aes(x = length, y = weight), 
          geom = 'point',
          stat='identity',
          position = 'identity')

## ---- eval = FALSE-------------------------------------------------------
## ggplot()         + geom_point(data = d, aes(length, weight))
## ggplot(data = d) + geom_point(aes(x = length,   y = weight))
## ggplot(d)        + geom_point(aes(length,           weight))
## ggplot()         + geom_point(data = d, aes(length, weight))
## d %>% ggplot()   + geom_point(data = d, aes(length, weight))

## ---- warning = FALSE----------------------------------------------------
p <- ggplot(data = d, aes(length, weight))
p + geom_point(size = 1)
p + geom_point(alpha = 0.01)
p + geom_point(size = 1, alpha = 0.01, col = "red")
p2 <- p + geom_point() +
  labs(x = "Length [cm]",
       y = "Weigth [g]",
       title = "Weight as a function of length")
p2

## ------------------------------------------------------------------------
p2 + theme_bw()

## ------------------------------------------------------------------------
?theme

## ------------------------------------------------------------------------
p <- d %>%
  ggplot(aes(age , weight, col = species)) + 
  theme_bw() +
  geom_point(size = 2, alpha = 0.3)
p

## ------------------------------------------------------------------------
p1 <- p + scale_colour_brewer(palette = "Set1")
p1

## ------------------------------------------------------------------------
p1 + xlim(0,20) + ylim(0,20000)

## ------------------------------------------------------------------------
d %>%
  ggplot(aes(age , weight, col = species)) + 
  theme_bw() +
  geom_jitter(size = 2, alpha = 0.3) +
  scale_colour_brewer(palette = "Set1") +
  xlim(0,20) + ylim(0,20000)

## ------------------------------------------------------------------------
d2 <- d %>%
  group_by(species, age) %>%
  summarise(n   =   n(),
            m   =   mean(length),
            q50 =   quantile(length, probs = 0.50),
            q05 =   quantile(length, probs = 0.05),
            q95 =   quantile(length, probs = 0.95))
p <- d2 %>%
  ggplot(aes(age, m, col = species)) +
  theme_bw() +
  geom_point() +
  scale_colour_brewer(palette = "Set1") + 
  xlim(0,20) +
  labs(x = "Age", y = "Mean length")
p

## ------------------------------------------------------------------------
p + geom_line()
p + geom_smooth(aes(fill = species))

## ---- eval = FALSE-------------------------------------------------------
## p + geom_smooth(aes(fill = species)) +
##   scale_fill_brewer(palette = "Set1")

## ------------------------------------------------------------------------
p2 <- p +
  geom_linerange(aes(ymin = q05,
                     ymax = q95))
p2

## ------------------------------------------------------------------------
p2 + facet_wrap(~ species)

## ------------------------------------------------------------------------
p2 + facet_wrap(~ species, scale = "free_y")

## ------------------------------------------------------------------------
d2 %>%
  ggplot() +
  geom_text(aes(age, m, label = n), size = 2) +
  facet_wrap(~ species, scale = "free_y")

## ------------------------------------------------------------------------
p <- d2 %>%
  ggplot() +
  geom_point(aes(age, n)) +
  xlim(0,20)
p
p + facet_wrap(~ species)
p + facet_wrap(~ species, scale = "free_y") +
  labs(x = "Age", y = NULL, title = "Number of fish measured in each age group")

## ------------------------------------------------------------------------
ggplot(d, aes(length)) + geom_histogram()

## ------------------------------------------------------------------------
ggplot(d, aes(length)) + geom_histogram(binwidth = 1)

## ----message = FALSE-----------------------------------------------------
library(knitr)
library(printr)
library(readr)
library(lubridate)
library(ggplot2)
library(maps)
library(mapdata)
library(ggmap)
library(leaflet)
library(dplyr)

## ---- warning = FALSE, message = FALSE, fig.width = 15, fig.height = 15----
iceland <- read_csv("http://www.hafro.is/~einarhj/data/iceland.csv")
glimpse(iceland)

## ---- warning = FALSE, message = FALSE-----------------------------------
p <- iceland %>%
  ggplot(aes(long,lat)) + labs(x = NULL, y = NULL) + theme_bw()

## ---- warning = FALSE, message = FALSE-----------------------------------
p + geom_point(size = 1)

## ---- warning = FALSE, message = FALSE-----------------------------------
p + geom_line(lwd = 0.1)

## ---- tidy=FALSE, render.args=list(help=list(sections=c('description')))----
?geom_line

## ---- warning = FALSE, message = FALSE-----------------------------------
p + geom_path()

## ---- tidy=FALSE, render.args=list(help=list(sections=c('description')))----
?geom_path

## ---- warning = FALSE, message = FALSE-----------------------------------
p + geom_path(aes(colour = factor(group)))

## ---- warning = FALSE, message = FALSE-----------------------------------
p + geom_path(aes(group = group))

## ---- warning = FALSE, message = FALSE-----------------------------------
p + geom_polygon(fill = "grey", alpha = 0.5)

## ---- warning = FALSE, message = FALSE-----------------------------------
p + geom_polygon(aes(group = group), fill = "grey", alpha = 0.5)

## ---- warning = FALSE, message = FALSE, fig.width = 8, fig.height = 2----
p + geom_polygon(aes(group = group), fill = "grey", alpha = 0.5)

## ---- warning = FALSE, message = FALSE, fig.width = 8, fig.height = 2----
m <- p + geom_polygon(aes(group = group), fill = "grey", alpha = 0.4) + coord_map()
m

## ------------------------------------------------------------------------
fellows_world <- map_data("worldHires") %>%
  filter(region %in% c("Djibouti", "Dominica", "Namibia", "Tanzania", "Uganda"))
glimpse(fellows_world)
fellows_world %>%
  ggplot() + 
  labs(x = NULL, y = NULL) + 
  theme_bw() +
  coord_map() +
  geom_polygon(aes(long, lat, group = group, fill = region)) +
  scale_fill_brewer(palette = "Set1")

## ---- warning = FALSE----------------------------------------------------
st <- read_csv("http://www.hafro.is/~einarhj/data/stations.csv")
  
m + geom_point(data = st,aes(long, lat), col="red")
m + geom_point(data = st,aes(long,lat, size = depth))
m + geom_point(data = st,aes(long,lat, colour = depth))
m + geom_point(data = st, aes(long, lat, colour = temperature)) +
  scale_color_gradientn(colours = rainbow(5)[5:1])

## ------------------------------------------------------------------------
fish <- read.csv("http://www.hafro.is/~einarhj/data/fish.csv")

## ------------------------------------------------------------------------
fish <- fish %>%
  mutate(weight = 0.00001 * length^3)

## ------------------------------------------------------------------------
catch <- fish %>%
  group_by(sample.id) %>%
  summarise(catch = sum(weight, na.rm = TRUE),
            length = mean(length, na.rm = TRUE))
glimpse(catch)

## ------------------------------------------------------------------------
catch.all <- st %>%
  left_join(catch) %>%
  mutate(catch = ifelse(is.na(catch), 0, catch), # put zero if not catch at statio
         length = ifelse(is.na(length), 0, length))

catch <- catch.all %>% filter(year(date) == 2015)
m + 
  geom_point(data = catch, 
             aes(long, lat, size = catch), 
             col = "red", 
             alpha = 0.3) +
  scale_size_area(max_size = 15) +
  labs(title = "Catch per tow in 2015", size = "Catch [kg]")

## ---- message = FALSE----------------------------------------------------
m2 <- get_map(location = c(-19,65), zoom= 6, maptype = "satellite", source = "google")
m2 <- ggmap(m2) +
  labs(x = NULL, y = NULL)
m2

## ---- warning = FALSE----------------------------------------------------
m2 + 
  geom_point(data = catch,aes(long, lat, size = catch), col = "red", alpha = 0.3) +
  scale_size_area(max_size = 15) +
  labs(title = "Catch per tow in 2015", size = "Catch [kg]")

## ---- message = FALSE, warning = FALSE-----------------------------------
bbox <- c(left = min(st$long, na.rm = TRUE), 
          bottom = min(st$lat, na.rm = TRUE),
          right = max(st$long, na.rm = TRUE),
          top = max(st$lat, na.rm = TRUE))
m2 <- get_map(location = bbox, source = "osm")
ggmap(m2) +
  labs(x = NULL, y = NULL) +
  geom_point(data = catch,
             aes(long, lat, size = catch),
             col = "red",
             alpha = 0.3) +
  scale_size_area(max_size = 15) +
  labs(title = "Catch per tow in 2015", size = "Catch [kg]")

## ------------------------------------------------------------------------
ggmap(gisland::get_sjokort(bbox = bbox, r = 1.1, zoom = 7)) +
  labs(x = NULL, y = NULL) +
  geom_point(data = catch,
             aes(long, lat, size = catch),
             col = "red",
             alpha = 0.3) +
  scale_size_area(max_size = 15)

## ------------------------------------------------------------------------
leaflet() %>%
  addTiles() %>%
  addCircles(data = catch, 
             lng = ~long,
             lat = ~lat,
             weight = 1, 
             col="red",
             radius = sqrt(catch$catch) * 1e3)

## ---- eval = FALSE-------------------------------------------------------
## fellows_world <- map("worldHires", exact = TRUE, fill = TRUE,
##                  plot = FALSE,
##                  region = c("Djibouti", "Dominica", "Namibia", "Tanzania", "Uganda"))
## 
## leaflet() %>%
##   addTiles() %>%
##   addPolygons(data=fellows_world, fillColor = "red", stroke = FALSE)

