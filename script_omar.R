library(tidyverse)

setwd("/users/omarseck/Desktop/GHD-Visualisation/")
data = read.csv2("data3.csv", sep = ',', dec = '.')
summary(data)

str(data)

data$year = as.factor(data$year)

# J'ai fait le filtre par cause d'accident, on pourrait faire aussi par pays, age, etc
df = data %>%filter(cause == 'Neoplasms') %>%
  select(val, year, sex) 


ggplot(df, aes (x = year, y = val, fill = sex)) + 
  geom_bar(stat="identity")
