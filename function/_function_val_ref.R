spectra.validation.ref <- function(spc, max.Counts = 50000){
  
  spc.val.ref <- list()
  
  # Max fuer Referenzen berechnen
  spc.val.ref$max <- max(as.numeric(spc))
  
  # Wenn Max > als max.Counts
  if(!is.na(spc.val.ref$max)){
    if(spc.val.ref$max >= max.Counts) spc.val.ref$val.max = "valid"
    if(spc.val.ref$max < max.Counts) spc.val.ref$val.max = "invalid"}
  
  # Wenn Spektrum leer ist
  if(is.na(spc.val.ref$max)) spc.val.ref$val.max = "empty"
  
  # Faktoren vergeben (unnötig?)
  spc.val.ref$val.max <- factor(spc.val.ref$val.max, levels = c("valid", "critical", "invalid", "empty"))
  
  return(spc.val.ref$val.max)
}