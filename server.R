library(shiny)
library(shinymaterial)
source("carto.R")
library(leaflet)
library(plotly)
library(ggplot2)
library(hrbrthemes)
library(dplyr)
library(ggforce)
library(ggiraph)






shinyServer(function(session,input, output) {
  #df = read.csv('./data3.csv')
  data3 = read.csv("data3.csv", sep = ",")
  liste_pays = unique(data3$location)
  liste_causes = unique(data3$cause)
  
  update_material_dropdown(session,
                           input_id = "id_pays",
                           choices =  liste_pays,
                           value = liste_pays[1])
  
  update_material_dropdown(session,
                           input_id = "id_cause",
                           choices =  liste_causes,
                           value = liste_causes[17])
  
  
  

 
  
 
  
  output$carto_vis <- renderGirafe({
    
    df = data3[data3$cause == input$id_cause & data3$year == input$id_an,]
    #df = data3[data3$cause == "Road injuries" & data3$year =="2017",]
    df_select = df[,c("location", "sex", "val")]
    
    df_t = dcast(df_select, location ~ sex, fun = sum)
    df_t$total = df_t$Female + df_t$Male
    df_t$taux_female = paste(round((df_t$Female / df_t$total)*100,0), "%")
    df_t$taux_male = paste(round((df_t$Male / df_t$total)*100,0), "%")
    df_t$Country = df_t$location
    
    # Jointure
    df_final = left_join(df_geo_pop,df_t, by = c("admin"="location"))
    
   
    
    #colnames(df_final) = paste0("col_",colnames(df_final))
    
   # nom_col = paste0("col_", input$id_an)
    
    
    
    # Carte
    gg <- ggplot(df_final) +
      geom_sf_interactive(mapping = aes(fill = (total/(eval(parse(text = paste0( "`", input$id_an, "`")))))*100, 
                                        tooltip = paste("Pays : ", 
                                                        admin,"<br/>", 
                                                        "Taux de mortalité : ", 
                                                        paste(round((total/(eval(parse(text = paste0( "`", input$id_an, "`")))))*100,2), " %"), "<br/>",
                                                        "Nombre de morts : ", 
                                                        round(total,0), "<br/>",
                                                        "Taux de morts 'Female' : ", 
                                                        taux_female, "<br/>",
                                                        "Taux de morts 'Male' : ", 
                                                        taux_male, "<br/>"), 
                                                        data_id =admin))+
      scale_fill_gradient2(name = "Taux de mortalité (en %)",mid = "lightyellow", high = "red", 
                           na.value="lightgrey",guide = "colourbar")+
     ggtitle(paste("Taux de mortalité en ", input$id_an, "par", input$id_cause))+
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
    
     girafe(ggobj = gg) %>%
      girafe_options(opts_tooltip(opacity = .8),
                     opts_zoom(min = .5, max = 4),
                     opts_hover(css = "fill:white;stroke:orange;r:7pt;") )
      
      
      
   
  })
  
  
  
  output$visu1 <- renderPlot({
    
    # Ici j'ai cr?er les vecteurs de valeurs qui permetent de changer le visuel ####
    data = data3
    sex = as.character(unique(data$sex))
    causes = as.character(unique(data$cause))
    location = as.character(unique(data$location))
    data$year = as.factor(data$year)
    year = unique(data$year)
    age = as.integer(unique(data$age))
    
    # La ici je cr?er les 3 variables qu'on peut faire varier.####
    
    # Pour sex il y a que deux valeurs possibles ####
    # Pour la cause, il y a 20 valeurs possibles ####
    # Et pour la Country 45 valeurs ####
    #sex_value = sex[2] # Choisi un nombre entre 1 et 2 
    cause_value = input$id_cause # Choisi un nombre entre 1 et 20
    location_value = input$id_pays# Choisi un nombre entre 1 et 45 
    
    
    # L? ici on fait un filtre avec kes 3 variables au dessus. En situation r?elle, il faut une liste qui permet de choisir ? l'utilisateur
    # Quelles valeurs de sex, cause et Country il veut voir. Pour l'exemple j'ai juste rendu possible la s?lection al?atoire juste haut. 
    
    filtered_df = data[(data$cause == cause_value) & (data$location == location_value),
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
    agg_full$Country = "Europe"
    agg_full =  agg_full[,c('year', 'sex', 'Country', 'val', 'upper', 'lower')]
    
    
    # Ici je merge les données
    d <- rbind(agg, agg_full)
    text_pos_men = mean(subset(subset(d, Country=="Europe"), sex=="Men")[,"val"])
    text_pos_women = mean(subset(subset(d, Country=="Europe"), sex=="Women")[,"val"])
    list_des_pays = paste(location_value, collapse = ", ")
    ann_text_men <- data.frame(year = 2015, val = text_pos_men+10,lab = "Text",
                               sex = factor("Men",levels = c("Men","Women")))
    ann_text_women <- data.frame(year = 2015, val = text_pos_women+10,lab = "Text",
                                 sex = factor("Women",levels = c("Men","Women")))
    
    p <- ggplot(data = d, mapping = aes(x = as.factor(year), y = val, group=Country)) +
      geom_mark_ellipse(aes(fill = Country, 
                            label = Country), 
                        expand = 0.005,
                        alpha = 0.1,
                        size = 0.1) +
      theme_ipsum() +
      geom_ribbon(aes(ymin = lower, ymax = upper), fill = "grey70", alpha = 0.3) +
      geom_line(color="black") +
      geom_line(data=subset(d, Country=="Europe"), aes(x=year, y=val, group="Europe"), linetype=2, color="red") +
      geom_point(shape=21, color="grey", fill="#69b3a2", size=3) +
      facet_wrap( ~ sex, ncol=2) +
      ggtitle(paste("Evolution des morts de", cause_value,"en ", list_des_pays)) +
      geom_text(data = ann_text_men, aes(label = "European mean for Men", group=1)) + 
      geom_text(data = ann_text_women, aes(label = "European mean for Women", group=1)) 
    
    p
    
    
    
    
    
    
  })
  
  
  
  
})
