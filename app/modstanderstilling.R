# modstanderhold_stilling.R

modstanderhold_stilling<- function(stilling) {
  if(stilling == "low") {
    return(list(
      low = 1,
      medium = 0,
      top = 0
    ))
  } else if(stilling == "medium") {
    return(list(
      low = 0,
      medium = 1,
      top = 0
    ))
  } else if(stilling == "top") {
    return(list(
      low = 0,
      medium = 0,
      top = 1
    ))
  }
}

write_rds(modstanderhold_stilling , "C:/Users/hajer/OneDrive/Documents/GitHub/shiny_simon/app/modstanderhold_stilling.Rds")
