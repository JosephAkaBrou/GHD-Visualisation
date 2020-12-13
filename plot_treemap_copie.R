library(treemap)
library(dplyr)
library(ggplot2)
library(treemapify)

data <- read.csv("data_cause.csv")

#selection seulement des niveaux 1 et 2
data_f <- dplyr::filter(data,Level != 0)
data_f <- dplyr::filter(data_f,cause != "All causes")
data_f <- dplyr::filter(data_f,Parent.Name != "All causes")


data_lvl0 <- dplyr::filter(data,Level == 0)
data_lvl1 <- dplyr::filter(data_f,Level == 1)
data_lvl2 <- dplyr::filter(data_f,Level == 2)
data_lvl3 <- dplyr::filter(data,Level == 3)
data_lvl4 <- dplyr::filter(data,Level == 4)

#data_lvl1_sub <- data_lvl1[1:2,]
names(data_lvl1_sub)[names(data_lvl1_sub) == 'Parent.Name'] <- 'Parent'
names(data_lvl1_sub)[names(data_lvl1_sub) == 'cause'] <- 'Parent.Name'
#data_lvl2_sub <- data_lvl2[8:22,]

join_lvl_1_2 <- inner_join(data_lvl1_sub,data_lvl2_sub, by=c("Parent.Name"))


#on ne veut que les communicable
data_comm <- filter(data_lvl2,Parent.Name == 'Communicable, maternal, neonatal, and nutritional diseases')
data_non_comm <- filter(data_lvl2,Parent.Name == 'Non-communicable diseases')
data_inj <- filter(data_lvl2,Parent.Name == 'Injuries')

data_comm <- data_comm[,1:4]
data_non_comm <- data_non_comm[,1:4]
data_inj <- data_inj[,1:4]

data_cause_lvl2 <- rbind(data_comm,data_non_comm,data_inj)

names(data_cause_lvl2)[names(data_cause_lvl2) == 'cause'] <- 'key'
names(data_lvl3)[names(data_lvl3) == 'Parent.Name'] <- 'key'

final_data <- left_join(data_cause_lvl2,data_lvl3, by='key')


#Ici on peut donc choisir le parent 1 entre 'Communicable, maternal, neonatal, and nutritional diseases' 'Non-communicable diseases' et 'Injuries' 
current_categorie = filter(final_data, Parent.Name == 'Injuries')

#ggplot(current_data , aes(area = val, fill = val, label = key,
                   #subgroup = cause)) +
  #geom_treemap() +
  #geom_treemap_subgroup_border() +
  #geom_treemap_subgroup_text(place = "centre", grow = T, alpha = 0.5, colour =
                               #"black", fontface = "italic", min.size = 0) +
  #geom_treemap_text(colour = "white", place = "topleft", reflow = T)


group <- current_data$key
subgroup <- current_data$cause
val <- current_data$val

data_plot <- data.frame(group,subgroup,val)

# treemap
treemap(data_plot,
        index=c("group","subgroup"),
        vSize="val",
        type="index"
)
