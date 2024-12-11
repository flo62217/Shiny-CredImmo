#' 
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
CoutTotal <- function(duree_cred,
                      taux_int,
                      taux_ass,
                      montant_proj,
                      montant_apport,
                      rev_emp_1,
                      rev_emp_2=0,
                      montant_frais=0){
  tableau_amortissement <- CreerTableauAmortissement(duree_cred,
                                                     taux_int,
                                                     taux_ass,
                                                     montant_proj,
                                                     montant_apport,
                                                     rev_emp_1,
                                                     rev_emp_2=0,
                                                     montant_frais)
  cout_total_assurance <- tableau_amortissement %>% 
    select(assurance) %>% 
    sum()
  cout_total_interet <- tableau_amortissement %>% 
    select(interet) %>% 
    sum()
  cout_total <- cout_total_assurance + cout_total_interet
  ##sortie
cout_total
    
}