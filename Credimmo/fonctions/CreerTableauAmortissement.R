#' Fonction qui créer le tableau d'amortissement
#' On n'autorise pas les valeurs impossible telle que une durée de crédit négative ou nulle
#' ou encore que les autres variables soit négative strictement
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
#' CreerTableauAmortissement(20,0.02,0.02,100000,10000,2000,0,1000)
#' CreerTableauAmortissement(0,0,0,0,0,0,0,0)
#' CreerTableauAmortissement(0,0,0,-1,0,0,0,0)
#' CreerTableauAmortissement(0,0,0,0,-1,0,0,0)
#' CreerTableauAmortissement(0,0,0,0,0,-1,0,0)
#' CreerTableauAmortissement(0,0,0,0,0,0,-1,0)
#' CreerTableauAmortissement(0,0,0,0,0,0,0,-1)

CreerTableauAmortissement<- function(duree_cred,
                                     taux_int,
                                     taux_ass,
                                     montant_proj,
                                     montant_apport,
                                     rev_emp_1,
                                     rev_emp_2=0,
                                     montant_frais=0){
  ##corps
  if(duree_cred<=0 || taux_int<0 || taux_ass<0 || montant_apport<0 || montant_proj<0 ||
     rev_emp_1<0 || rev_emp_2<0 || montant_frais<0){
    print("vérifiez les entrées")
  }
  else{
    nb_mois <- duree_cred*12
    montant_emprunt <- montant_proj - montant_apport
    mois <- seq(1,nb_mois)
    ones <- rep(1,nb_mois)
    assurance <- rep(taux_ass*montant_emprunt,nb_mois)/nb_mois
    mensualite <- rep(round(CalculeMensualite(duree_cred,
                                        taux_int,
                                        taux_ass,
                                        montant_proj,
                                        montant_apport,
                                        rev_emp_1,
                                        rev_emp_2=0,
                                        montant_frais),2),nb_mois)
    restant_du_avec_interet <- (nb_mois-mois+ones)*mensualite
    interet <- rep(0,nb_mois)
    capital_restant_du <- rep(montant_emprunt,nb_mois)
    for(i in 1:nb_mois){
      interet[i] <- capital_restant_du[i]*taux_int/12
      capital_restant_du[i+1] <- capital_restant_du[i]-(mensualite[i]-assurance[i]-interet[i])
    }#end for
    capital_restant_du <- capital_restant_du[1:nb_mois]
    amortissement <- mensualite-interet-assurance
    #interet <- (restant_du-assurance-montant_frais/nb_mois)*taux_int/12
    
    
    df<-data.frame(mois,round(restant_du_avec_interet),round(capital_restant_du),round(amortissement,2),round(interet,2),assurance,round(mensualite,2))
    names(df)<-c("Mois de référence","Restant dû (Avec intérêt)","Restant dû (Sans intérêt)","Ammortissement du prêt","Intérêt payés","Assurance payée","Mensualité du prêt")
    df
  }
}