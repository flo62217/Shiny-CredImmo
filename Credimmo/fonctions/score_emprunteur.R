#' Score les individus sur la capacité de rembourser un emprunt 
#'
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


score_emprunteur<-function(duree_cred,
                           taux_int,
                           taux_ass,
                           montant_proj,
                           montant_apport,
                           rev_emp_1=1,
                           rev_emp_2=0,
                           montant_frais=0){

mensualite<-CalculeMensualite(duree_cred,
                              taux_int,
                              taux_ass,
                              montant_proj,
                              montant_apport,
                              rev_emp_1,
                              rev_emp_2=0,
                              montant_frais=0)
taux_end<-mensualite/(rev_emp_1+rev_emp_2)
taux_end
}