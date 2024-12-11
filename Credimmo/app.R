#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
#Package
library(bslib)
library(htmltools)
library(roxygen2)
library(shiny)
library(styler)
library(dplyr)
#Source
source("fonctions/calcule_mensualite.R", local = TRUE) # Le chemin choisi est par rapport au fichier app.R (est ce qu'on fait un dossier R pour les fonctions ? cf cheatsheet)
source("fonctions/CreerTableauAmortissement.R", local = TRUE)
source("fonctions/score_emprunteur.R", local = TRUE)
source("fonctions/CoutTotal.R", local=TRUE)

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
  navset_underline(
  nav_panel(title = "Accueil",
            p("Bienvenue au CUB, nous fournissons à nos clients des solutions de crédit immobilier pour l'achat de leurs biens immobilier."),
            p("Vous trouverez sur notre site un simulateur de crédit immobilier et, prochainement, un indicateur qui vous permettera de savoir s'il est possible de demander un crédit ou s'il sera refusé automatiquement.")),
  nav_panel(title = "Simulateur de crédit immobilier",
    # Cellule pour que l'utilisateur puisse ajouter le montant de son emprunt (valeur du bien)
    fluidRow(column(width = 4,
    numericInput(inputId = "montant_proj", label = "Montant du bien", value = 0),
    numericInput(inputId = "montant_apport", label = "Montant de l'apport", value = 0)),
    
    
    
    column(width = 4,
      sliderInput("duree_cred", label = "Durée du crédit", min = 5, max = 25, value = 5), # J'ai ajouté les durées légales minimales et maximales d'un crédit immobilier (5-25)
      sliderInput("taux_int", label = "Taux d'intérêt", min = 0, max = 10, value = 2.5, step = .5),
      sliderInput("taux_ass", label = "Taux d'assurance", min = 0, max = 5, value = 0, step = .5)),
    column(width = 4,
           "",
           numericInput(inputId = "rev_emp_1", label = "Revenu de l'emprunteur principal", value = 0),
           checkboxInput(inputId = "is_emp_2", label = "Présence d'emprunteur secondaire", value = FALSE),
           conditionalPanel(condition = "input.is_emp_2",
                            numericInput(inputId = "rev_emp_2", label = "Revenu de l'emprunteur secondaire", value = 0)),
           numericInput(inputId = "montant_frais", label = "Montant des Frais de dossier", value = 0),
           downloadButton(outputId = "download_table", "Télécharger le tableau"),
           verbatimTextOutput(outputId = "score"),
           verbatimTextOutput(outputId = "cout_total"))),
    fluidRow(column(width = 12, offset = 3,tableOutput("tableau_amortissement")))
    
  )),
id = "navigator",
fluid = TRUE,
bg = "#D3D6CF",
widths = 3)

# Define server logic required to draw a histogram
server <- function(input, output) {
  rev_emp_2 <- reactive({if(input$is_emp_2){
    input$rev_emp_2
  }else{
    0
  }})
 
  output$tableau_amortissement <- renderTable(CreerTableauAmortissement(input$duree_cred,
                                        input$taux_int/100,
                                        input$taux_ass/100,
                                        input$montant_proj,
                                        input$montant_apport,
                                        input$rev_emp_1,
                                        rev_emp_2=rev_emp_2(),
                                        input$montant_frais))
  
  output$score<-renderPrint(expr = paste("Le taux d'endettement est de :",score_emprunteur(input$duree_cred,
                                                    input$taux_int/100,
                                                    input$taux_ass/100,
                                                    input$montant_proj,
                                                    input$montant_apport,
                                                    input$rev_emp_1,
                                                    rev_emp_2=rev_emp_2(),
                                                    input$montant_frais),""))
  output$cout_total <- renderPrint(expr = paste("Le cout total du prêt est de :",CoutTotal(input$duree_cred,
                                                                                           input$taux_int/100,
                                                                                           input$taux_ass/100,
                                                                                           input$montant_proj,
                                                                                           input$montant_apport,
                                                                                           input$rev_emp_1,
                                                                                           rev_emp_2=rev_emp_2(),
                                                                                           input$montant_frais),""))
  output$download_table <- downloadHandler(filename = "tableau_amortissement.csv",
    content = function(file) {
      write.csv(CreerTableauAmortissement(input$duree_cred,
                                          input$taux_int/100,
                                          input$taux_ass/100,
                                          input$montant_proj,
                                          input$montant_apport,
                                          input$rev_emp_1,
                                          rev_emp_2=rev_emp_2(),
                                          input$montant_frais), file, row.names = FALSE)
    }
  )

}

# Run the application 
shinyApp(ui = ui, server = server)
