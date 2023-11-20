spectra.validation.drk <- function(spc, c1 = 9, c2 = 90, max.Counts = 2000){
  
  spc.val.drk <- list()
  
  # Mad fuer Dunkelwert berechnen
  spc.val.drk$mad <- mad(as.numeric(spc))
  
  # Max fuer Dunkelwert berechnen
  spc.val.drk$max <- max(as.numeric(spc))
  
  # Wenn Mad > als c1, zwischen c1 und c2 oder > c2
  if(!is.na(spc.val.drk$mad)){
    if(spc.val.drk$mad < c1) spc.val.drk$val.mad = "valid"
    if(spc.val.drk$mad >= c1 & spc.val.drk$mad <= c2) spc.val.drk$val.mad = "critical"
    if(spc.val.drk$mad > c2) spc.val.drk$val.mad = "invalid"}
  
  # Wenn Max > als max.Counts
  if(!is.na(spc.val.drk$max)){
    if(spc.val.drk$max < max.Counts) spc.val.drk$val.max = "valid"
    if(spc.val.drk$max >= max.Counts) spc.val.drk$val.max = "invalid"}
  
  # Wenn Spektrum leer ist
  if(is.na(spc.val.drk$mad)) spc.val.drk$val.mad = "empty"
  if(is.na(spc.val.drk$max)) spc.val.drk$val.max = "empty"
  
  # Warnmeldung vereinheitlichen
  spc.val.drk$val <- unique( spc.val.drk$val.mad, spc.val.drk$val.max)
  
  # Wenn die Meldung uneinheitlich sind, melde "critical"
  if( length( spc.val.drk$val ) > 1) spc.val.drk$val <- "critical"
  
  # Faktoren vergeben (unnötig?)
  spc.val.drk$val <- factor(spc.val.drk$val, levels = c("valid", "critical", "invalid", "empty"))
  
  return(spc.val.drk$val)
}