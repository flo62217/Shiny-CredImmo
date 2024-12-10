#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
#Package
library(roxygen2)
library(shiny)
library(styler)
#Source
source("fonctions/calcule_mensualite.R", local = TRUE) # Le chemin choisi est par rapport au fichier app.R (est ce qu'on fait un dossier R pour les fonctions ? cf cheatsheet)
source("fonctions/CreerTableauAmortissement.R", local = TRUE)
# Define UI for application that draws a histogram
ui <- fluidPage(
  includeCSS("www/style.css"),
  fluidRow(
    column(
      width = 1,  #Prend 1/12 de la page
      img(src = "images/Logo CUB.png", width = "100px", height = "100px")
    ),
    column(
      width = 11,  #Prend 11/12 restant
      div(
        #Titre du document et titre de l'onglet (windowTitle)
        titlePanel("CUB - Crédit Universitaire Bisontin"),
        style = "display: inline-block; vertical-align: top; margin-left: 10px;"
      )
    )
  ),
    # Cellule pour que l'utilisateur puisse ajouter le montant de son emprunt (valeur du bien)
    fluidRow(column(width = 4,
    numericInput(inputId = "montant_proj", label = "Montant de l'emprunt", value = 0),
    numericInput(inputId = "montant_apport", label = "Montant de l'apport", value = 0)),
    
    
    
    column(width = 4,
      sliderInput("duree_cred", label = "Durée du crédit", min = 5, max = 25, value = 5), # J'ai ajouté les durées légales minimales et maximales d'un crédit immobilier (5-25)
      sliderInput("taux_int", label = "Taux d'intérêt", min = 0, max = 10, value = 2.5, step = .5),
      sliderInput("taux_ass", label = "Taux d'assurance", min = 0, max = 5, value = 0, step = .5)),
    column(width = 4,
           "",
           numericInput(inputId = "rev_emp_1", label = "Revenu de l'emprunteur principal", value = 0))),
    fluidRow(column(width = 12, offset = 3,tableOutput("tableau_amortissement")))
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$tableau_amortissement <- renderTable(CreerTableauAmortissement(input$duree_cred,
                                        input$taux_int/100,
                                        input$taux_ass/100,
                                        input$montant_proj,
                                        input$montant_apport,
                                        input$rev_emp_1,
                                        rev_emp_2=0,
                                        montant_frais=0))
}

# Run the application 
shinyApp(ui = ui, server = server)
