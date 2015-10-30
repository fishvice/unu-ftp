## ---- eval = FALSE-------------------------------------------------------
## # data preparations
## library(fjolst)
## library(dplyr)
## library(readr)
## library(lubridate)
## library(gisland)
## 
## # fish data
## stations <-
##   stodvar %>%
##   filter(synaflokkur == 30) %>%
##   mutate(synis.id = as.integer(synis.id),
##          hour = floor(kl.kastad),
##          min = round((kl.kastad - hour) * 60, 0),
##          date = ymd_hm(paste0(ar,"-",man,"-",dags,"- ",hour,":",min))) %>%
##   select(sample.id = synis.id,
##          date,
##          station.id = stod,
##          long = lon,
##          lat,
##          depth = dypi,
##          temperature = botnhiti) %>%
##   arrange(sample.id) %>%
##   tbl_df()
## 
## stations %>%
##   write.csv("data/stations.csv", row.names = FALSE)
## stations %>%
##   write.csv("/net/www/export/home/hafri/einarhj/public_html/data/stations.csv",
##             row.names = FALSE)
## system("chmod a+r /net/www/export/home/hafri/einarhj/public_html/data/stations.csv")
## 
## fish <-
##   all.kv %>%
##   filter(synis.id %in% stations$sample.id) %>%
##   mutate(synis.id = as.integer(synis.id),
##          sex = ifelse(kyn == 1, "Male",
##                       ifelse(kyn == 2, "Female", NA)),
##          maturity = ifelse(kynthroski == 1, "Immature",
##                            ifelse(kynthroski > 1, "Mature", NA))) %>%
##   select(sample.id = synis.id,
##          length = lengd,
##          age = aldur,
##          sex,
##          maturity,
##          weight = oslaegt,
##          w.gutted.weight = slaegt,
##          w.liver = lifur,
##          w.gonad = kynfaeri,
##          species=tegund)
## 
## # get top 9 species with the highest numbers measured
## top9 <- fish %>%
##   group_by(species) %>%
##   summarise(n = n()) %>%
##   arrange(desc(n)) %>%
##   slice(1:9)
## 
## # slice the top 9
## fish <- fish  %>%
##   filter(species %in% top10$species) %>%
##   arrange(sample.id)
## 
## # English names to species
## sp <- ora::sql("select * from orri.fisktegundir") %>%
##   select(tegund, enskt.heiti) %>%
##   filter(tegund %in% top9$species) %>%
##   rename(species = tegund) %>%
##   mutate(name = enskt.heiti,
##          name = ifelse(name == "Tusk, torsk, cusk","Tusk",name),
##          name = ifelse(name == "Greater argentine", "Argentine", name),
##          name = ifelse(name == "Atlantic wolffish", "Wolffish", name)) %>%
##   select(species, name)
## 
## fish <- fish %>% left_join(sp) %>%
##   select(-species) %>%
##   rename(species = name)
## fish %>% write.csv("data/fish.csv", row.names = FALSE)
## fish  %>%
##   write.csv("/net/www/export/home/hafri/einarhj/public_html/data/fish.csv",
##             row.names = FALSE)
## system("chmod a+r /net/www/export/home/hafri/einarhj/public_html/data/fish.csv")
## 
## # gis data
## 
## # do not include "sker"
## i <- biceland$flaki %in% c("mainland","eyjar")
## df <- biceland@data[i,]
## d <- rgeos::gSimplify(biceland[i,],0.01,topologyPreserve=TRUE) %>%
##   sp::SpatialPolygonsDataFrame(df, match.ID = TRUE) %>%
##   ggplot2::fortify(iceland_sparse) %>%
##   select(long, lat, group) %>%
##   rename(id = group)
## df <- data.frame(id = unique(d$id))
## df$group <- 1:nrow(df)
## d <- d %>%
##   left_join(df) %>%
##   select(-id)
## readr::write_csv(d, "data/iceland.csv")
## d %>%
##   write.csv("/net/www/export/home/hafri/einarhj/public_html/data/iceland.csv",
##             row.names = FALSE)
## system("chmod a+r /net/www/export/home/hafri/einarhj/public_html/data/iceland.csv")

