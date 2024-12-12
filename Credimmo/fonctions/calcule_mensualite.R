#' Calcule les mensualitées
#' On n'autorise pas les valeurs impossible telle que une durée de crédit négative ou nulle
#' ou encore que les autres variables soit négative strictement
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
#' @return mensualite, les mensualite de l'emprunteur
#' @export
#'
#' @examples
#' CalculMensualite(0,0,0,0,0,0,0,0)
#' CalculeMensualite(0,0,0,-1,0,0,0,0)
#' CalculeMensualite(0,0,0,0,-1,0,0,0)
#' CalculeMensualite(0,0,0,0,0,-1,0,0)
#' CalculeMensualite(0,0,0,0,0,0,-1,0)
#' CalculeMensualite(0,0,0,0,0,0,0,-1)
#' CalculeMensualite(20,0.02,0.02,100000,10000,2000,0,1000)
CalculeMensualite <- function(duree_cred,
                          taux_int,
                          taux_ass,
                          montant_proj,
                          montant_apport,
                          rev_emp_1,
                          rev_emp_2=0,
                          montant_frais=0){
  ##corps de la fonction
  if(duree_cred<=0 || taux_int<0 || taux_ass<0 || montant_apport<0 || montant_proj<0 ||
     rev_emp_1<0 || rev_emp_2<0 || montant_frais<0){
    print("vérifiez les entrées")
  }
  else{
    nb_mensualite <- duree_cred*12
    montant_emprunt <- montant_proj - montant_apport
    cout_assurance <- taux_ass*montant_emprunt
    mensualite_assurance <- cout_assurance/nb_mensualite
    if (taux_int==0){
      mensualite_emprunt <- montant_emprunt/nb_mensualite
    }
    else{  mensualite_emprunt <- montant_emprunt*(taux_int/12)/(1-(1+taux_int/12)^(-nb_mensualite))}
    mensualite <- mensualite_assurance + mensualite_emprunt
    ##outputs
    mensualite
  }#end else
}#end function