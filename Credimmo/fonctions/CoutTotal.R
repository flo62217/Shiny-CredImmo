#' Calcul la somme que va couter le prêt pour le client (intéret + assurance)
#' On n'autorise pas les valeurs impossible telle que une durée de crédit négative ou nulle
#' ou encore que les autres variables soit négative strictement
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
#' CoutTotal(20,0.05,0.02,100000,30000,2000)
#' CoutTotal(0,0,0,0,0,0,0,0)
#' CoutTotal(0,0,0,-1,0,0,0,0)
#' CoutTotal(0,0,0,0,-1,0,0,0)
#' CoutTotal(0,0,0,0,0,-1,0,0)
#' CoutTotal(0,0,0,0,0,0,-1,0)
#' CoutTotal(0,0,0,0,0,0,0,-1)
CoutTotal <- function(duree_cred,
                      taux_int,
                      taux_ass,
                      montant_proj,
                      montant_apport,
                      rev_emp_1,
                      rev_emp_2=0,
                      montant_frais=0){
  if(duree_cred<=0 || taux_int<0 || taux_ass<0 || montant_apport<0 || montant_proj<0 ||
     rev_emp_1<0 || rev_emp_2<0 || montant_frais<0){
    print("vérifiez les entrées")
  }#end if
  else{
    tableau_amortissement <- CreerTableauAmortissement(duree_cred,
                                                       taux_int,
                                                       taux_ass,
                                                       montant_proj,
                                                       montant_apport,
                                                       rev_emp_1,
                                                       rev_emp_2=0,
                                                       montant_frais)
    cout_total_assurance <- tableau_amortissement %>% 
      select(`Assurance payée`) %>% 
      sum()
    cout_total_interet <- tableau_amortissement %>% 
      select(`Intérêt payés`) %>% 
      sum()
    cout_total <- cout_total_assurance + cout_total_interet+montant_frais
    ##sortie
    round(cout_total,0)
  }#end else
}#end function