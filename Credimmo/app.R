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
library(shinyalert)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(styler)

#Potentiellement meilleur rendus de tableau 
#Source
source("fonctions/calcule_mensualite.R", local = TRUE) # Le chemin choisi est par rapport au fichier app.R
source("fonctions/CreerTableauAmortissement.R", local = TRUE)
source("fonctions/score_emprunteur.R", local = TRUE)
source("fonctions/CoutTotal.R", local=TRUE)


# Definie l'UI d'affichage
ui <- fluidPage(
  theme = bs_theme(),
  tags$head(
    tags$link(rel="stylesheet", type="text/css", href="style.css"),
  ),
  
  fluidRow(
    
    column(
      
      width = 1,  #Prend 1/12 de la page
      img(src = "images/Logo CUB.png", width = "100px", height = "100px"),
      
    ),#end column logo
    
    column(
      
      width = 10,  #Prend 10/12 de la page
      
      div(
        #Titre du document et titre de l'onglet (windowTitle)
        titlePanel("CUB - Crédit Universitaire Bisontin"),
        style = "display: inline-block; vertical-align: top; margin-left: 10px;"
      )#end div
      
    ),#end column div
    column(width=1,
           bslib::input_dark_mode(),
           bslib::input_switch("lang", "Traduire", FALSE))#end column boutons
  ),#end fluid row en tête
  
  navset_tab(
  
    nav_panel(title = "Accueil",
            fluidRow(
              column(12, align = "center",
                     h2("Collaborateurs : "),
                     h3("Antoine Genin, Florian Bucquet, Lucas Debauche"),
                     h4("Projet pour l'unité de R avancé supervisée par A. de Moliner, réalisé 
                        dans le cadre du master modélisation statistiques de l'Université De Franche Comté.",br(),br()),
                     h5(class = "justified-text","Bienvenue au CUB, nous fournissons à nos clients des solutions de crédit immobilier pour l'achat
              de leurs biens immobiliers.",br()," Vous trouverez sur notre site un simulateur de crédit immobilier et un indicateur
              qui vous permettera de savoir s'il est possible de demander un crédit ou s'il sera refusé
              automatiquement. Si l'indicateur est Vert alors l'emprunt est accepté, si il est rouge il est refusé, enfin si il est orange,il va falloir présenter votre projet aux différents collaborateurs afin de voir si il est vraiment viable.",br(),br()),
                     h5(class = "justified-text","Voici les différentes données demandées :",br(),br(),
                     br(),"- Montant du bien : C'est le prix du bien immobilier",
                     br(),"- Montant de l'apport : C'est la somme d'argent que vous possédez et que vous voulez utiliser pour l'achat.Il sera déduit du prix du bien.",
                     br(),"- Durée du crédit : C'est la durée pendant laquelle vous allez avoir des mensualités à payer.",
                     br(),"- Taux d'intérêt : C'est un pourcentage du reste de votre crédit chaque mois que vous devez payer en plus du remboursement du prêt.",
                     br(),"- Taux d'assurance : C'est un pourcentage du crédit que vous payez chaque mois en plus des intérêts, il permet par exemple selon les contrats de rembourser le crédit en cas de décès de l'emprunteur ou de pouvoir stopper les mensualités en cas licenciement.",
                     br(),"- Revenu: C'est votre revenu mensuel net, les primes et prestations en nature (voiture de fonction, carte de restaurant) ne sont pas prises en compte",
                     br(),"- Montant des frais de dossier: C'est le prix des différents frais qu'engendre l'acquisition d'un bien immobilier, notamment les frais de notaire et frais d'agence. Ce montant peut aller de 5 à 10% du prix du bien en fonction des prestataires")
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
      column(width = 2, wellPanel(
        fluidRow(
          div(
            class = "custom-valuebox",
            valueBoxOutput(outputId = "cout_total", width = 12),
            valueBoxOutput(outputId = "score", width = 12)
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
  
output$score<-renderValueBox({valueBox(value = score_emprunteur(input$duree_cred,
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
                                                 input$mari),
                                       subtitle = "Score emprunteur (/100)",
                                       color = couleur_score(),
                                       width = 12)}
                             )#end rendervalueBox
  
  output$cout_total <- renderValueBox({valueBox(value = CoutTotal(input$duree_cred,
                                                        input$taux_int/100,
                                                        input$taux_ass/100,
                                                        input$montant_proj,
                                                        montant_apport(),
                                                        rev_emp_1(),
                                                        rev_emp_2=rev_emp_2(),
                                                        montant_frais()),
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
    score_test <- score_emprunteur(input$duree_cred,
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
                                  input$mari)
    if(is.character(score_test)){
      "red"
    }
    else if (score_test>60)
      {"green"}
    else if (score_test<30)
      {"red"}
    else
      {"yellow"}
    })
  output$scoreBox <- renderValueBox({
    
    score_test <- score_emprunteur(input$duree_cred,
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
                                   input$mari)
    if(is.character(score_test)){
      icone = icon("remove-sign", lib = "glyphicon")
    }
    else if (score_test>60)
    {icone = icon("ok-sign", lib = "glyphicon")}
    else if (score_test<30)
    {icone = icon("remove-sign", lib = "glyphicon")}
    else
    {icone = icon("question-sign", lib = "glyphicon")}
    valueBox(
      value = score_test,subtitle = "Score emprunteur (/100)",color = couleur_score(), icon = icone)
  })
  observeEvent(input$rev_emp_1,
          {if(is.na(input$rev_emp_1)){}
          else if (input$rev_emp_1 < 0){
            shinyalert(title="Erreur de revenu", text = "Le revenu de l'emprunteur principal ne peut être négatif", type="error", animation = TRUE)}})
  observeEvent(input$rev_emp_2,
          {if(is.na(input$rev_emp_2)){}
          else if (input$rev_emp_2 < 0){
            shinyalert(title="Erreur de revenu", text = "Le revenu du second emprunteur ne peut être négatif", type="error", animation = TRUE)}})
  observeEvent(input$lang,
               {if(input$lang){
               shinyalert(title="Fonctionnalité indisponible", text = "Cette fonctionnalité n'est pas disponible", type="error", animation = TRUE)
                update_switch("lang", value=FALSE)}})
}#end server

# Run the application 
shinyApp(ui = ui, server = server)

