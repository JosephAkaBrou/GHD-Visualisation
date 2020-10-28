library(ggplot2)
library(dplyr)
library(tibble)
library(scales)

df <- read.csv('data3.csv')

df_fr <- df %>% filter(location == "France")
df_fr_cardio_40_44 <- df_fr %>% filter(cause == "Cardiovascular diseases")
df_fr_cardio_40_44 <- df_fr_cardio %>% filter(age == "40 to 44")
df_fr_cardio_40_44 <- rowid_to_column(df_fr_cardio_40_44, "ID")
df_fr_cardio_40_44 <- arrange(df_fr_cardio_40_44,val)



empty_bar <- 2
to_add <- data.frame( matrix(NA, empty_bar*nlevels(df_fr_cardio_40_44$sex), ncol(df_fr_cardio_40_44)) )
colnames(to_add) <- colnames(df_fr_cardio_40_44)
to_add$sex <- rep(levels(df_fr_cardio_40_44$sex), each=empty_bar)
df_fr_cardio_40_44 <- rbind(df_fr_cardio_40_44, to_add)
df_fr_cardio_40_44 <- df_fr_cardio_40_44 %>% arrange(sex)
df_fr_cardio_40_44$ID<- seq(1, nrow(df_fr_cardio_40_44))



label_data <- df_fr_cardio_40_44

number_of_bar <- nrow(label_data)
angle <-  90 - 360 * (label_data$ID-0.5) /number_of_bar 

label_data$hjust<-ifelse( angle < -90, 1, 0)

label_data$angle<-ifelse(angle < -90, angle+180, angle)

p <- ggplot(df_fr_cardio_40_44, aes(x=as.factor(ID), y=val)) +
  geom_bar(stat="identity", fill=alpha("skyblue", 0.7)) +
  ylim(-1000,1200) +
  theme_minimal() +
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    plot.margin = unit(rep(-1,4), "cm")      # Adjust the margin to make in sort labels are not truncated!
  ) +
  coord_polar(start = 0) +
  
  # Add the labels, using the label_data dataframe that we have created before
  geom_text(data=label_data, aes(x=ID, y=val+10, label=paste(sex,age,year), hjust=hjust), color="black", fontface="bold",alpha=0.6, size=2.5, angle= label_data$angle, inherit.aes = FALSE ) 

p

