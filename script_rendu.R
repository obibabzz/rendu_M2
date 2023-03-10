setwd("D:/Cours/rendu_M2")

#ouverture des données

library(readr)
table_placette <- read_delim("data.evaluation/mesures/table_placette.csv", 
                             delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(table_placette)

library(readr)
table_essence <- read_delim("data.evaluation/mesures/table_essence.csv", 
                            delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(table_essence)

library(readr)
table_arbre <- read_delim("data.evaluation/mesures/table_arbre.csv", 
                          delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(table_arbre)

library(readr)
bois_mort_sol_prive <- read_delim("data.evaluation/mesures/bois.mort.sol.prive.csv", 
                                  delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(bois_mort_sol_prive)

#ouverture vecteur

BDForet <- sf::st_read("./data.evaluation/SIG/BDForetv2_foret_PNRfilled_propriete.shp", stringsAsFactors = TRUE)
sf::st_bbox(BDForet)
#sf::st_crs(BDForet) <- 2154
#plot(BDForet[BDForet$geometry == "BDForet"], key.pos = 4, axes = TRUE)

ggplot(data = ["notation"]) +
  geom_sf(aes(fill = notation)) +
  geom_sf(data = coord.sf["id"]) +
  # datum pour le quadrillage
  coord_sf(datum = 2154) 

#ouverture du raster

MNT <- terra::rast("./data.evaluation/SIG/MNT_all_25m.tif")
terra::ext(MNT)
terra::crs(MNT) <- "epsg:2154"
terra::plot(MNT, main = "MNT")
terra::global(MNT, mean)

#péparation des données


table_arbre1<- table_arbre[table_arbre$`Diam 1` < 30, ]
table_arbre1 <- table_arbre1[ , -9]

table_arbre2<- table_arbre[table_arbre$`Diam 1` >= 30, ]
table_arbre2 <- table_arbre2[ , -8]

names(table_arbre1)[8] <- "Diam"
names(table_arbre2)[8] <- "Diam"

table_arbre_def <- rbind(table_arbre1, table_arbre2)
table_arbre_def <- table_arbre_def[table_arbre_def$Diam < 185,]

write.csv(table_arbre_def, file="table_arbre_def.csv")

table_arbre_def <- rowid_to_column(table_arbre_def, "ID")
table_arbre1 <- subset(table_arbre_def, Dist_arbre > 15 & Diam > 70)
table_arbre2 <- table_arbre_def[table_arbre_def$ID != table_arbre1$ID, ]
