library(ggplot2)
library(hrbrthemes)
library(dplyr)
library(ggforce)
library(plotly)

data = read.csv("https://raw.githubusercontent.com/JosephAkaBrou/GHD-Visualisation/main/data3.csv")

# Ici j'ai cr?er les vecteurs de valeurs qui permetent de changer le visuel ####
sex = as.character(unique(data$sex))
causes = as.character(unique(data$cause))
Country = as.character(unique(data$location))
data$year = as.factor(data$year)
year = unique(data$year)
age =as.integer(unique(data$age))



# La ici je cr?er les 3 variables qu'on peut faire varier.####

# Pour sex il y a que deux valeurs possibles ####
# Pour la cause, il y a 20 valeurs possibles ####
# Et pour la Country 45 valeurs ####
sex_value = sex[2] # Choisi un nombre entre 1 et 2 
cause_value = causes[1] # Choisi un nombre entre 1 et 20
location_value = c(location[5], location[8], location[2]) # Choisi un nombre entre 1 et 45 


# L? ici on fait un filtre avec kes 3 variables au dessus. En situation r?elle, il faut une liste qui permet de choisir ? l'utilisateur
# Quelles valeurs de sex, cause et Country il veut voir. Pour l'exemple j'ai juste rendu possible la s?lection al?atoire juste haut. 

filtered_df = data[(data$cause == cause_value) & (data$Country %in% location_value),
          c("val","year", "upper","lower", "sex", "location")]

# Ici je fais la moyenne pour chaque ann?e. Parce que apr?s avoir filtrer on obtient plusieurs valeurs par ann?e. Ces valeurs correspondent aux valeurs ####
# des classes d'ages ####
agg <- aggregate(list(filtered_df$val, filtered_df$upper, filtered_df$lower), by = list(filtered_df$year, filtered_df$sex, filtered_df$location), mean)
names(agg) = c("year", "sex", "Country", "val", "upper", "lower")
agg$sex = as.character(agg$sex)
agg$sex[agg$sex=="Female"] <- "Women"
agg$sex[agg$sex=="Male"] <- "Men"



# Ici on calcul la moyenne pour chaque pour les femmes et hommes de tous les pays

full_data = data[(data$cause == cause_value), c("val","year", "upper","lower", "sex")]
agg_full <- aggregate(list(full_data$val, full_data$upper, full_data$lower), by = list(full_data$year, full_data$sex), mean)
names(agg_full) = c("year", "sex", "val", "upper", "lower")
agg_full$sex = as.character(agg_full$sex)
agg_full$sex[agg_full$sex=="Female"] <- "Women"
agg_full$sex[agg_full$sex=="Male"] <- "Men"
agg_full$Europe = "Europe"

# Et l? ici un graphique ####

list_des_pays = paste(location_value, collapse = ", ")

p <- ggplot(data = agg, mapping = aes(x = year, y = val, group=Country)) +
  geom_mark_ellipse(aes(fill = Country, 
                        label = Country), 
                        expand = 0.005,
                        alpha = 0.1,
                        size = 0.1) +
  theme_ipsum() +
  geom_ribbon(aes(ymin = lower, ymax = upper), fill = "grey70", alpha = 0.3) +
  geom_line( color="black") +
  geom_line(data=agg_full, aes(x=year, y=val, group=1), linetype=2, color="red") +
  geom_point(shape=21, color="grey", fill="#69b3a2", size=3) +
  facet_wrap( ~ sex, ncol=2) +
  ggtitle(paste("Evolution des morts de", cause_value,"en ", list_des_pays)) +
  annotate(
    geom = "curve", x = 2, y = 1700, xend = 1.5, yend = max(agg_full[sex ==sex, "val"]) +1, 
    curvature = .3, arrow = arrow(length = unit(2, "mm"))
  ) +
  annotate(geom = "text", x = 2.1, y = 1700, label = "European mean", hjust = "left")
  

ggplotly(p)










