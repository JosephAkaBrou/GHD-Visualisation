library(shiny)
library(shinymaterial)
library(ggiraph)
# library(treemap)
# library(htmlwidgets)
# library(d3treeR)



material_page(
  
  title = "GHD visualisation",

  
  
  #menu 
  material_side_nav(
    br(),
    br(),
    #filtre sexe
    # material_row(
    #   material_column(
    #     p("Sexe"),
    #     offset = 1,
    #     width = 12,
    #     material_checkbox(
    #       input_id = "f",
    #       label = "Femme",
    #       initial_value = FALSE,
    #       color = "#C46E77"
    #     ),
    #     material_checkbox(
    #       input_id = "h",
    #       label = "Homme",
    #       initial_value = FALSE,
    #       color = "#C46E77"
    #     )
    #     )
    # 
    #   
    # ),
    
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
      "Séries temporelles" = "vis1",
      "Treemap"= "vis2"
      
    )
  ),
  
  
  #onglet acceuil
  material_tab_content(
    tab_id = "accueil",
    material_card(
      h5("Projet de visualisation"),
      p(
        "Dans le cadre du cours de Sémiologie graphique de notre Master MIASHS, 
        nous avons été amenés à chercher des données dans le but d'implémenter trois représentation graphique
        (ggplot2) dans une application R Shiny."
      ),
      p("Pour les données, nous avonc choisi le site",tags$a(href ="http://ghdx.healthdata.org/","http://ghdx.healthdata.org/"), "qui propose de récupérer différents types de données de santé par pays."),
      h5("Participation"),
      tags$ul(
      tags$li("Joseph AKA BROU"),
      tags$li("Marwa ELATRACHE"),
      tags$li("Caroline MARTIN"),
      tags$li("Tharshika NAGARATNAM"),
      tags$li("Omar SECK")
      ),
    h5("Github"),
    tags$a(href="https://github.com/JosephAkaBrou/GHD-Visualisation", "Lien Github")

    )
  ),
  material_tab_content(
    tab_id = "carto",
    material_row(
      material_column(
        width = 12,
        material_card(
          h5("choix du graphe:"),
          p("Nous avons décidé de représenter
            le taux de mortalité (nombre de morts en année x / population en année x) 
            sur une année sur une carte car ça permet de visualiser géographiquement 
            le taux de mortalité et le comparer par pays.")
          ),
        material_card(
          h5("Veuillez sélectionner l'année et la cause:"),
          girafeOutput("carto_vis")
        )

        
      )
    )

  ),
  material_tab_content(
    tab_id = "vis1",
    material_row(
      material_column(   
        width = 12,
        material_card(
          h5("choix du graphe:"),
          p("")
          
        ),
        
        material_card(
          width = 10,
          h5("Veuillez sélectionner le pays et la cause:"),
          plotOutput('visu1')
          ))) ),
  
  material_tab_content(
    tab_id = "vis2",
    material_row(
      material_column(
        width = 12,
        material_card(
          h5("choix du graphe:"),
          p("")
          
        ),
        material_card(
          p("Pour une treemap interactive:",tags$a(href="https://josephakabrou.github.io/GHD-Visualisation/?fbclid=IwAR2Z0Cdjqtv9Hm8m4a7caBVP3NJKjHHOTMu4Sp8CRm8U0JY0I9KPMd3_G18",
                 "Appuyez ici!")),
          
          img(src ="treemap.png", width = "600px")
          
        )
        
        
        # material_card(
        #   includeHTML("tree.html")
        #  # d3tree2Output('visu_treemap',
        #  #                width = "400px", height = "400px")
        # )
      )
      
    )
 )
      
    
  
  
  
  
  
  
  
  
  
  
)