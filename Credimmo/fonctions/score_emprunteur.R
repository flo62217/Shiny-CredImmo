#' Calcul le taux d'endettement de l'emprunteur 
#' On n'autorise pas les valeurs impossible telle que une durée de crédit négative ou nulle
#' ou encore que les autres variables soit négative strictement
#' @param duree_cred numeric, en années
#' @param taux_int numeric, taux annuel 
#' @param taux_ass numeric, taux annuel 
#' @param montant_proj numeric, montant du projet
#' @param montant_apport numeric, montant de l'apport
#' @param rev_emp_1 vecteur de numeric, revenu mensuel net et nombre de mois
#' @param rev_emp_2 vecteur de numeric, revenu mensuel net et nombre de mois, par defaut (0,0)
#' @param montant_frais numeric, montant des frais de dossier et frais bancaires
#'
#' @return le score de la personne ou du foyer qui emprunte
#' Pour le moment la fonction retourne seulement le taux d'endettement
#' @export
#'
#' @examples
#' score_emprunteur(20,0.02,0.02,100000,10000,2000,0,1000)
#' score_emprunteur(0,0,0,0,0,0,0,0)
#' score_emprunteur(0,0,0,-1,0,0,0,0)
#' score_emprunteur(0,0,0,0,-1,0,0,0)
#' score_emprunteur(0,0,0,0,0,-1,0,0)
#' score_emprunteur(0,0,0,0,0,0,-1,0)
#' score_emprunteur(0,0,0,0,0,0,0,-1)


score_emprunteur <- function(duree_cred,
                           taux_int,
                           taux_ass,
                           montant_proj,
                           montant_apport,
                           rev_emp_1=1,
                           rev_emp_2=0,
                           montant_frais=0,
                           age,
                           cigarette,
                           sport,
                           maladie,
                           travail,
                           handicap,
                           marital){
  if(duree_cred<=0 || taux_int<0 || taux_ass<0 || montant_apport<0 || montant_proj<0 ||
     rev_emp_1<0 || rev_emp_2<0 || montant_frais<0){
    print("vérifiez les entrées")
  }#end if
  else{
    mensualite<-CalculeMensualite(duree_cred,
                                  taux_int,
                                  taux_ass,
                                  montant_proj,
                                  montant_apport,
                                  rev_emp_1,
                                  rev_emp_2=0,
                                  montant_frais=0)
    taux_end<-mensualite/(rev_emp_1+rev_emp_2)
    ##sortie
    score_revenu <- min(1/taux_end*as.integer(1/taux_end>3)*10/3,60)
    score_age <- -(age-18)*(age-50/18)*as.integer(18 <= age & age <= 25)*9/70+20*as.integer(25 <= age & age <= 55)+max((-age+75),0)*as.integer(age >= 55)
    score_sport <- -2*as.integer(sport == "Non")+2*as.integer(sport == "Quotidiennement")
    score_maladie <- -5*as.integer(maladie == "Oui")
    score_cigarette <- 5*as.integer(cigarette == "Non")-5*as.integer(cigarette == "Quotidiennement")
    score_handicap <- -5*as.integer(handicap == "Oui")
    score_marital <- 6*as.integer(marital == "Marié/Pacse")
    score_penible <- 7*as.integer(travail == "Faible (Bureau, travail assis)")-5*as.integer(travail == "Fort (Serveur,travail en chantier)")+3*as.integer(travail == "Moyen (Travail debout,)")
    score <- score_revenu+score_age+score_sport+score_maladie+score_cigarette+score_handicap+score_marital+score_penible
    score
    #taux_end
  }# end else
}#end function