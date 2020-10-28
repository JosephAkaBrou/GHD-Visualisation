library(ggplot2)


data = read.csv("https://raw.githubusercontent.com/JosephAkaBrou/GHD-Visualisation/main/data3.csv")

# Ici j'ai créer les vecteurs de valeurs qui permetent de changer le visuel ####
sex = as.character(unique(data$sex))
causes = as.character(unique(data$cause))
location = as.character(unique(data$location))
year = as.integer(unique(data$year))
age =as.integer(unique(data$age))


# La ici je créer les 3 variables qu'on peut faire varier.####

# Pour sex il y a que deux valeurs possibles ####
# Pour la cause, il y a 20 valeurs possibles ####
# Et pour la location 45 valeurs ####
sex_value = sex[2] # Choisi un nombre entre 1 et 2 
cause_value = causes[1] # Choisi un nombre entre 1 et 20
location_value = location[2] # Choisi un nombre entre 1 et 45 


# Là ici on fait un filtre avec kes 3 variables au dessus. En situation réelle, il faut une liste qui permet de choisir à l'utilisateur
# Quelles valeurs de sex, cause et location il veut voir. Pour l'exemple j'ai juste rendu possible la sélection aléatoire juste haut. 

filtered_df = data[(data$sex == sex_value) & (data$cause == cause_value) & (data$location == location_value),
          c("val","year", "upper","lower")]

# Ici je fais la moyenne pour chaque année. Parce que après avoir filtrer on obtient plusieurs valeurs par année. Ces valeurs correspondent aux valeurs ####
# des classes d'ages ####
agg <- aggregate(list(filtered_df$val, filtered_df$upper, filtered_df$lower), by = list(filtered_df$year), mean)
names(agg) = c("year", "val", "upper", "lower")


# Et là ici un graphique ####


ggplot() + 
  geom_line(data=agg, aes(x=year, y=val, group=1)) + 
  geom_point(data=agg, aes(x=year, y=val, group=1)) +
  geom_line(data=agg, aes(x=year, y=upper, group=1), linetype = "dashed", color="red") +
  geom_line(data=agg, aes(x=year, y=lower, group=1), linetype = "dashed", color="red") +
  scale_x_continuous(breaks=year)
  











