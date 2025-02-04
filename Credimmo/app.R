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
library(dplyr)
library(ggplot2)
library(glue)
library(htmltools)
library(roxygen2)
library(shiny)
library(styler)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)

#Potentiellement meilleur rendus de tableau 
#Source
source("fonctions/calcule_mensualite.R", local = TRUE) # Le chemin choisi est par rapport au fichier app.R
source("fonctions/CreerTableauAmortissement.R", local = TRUE)
source("fonctions/score_emprunteur.R", local = TRUE)
source("fonctions/CoutTotal.R", local=TRUE)


# Definie l'UI d'affichage
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
        .custom-valuebox .info-box-content {
          font-size: 14px; /* Taille du texte global */
        }
        .custom-valuebox .info-box-text {
          color: #000000; /* Couleur du subtitle */
          font-size: 16px; /* Taille du subtitle */
          font-weight: bold; /* Met le subtitle en gras */
        }
        .custom-valuebox .info-box-number {
          color: #000000; /* Couleur de la valeur */
          font-size: 24px; /* Taille de la valeur */
          font-weight: bold;
        }
      "))
  ),
  includeCSS("www/style.css"),
  
  fluidRow(
    
    column(
      
      width = 1,  #Prend 1/12 de la page
      img(src = "images/Logo CUB.png", width = "100px", height = "100px")
      
    ),#end column logo
    
    column(
      
      width = 11,  #Prend 11/12 restant
      
      div(
        #Titre du document et titre de l'onglet (windowTitle)
        titlePanel("CUB - Crédit Universitaire Bisontin"),
        style = "display: inline-block; vertical-align: top; margin-left: 10px;"
      )#end div
      
    )#end column div
    
  ),#end fluid row en tête
  
  navset_tab(
  
    nav_panel(title = "Accueil",
            fluidRow(
              column(12, align = "center",
                     h2("Collaborateurs : "),
                     h3("Antoine Genin, Florian Bucquet, Lucas Debauche"),
                     h4("Projet pour l'unité de R avancé supervisée par A. de Moliner, réalisé 
                        dans le cadre du master modélisation statistiques de l'Université De Franche Comté."),
                     h5("Bienvenue au CUB, nous fournissons à nos clients des solutions de crédit immobilier pour l'achat
              de leurs biens immobiliers.",br()," Vous trouverez sur notre site un simulateur de crédit immobilier et un indicateur
              qui vous permettera de savoir s'il est possible de demander un crédit ou s'il sera refusé
              automatiquement : le score emprunteur.")
                     )#end column
              )#end fluidrow
            
            ),#end navpanel Accueil
  nav_panel(title  = "Questionnaire",
            p("Veuillez saisir les informations concernant l'emprunteur principal"),
            fluidRow(
              column( width = 10,
                      div(class = "slider-custom",
                          sliderInput("age", label = "Age", min = 18, max = 65, value = 35)),
                      
                      radioGroupButtons("cig","Êtes vous fumeur ?",choices=c("Quotidiennement","Occasionnellement","Non"), status = "radio"),
                      
                      radioGroupButtons("sport","Faites vous du sport?",choices=c("Quotidiennement","Occasionnellement","Non"), status = "radio"),
                      
                      radioGroupButtons("mal","Avez vous des maladies chroniques ?",choices=c("Oui","Non"), status = "radio"),
                      
                      radioGroupButtons("trav","Quel est votre facteur de pénibilité au travail",choices=c("Fort (Serveur,travail en chantier)","Moyen (Travail debout,)","Faible (Bureau, travail assis)"), status = "radio"),
                      
                      radioGroupButtons("hand","Avez vous un handicap ?",choices=c("Oui","Non"), status = "radio"),
                      
                      radioGroupButtons("mari","Situation maritale",choices=c("Marié/Pacse","Célibataire"), status = "radio")
              ),#end column
            )#end Row questionaire
            ),
    
  nav_panel(title = "Simulateur de crédit immobilier",
    fluidRow(
      column(width = 2,wellPanel(
        fluidRow(
          div(
            class = "custom-valuebox",
            valueBoxOutput(outputId = "cout_total")),
          div(
            class = "custom-valuebox",
            valueBoxOutput(outputId = "score")
            )
          ),
             
            numericInput(inputId = "montant_proj", label = "Montant du bien", value = 150000),
    
            numericInput(inputId = "montant_apport", label = "Montant de l'apport", value = 0),
    
            sliderInput("duree_cred", label = "Durée du crédit", min = 5, max = 25, value = 5),
    
            sliderInput("taux_int", label = "Taux d'intérêt", min = 0, max = 10, value = 2.5, step = .5),
    
            sliderInput("taux_ass", label = "Taux d'assurance", min = 0, max = 5, value = 0, step = .5),
      
            numericInput(inputId = "rev_emp_1", label = "Revenu de l'emprunteur principal", value = 0, min = 0),
    
            checkboxInput(inputId = "is_emp_2", label = "Présence d'emprunteur secondaire", value = FALSE),
    
             conditionalPanel(condition = "input.is_emp_2",
                     
                              numericInput(inputId = "rev_emp_2",
                                  
                                  label = "Revenu de l'emprunteur secondaire",
                                  value = 0)),#end conditional panel
    
    numericInput(inputId = "montant_frais", label = "Montant des Frais de dossier", value = 0),
    
    downloadButton(outputId = "download_table", "Télécharger le tableau"),
    )#endWellPanel
    )#end column Input
    ,column(width = 10,dataTableOutput("tableau_amortissement")
            )#End column Tableau amortissement
    )#EndFluidRow
  ),# end navpanel Simulateur 
  nav_panel(title = "Graphique",
            dashboardPage(skin = "black",
              dashboardHeader(title = "Votre emprunt"),
              dashboardSidebar(),
              dashboardBody(
              fluidRow(
                column(width = 6,plotOutput('plot_interet')),#End column
                column(width = 6,plotOutput('plot_restant')),
                valueBoxOutput("scoreBox")
              )#End FluidRow Panneau
            )#End dashboardBody
          )# End dashboardPage
  )#End navpanel graphique
  
  
  ),#end navsetunderline
  
id = "navigator",
fluid = TRUE,
bg = "#D3D6CF",
widths = 20

)#end ui

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
  
  rev_emp_1 <- reactive(
    {if(is.na(input$rev_emp_1) || input$rev_emp_1 == ""){
      0
      }
      else{
        input$rev_emp_1
      }}#end bloc dans reactive
  )#end reactive
  
  montant_apport <- reactive(
    {if(is.na(input$montant_apport) || input$montant_apport == ""){
      0
    }
      else{
        input$montant_apport
      }}#end bloc dans reactive
  )#end reactive
  
  montant_frais <- reactive(
    {if(is.na(input$montant_frais) || input$montant_frais == ""){
      0
    }
      else{
        input$montant_frais
      }}#end bloc dans reactive
  )#end reactive

 
  output$tableau_amortissement <- renderDataTable({CreerTableauAmortissement(input$duree_cred,
                                        input$taux_int/100,
                                        input$taux_ass/100,
                                        input$montant_proj,
                                        montant_apport(),
                                        rev_emp_1(),
                                        rev_emp_2=rev_emp_2(),
                                        montant_frais())
                                        })#end rendertable
  
output$score<-renderValueBox({valueBox(value = round(score_emprunteur(input$duree_cred,
                                                 input$taux_int/100,
                                                 input$taux_ass/100,
                                                 input$montant_proj,
                                                 montant_apport(),
                                                 rev_emp_1(),
                                                 rev_emp_2=rev_emp_2(),
                                                 montant_frais(),
                                                 input$age,
                                                 input$cig,
                                                 input$sport,
                                                 input$mal,
                                                 input$trav,
                                                 input$hand,
                                                 input$mari),2),
                                       subtitle = "Score emprunteur (/100)",
                                       color = couleur_score(),
                                       width = 12)}
                             )#end rendervalueBox
  
  output$cout_total <- renderValueBox({valueBox(value = round(CoutTotal(input$duree_cred,
                                                        input$taux_int/100,
                                                        input$taux_ass/100,
                                                        input$montant_proj,
                                                        montant_apport(),
                                                        rev_emp_1(),
                                                        rev_emp_2=rev_emp_2(),
                                                        montant_frais()),0),
                                                subtitle = "Coût total du crédit",
                                                color = "red",
                                                width = 12)}
                                   )#end renderValueBox
  

  output$download_table <- downloadHandler(filename = "tableau_amortissement.csv",
    content = function(file) {
      write.csv(CreerTableauAmortissement(input$duree_cred,
                                          input$taux_int/100,
                                          input$taux_ass/100,
                                          input$montant_proj,
                                          montant_apport(),
                                          rev_emp_1(),
                                          rev_emp_2=rev_emp_2(),
                                          montant_frais()), file, row.names = FALSE)
    }
  )#end download_table
  
  output$plot_restant <-renderPlot({
    dt<-CreerTableauAmortissement(input$duree_cred,
                                  input$taux_int/100,
                                  input$taux_ass/100,
                                  input$montant_proj,
                                  montant_apport(),
                                  rev_emp_1(),
                                  rev_emp_2=rev_emp_2(),
                                  montant_frais())
    temps<-dt %>% select(`Mois de référence`)
    rest_avec<-dt %>% select(`Restant dû (Avec intérêt)`)
    rest_sans<-dt %>% select(`Restant dû (Sans intérêt)`)
    ggplot(data=dt,aes(x=`Mois de référence`,y=`Restant dû (Sans intérêt)`))+
      geom_line(col="black") +
      geom_point(col="black")+
      labs(x = "Temps", y = "Montant", title = "Evolution du remboursement au fil du temps")
    })#end output plot_restant

  output$plot_interet <-renderPlot({
    dt<-CreerTableauAmortissement(input$duree_cred,
                                  input$taux_int/100,
                                  input$taux_ass/100,
                                  input$montant_proj,
                                  montant_apport(),
                                  rev_emp_1(),
                                  rev_emp_2=rev_emp_2(),
                                  input$montant_frais)
    tot<-dt %>%select(`Intérêt payés`) %>% sum()
    temps <-dt %>% select(`Mois de référence`)
    if(tot!=0){
      cumsum_int<-dt %>%select(`Intérêt payés`) %>% apply(FUN = function(x) cumsum(x)/tot,MARGIN=2) %>% data.frame()
      print(cumsum_int)
      ggplot(data = cumsum_int, aes(x = seq_along(`Intérêt.payés`), y = `Intérêt.payés`)) +
        geom_line(col="black") +
        geom_point(col="black")+
        labs(x = "Temps", y = "Montant", title = "Evolution du pourcentage d'intérêt payés en fonction du temps")
    }#End if
      })# end output plot_interet
  couleur_score <- reactive({
    score_test <- round(score_emprunteur(input$duree_cred,
                                  input$taux_int/100,
                                  input$taux_ass/100,
                                  input$montant_proj,
                                  montant_apport(),
                                  rev_emp_1(),
                                  rev_emp_2=rev_emp_2(),
                                  montant_frais(),
                                  input$age,
                                  input$cig,
                                  input$sport,
                                  input$mal,
                                  input$trav,
                                  input$hand,
                                  input$mari),2)
    if (score_test>60)
      {"green"}
    else if (score_test<30)
      {"red"}
    else
      {"yellow"}
    })
  output$scoreBox <- renderValueBox({
    valueBox(
      value = round(score_emprunteur(input$duree_cred,
                                     input$taux_int/100,
                                     input$taux_ass/100,
                                     input$montant_proj,
                                     montant_apport(),
                                     rev_emp_1(),
                                     rev_emp_2=rev_emp_2(),
                                     montant_frais(),
                                     input$age,
                                     input$cig,
                                     input$sport,
                                     input$mal,
                                     input$trav,
                                     input$hand,
                                     input$mari),2),subtitle = "Score emprunteur (/100)",color = couleur_score(), icon = icon("thumbs-up", lib = "glyphicon"))
  })

}#end server

# Run the application 
shinyApp(ui = ui, server = server)

