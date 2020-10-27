suppressPackageStartupMessages(library(sf))
library(dplyr)
library(ggplot2)
library(ggiraph)

world <- st_as_sf(rnaturalearth::countries110)
europe <- dplyr::filter(world, region_un=="Europe" & name!='Russia')

europe.bbox <- st_polygon(list(
  matrix(c(-25,29,45,29,45,75,-25,75,-25,29),byrow = T,ncol = 2)))

europe.clipped <- suppressWarnings(st_intersection(europe, st_sfc(europe.bbox, crs=st_crs(europe))))

setwd("C:/Users/thars/Desktop/GHD-Visualisation")
data3 = read.csv2("data3.csv", sep = ",")
df_sum = aggregate(x = data3$val,
                  by = list(data3$location),
                  FUN = sum)
colnames(df_sum) = c("Country", "Nb_total")
df_sum$co = df_sum$Country
df_final = left_join(europe.clipped,df_sum, by = c("admin"="Country"))


gg <- ggplot(df_final) +
  geom_sf_interactive(aes(fill = Nb_total, 
                          tooltip = paste("Pays: ", name,"<br/>", "Nombre de morts: ", 
                                          round(Nb_total,0), "<br/>"), 
                          data_id = name))+
  scale_fill_gradient2(name = "Nombre de morts",low = "orange", mid = "white", high = "red", 
                       na.value="lightgrey",guide = "colourbar")+
  ggtitle("Nombre de mortalité par accident de la route")+
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
            fill = "lightgrey")+
  annotate(geom = "text", x = -20, y = 31, label = "NA", color = "grey22", size = 4) 

p <- girafe(ggobj = gg) %>%
  girafe_options(opts_tooltip(opacity = .9),
                 opts_zoom(min = .5, max = 4),
                 opts_hover(css = "fill:black;stroke:orange;r:7pt;") )
if( interactive() ) print(p)

