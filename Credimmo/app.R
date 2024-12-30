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
#Potentiellement meilleur rendus de tableau 
#Source
source("fonctions/calcule_mensualite.R", local = TRUE) # Le chemin choisi est par rapport au fichier app.R
source("fonctions/CreerTableauAmortissement.R", local = TRUE)
source("fonctions/score_emprunteur.R", local = TRUE)
source("fonctions/CoutTotal.R", local=TRUE)


# Definie l'UI d'affichage
ui <- fluidPage(
  
  includeCSS("www/style.css"),
  
  fluidRow(
    
    column(
      
      width = 1,  #Prend 1/12 de la page
      img(src = "images/Logo CUB.png", width = "100px", height = "100px")
      
    ),#end column
    
    column(
      
      width = 11,  #Prend 11/12 restant
      
      div(
        #Titre du document et titre de l'onglet (windowTitle)
        titlePanel("CUB - Crédit Universitaire Bisontin"),
        style = "display: inline-block; vertical-align: top; margin-left: 10px;"
      )#end div
      
    )#end column
    
  ),#end fluid row
  
  navset_tab(
  
    nav_panel(title = "Accueil",
              
            p("Bienvenue au CUB, nous fournissons à nos clients des solutions de crédit immobilier pour l'achat
              de leurs biens immobiliers."),
            
            p("Vous trouverez sur notre site un simulateur de crédit immobilier et, prochainement, un indicateur
              qui vous permettera de savoir s'il est possible de demander un crédit ou s'il sera refusé
              automatiquement.")
            
            ),#end navpanel
    
  nav_panel(title = "Simulateur de crédit immobilier",
    # Cellule pour que l'utilisateur puisse ajouter le montant de son emprunt
    
    fluidRow(
      column(width = 2,wellPanel(
             
            numericInput(inputId = "montant_proj", label = "Montant du bien", value = 0),
    
            numericInput(inputId = "montant_apport", label = "Montant de l'apport", value = 0),
    
            sliderInput("duree_cred", label = "Durée du crédit", min = 5, max = 25, value = 5),
    
            sliderInput("taux_int", label = "Taux d'intérêt", min = 0, max = 10, value = 2.5, step = .5),
    
            sliderInput("taux_ass", label = "Taux d'assurance", min = 0, max = 5, value = 0, step = .5),
      
            numericInput(inputId = "rev_emp_1", label = "Revenu de l'emprunteur principal", value = 0),
    
            checkboxInput(inputId = "is_emp_2", label = "Présence d'emprunteur secondaire", value = FALSE),
    
             conditionalPanel(condition = "input.is_emp_2",
                     
                              numericInput(inputId = "rev_emp_2",
                                  
                                  label = "Revenu de l'emprunteur secondaire",
                                  value = 0)),#end conditional panel
    
    numericInput(inputId = "montant_frais", label = "Montant des Frais de dossier", value = 0),
    
    downloadButton(outputId = "download_table", "Télécharger le tableau"),
    
    #verbatimTextOutput(outputId = "score"),
    
    verbatimTextOutput(outputId = "cout_total")
    
    )#endWellPanel
    )#end column
    ,column(width = 10,dataTableOutput("tableau_amortissement"))
    )#EndFluidRow
    
  ),# end navpanel
  nav_panel(title = "Graphique",
            fluidRow(
              column(width = 12,
                     plotOutput('myplot')
              )#End column
              )#End FluidRow Panneau
            )# End panneau graphique
  
  
  ),#end navsetunderline
  
id = "navigator",
fluid = TRUE,
bg = "#D3D6CF",
widths = 20)#end ui

# Define server logic required to draw a histogram
server <- function(input, output) {
  rev_emp_2 <- reactive(
    {if(input$is_emp_2)
    {
    input$rev_emp_2
  }#end if
    else{
    0
  }#end else
    }#end ifelse
  )#end reactive
 
  output$tableau_amortissement <- renderDataTable({CreerTableauAmortissement(input$duree_cred,
                                        input$taux_int/100,
                                        input$taux_ass/100,
                                        input$montant_proj,
                                        input$montant_apport,
                                        input$rev_emp_1,
                                        rev_emp_2=rev_emp_2(),
                                        input$montant_frais)
                                        })#end rendertable
  
  # #output$score<-renderPrint(expr =score_emprunteur(input$duree_cred,
  #                                                   input$taux_int/100,
  #                                                   input$taux_ass/100,
  #                                                   input$montant_proj,
  #                                                   input$montant_apport,
  #                                                   input$rev_emp_1,
  #                                                   rev_emp_2=rev_emp_2(),
  #                                                   input$montant_frais),width = 10)#end render print
  output$cout_total <- renderPrint(expr = CoutTotal(input$duree_cred,
                                                                                           input$taux_int/100,
                                                                                           input$taux_ass/100,
                                                                                           input$montant_proj,
                                                                                           input$montant_apport,
                                                                                           input$rev_emp_1,
                                                                                           rev_emp_2=rev_emp_2(),
                                                                                           input$montant_frais)
                                   )#end renderprint
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
  )#end download_table
  
  output$myplot <-renderPlot(plot(output$tableau_amortissement$capital_restant_du))

}#end server

# Run the application 
shinyApp(ui = ui, server = server)
