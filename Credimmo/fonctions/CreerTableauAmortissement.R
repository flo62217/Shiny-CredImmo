#' Fonction qui créer le tableau d'amortissement
#'
#' @param duree_cred 
#' @param taux_int 
#' @param taux_ass 
#' @param montant_proj 
#' @param montant_apport 
#' @param rev_emp_1 
#' @param rev_emp_2 
#' @param montant_frais 
#'
#' @return
#' @export
#'
#' @examples
#' 

CreerTableauAmortissement<- function(duree_cred,
                                     taux_int,
                                     taux_ass,
                                     montant_proj,
                                     montant_apport,
                                     rev_emp_1,
                                     rev_emp_2=0,
                                     montant_frais=0){
  ##corps
  nb_mois <- duree_cred*12
  montant_emprunt <- montant_proj - montant_apport
  mois <- seq(1,nb_mois)
  ones <- rep(1,nb_mois)
  assurance <- rep(taux_ass*montant_emprunt,nb_mois)/nb_mois
  mensualite <- rep(CalculeMensualite(duree_cred,
                                    taux_int,
                                    taux_ass,
                                    montant_proj,
                                    montant_apport,
                                    rev_emp_1,
                                    rev_emp_2=0,
                                    montant_frais),nb_mois)
  restant_du_avec_interet <- (nb_mois-mois+ones)*mensualite
  interet <- rep(0,nb_mois)
  capital_restant_du <- rep(montant_emprunt,nb_mois)
  for(i in 1:nb_mois){
    interet[i] <- capital_restant_du[i]*taux_int/12
    capital_restant_du[i+1] <- capital_restant_du[i]-(mensualite[i]-assurance[i]-interet[i])
  }#fin for
  capital_restant_du <- capital_restant_du[1:nb_mois]
  amortissement <- mensualite-interet-assurance
  #interet <- (restant_du-assurance-montant_frais/nb_mois)*taux_int/12
  
  ##sortie
  data.frame(mois,restant_du_avec_interet,capital_restant_du,amortissement,interet,assurance,mensualite)
}