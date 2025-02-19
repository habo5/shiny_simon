
predict_value <- function(år, modstanderhold_stillinglow_superligua, modstanderhold_stillingmedium_superligua, 
                          ferieefterårsferie, rain, win_ratio_3, dag_kategori_feriehverdag_efterårsferie,
                          modstanderhold_stillingtop_superligua) {
  
  prediction <- -2.441562e+06 + 
    1.605815e+03 * år + 
    1.293737e+02 * modstanderhold_stillinglow_superligua + 
    1.727292e+02 * modstanderhold_stillingmedium_superligua + 
    -6.265421e+00 * ferieefterårsferie + 
    -3.460943e+01 * rain + 
    1.507924e+01 * win_ratio_3 + 
    -4.895354e+01 * dag_kategori_feriehverdag_efterårsferie + 
    2.467648e+02 * modstanderhold_stillingtop_superligua + 
    -4.814758e-08 * år^4
  
  return(prediction)
}





write_rds(predict_value , "C:/Users/hajer/OneDrive/Documents/GitHub/shiny_simon/app/predict_VIP_attendance.Rds")
