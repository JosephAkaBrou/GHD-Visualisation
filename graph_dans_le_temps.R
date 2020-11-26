library(ggplot2)
library(hrbrthemes)
library(dplyr)

data = read.csv("https://raw.githubusercontent.com/JosephAkaBrou/GHD-Visualisation/main/data3.csv")

# Ici j'ai cr?er les vecteurs de valeurs qui permetent de changer le visuel ####
sex = as.character(unique(data$sex))
causes = as.character(unique(data$cause))
location = as.character(unique(data$location))
data$year = as.factor(data$year)
year = unique(data$year)
age =as.integer(unique(data$age))



# La ici je cr?er les 3 variables qu'on peut faire varier.####

# Pour sex il y a que deux valeurs possibles ####
# Pour la cause, il y a 20 valeurs possibles ####
# Et pour la location 45 valeurs ####
sex_value = sex[2] # Choisi un nombre entre 1 et 2 
cause_value = causes[1] # Choisi un nombre entre 1 et 20
location_value = location[2] # Choisi un nombre entre 1 et 45 


# L? ici on fait un filtre avec kes 3 variables au dessus. En situation r?elle, il faut une liste qui permet de choisir ? l'utilisateur
# Quelles valeurs de sex, cause et location il veut voir. Pour l'exemple j'ai juste rendu possible la s?lection al?atoire juste haut. 

filtered_df = data[(data$cause == cause_value) & (data$location == location_value),
          c("val","year", "upper","lower", "sex")]

# Ici je fais la moyenne pour chaque ann?e. Parce que apr?s avoir filtrer on obtient plusieurs valeurs par ann?e. Ces valeurs correspondent aux valeurs ####
# des classes d'ages ####
agg <- aggregate(list(filtered_df$val, filtered_df$upper, filtered_df$lower), by = list(filtered_df$year, filtered_df$sex), mean)
names(agg) = c("year", "sex", "val", "upper", "lower")


# Et l? ici un graphique ####


ggplot(data = agg, mapping = aes(x = year, y = val)) +
  geom_line( color="grey") +
  geom_point(shape=21, color="black", fill="#69b3a2", size=3) +
  theme_ipsum() +
  facet_wrap( ~ sex, ncol=3) +
  ggtitle(paste("Evolution des morts de", cause_value,"en ", location_value))

ggplot(data = agg, mapping = aes(x = year, y = val))

agg










