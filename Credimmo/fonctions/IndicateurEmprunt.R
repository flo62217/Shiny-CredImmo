#' Title
#'
#' @return
#' @export
#'
#' @examples
IndicateurEmprunt <-function(duree_cred,
                             taux_int,
                             taux_ass,
                             montant_proj,
                             montant_apport,
                             rev_emp_1,
                             rev_emp_2=0,
                             montant_frais=0){
  taux_endettement <- score_emprunteur(duree_cred,
                                       taux_int,
                                       taux_ass,
                                       montant_proj,
                                       montant_apport,
                                       rev_emp_1,
                                       rev_emp_2,
                                       montant_frais)
  if(taux_endettement>1/3){
    cat("credit non accordé car taux_endettement trop élevé.\n
          veuillez baissez les mensualités")
  }#end if
  }#end function