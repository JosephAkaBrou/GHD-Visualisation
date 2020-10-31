suppressPackageStartupMessages(library(sf))
library(dplyr)
library(ggplot2)
library(ggiraph)
library(scatterpie)
library(reshape2)
library(readxl)

save(data3, file = "data3.Rdata")
save(Population, file = "Population.Rdata")

# Données geometry 
world <- st_as_sf(rnaturalearth::countries110)
europe <- dplyr::filter(world, region_un=="Europe" & name!='Russia')
europe.bbox <- st_polygon(list(matrix(c(-25,29,45,29,45,75,-25,75,-25,29),byrow = T,ncol = 2)))
europe.clipped <- suppressWarnings(st_intersection(europe, st_sfc(europe.bbox, crs=st_crs(europe))))
europe.clipped <- europe.clipped[,c("admin", "geometry", "adm0_a3")]

# Population 
Population <- read_excel("Population.xls", skip = 2)
Population <- Population[c(1,2,55:64)]
Population[Population$`Country Name` == "Kosovo","Country Code"] <- "KOS"

# jointure
df_geo_pop = left_join(europe.clipped,Population, by = c("adm0_a3"="Country Code"))

# Données sur les accidents
#setwd("C:/Users/thars/Desktop/GHD-Visualisation")
#data3 = read.csv2("data3.csv", sep = ",")

df = data3[data3$cause == "Road injuries" & data3$year == str(input$annee),]
df_select = df[,c("location", "sex", "val")]
df_t = dcast(df_select, location ~ sex, fun = sum)
df_t$total = df_t$Female + df_t$Male
df_t$taux_female = paste(round((df_t$Female / df_t$total)*100,0), "%")
df_t$taux_male = paste(round((df_t$Male / df_t$total)*100,0), "%")
df_t$Country = df_t$location

# Jointure
df_final = left_join(df_geo_pop,df_t, by = c("admin"="location"))

# Carte
gg <- ggplot(df_final) +
  geom_sf_interactive(mapping = aes(fill = (total/input$annee)*100, 
                                 tooltip = paste("Pays : ", 
                                                 admin,"<br/>", 
                                                 "Taux de mortalité : ", 
                                                 paste(round((total/input$annee)*100,2), " %"), "<br/>",
                                                 "Nombre de morts : ", 
                                                 round(total,0), "<br/>",
                                                 "Taux de morts 'Female' : ", 
                                                 taux_female, "<br/>",
                                                 "Taux de morts 'Male' : ", 
                                                 taux_male, "<br/>"), 
                                 data_id = admin))+
  scale_fill_gradient2(name = "Taux de mortalité (en %)",mid = "lightyellow", high = "red", 
                       na.value="lightgrey",guide = "colourbar")+
  ggtitl(paste("Nombre de mortalité par accident de la route en ", str(input$annee)))+
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))+
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = "gray96"))+
  xlab(NULL)+ 
  ylab(NULL)+
  geom_rect(xmin = -25, xmax = -15, ymin = 30, ymax = 32, 
            fill = "lightgrey", color = "gray43", size = 0.4)+
  annotate(geom = "text", x = -20, y = 31, label = "NA", color = "grey22", size = 4) 
  

p <- girafe(ggobj = gg) %>%
  girafe_options(opts_tooltip(opacity = .8),
                 opts_zoom(min = .5, max = 4),
                 opts_hover(css = "fill:white;stroke:orange;r:7pt;") )
if( interactive() ) print(p)
  
  