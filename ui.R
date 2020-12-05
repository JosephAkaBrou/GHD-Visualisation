library(shiny)
library(shinymaterial)
library(leaflet)
library(plotly)
library(ggiraph)




material_page(
  
  title = "GHD visualisation",

  
  
  #menu 
  material_side_nav(
    br(),
    br(),
    #filtre sexe
    material_row(
      material_column(
        p("Sexe"),
        offset = 1,
        width = 12,
        material_checkbox(
          input_id = "f",
          label = "Femme",
          initial_value = FALSE,
          color = "#C46E77"
        ),
        material_checkbox(
          input_id = "h",
          label = "Homme",
          initial_value = FALSE,
          color = "#C46E77"
        )
        )

      
    ),
    
    #filter année
    material_row(
      material_column(
        p("Année"),
        offset = 1,
        material_slider(input_id = "id_an",
                        label = "",
                        min_value = 2010,
                        max_value = 2019,
                        step_size = 1,
                        initial_value = 2016,
                        color = "#C46E77")
        
      )
    ),
    
    #filter pays, à générer automatiquement
    material_row(
      color = "#C46E77",
      material_column(
        width = 10,
        p("Pays"),
        offset = 1,
        color = "#C46E77",
        material_dropdown(input_id = "id_pays",
                              label = "",
                              choices = c(),
                              selected = "",
                              color = "#C46E77")
                             
      )
    ),
    #filter cause, à générer automatiquement
    material_row(
      color = "#C46E77",
      material_column(
        width = 10,
        p("Causes"),
        offset = 1,
        color = "#C46E77",
        material_dropdown(input_id = "id_cause",
                          label = "",
                          choices = c(),
                          selected = "",
                          color = "#C46E77")
        
      )
    )
    
    
    
    
    
  ),
  
  #onglet
  material_tabs(
    tabs = c(
      "Accueil" = "accueil",
      "Cartographie" = "carto",
      "Visu1" = "vis1",
      "Visu2"= "vis2"
      
    )
  ),
  
  
  #onglet acceuil
  material_tab_content(
    tab_id = "accueil",
    material_card(
      
      h5("Membre du groupe:"),
      tags$ul(
      tags$li("Joseph AKA BROU"),
      tags$li("Marwa ELATRACHE"),
      tags$li("Caroline MARTIN"),
      tags$li("Tharshika NAGARATNAM"),
      tags$li("Omar SECK")
      ),
      
      
      h5("Choix des graphes")
      
      

    )
  ),
  material_tab_content(
    tab_id = "carto",
    material_card(
      girafeOutput("carto_vis")
    )
  ),
  material_tab_content(
    tab_id = "vis1",
    material_row(
      material_column(   
        width = 12,
        material_card(
          width = 10,
          plotlyOutput('visu1')
      )
        
        
      )
    )
 
  )
  
  
  
  
  
  
  
  
)