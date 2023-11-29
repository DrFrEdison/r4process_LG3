sql_to_csv_LG3 <- function(sqlquery
                           , wl = 190:598
                           , spectratype = NA # c("drk", "ref", "spc")
                           , wd = dt$wd
                           , export_path = paste0("C://Users/", lg3$para$uid, "/Documents/")){
  dat <- list()
  
  # Datei ordnen ####
  dat$spectrum_col <- which(unlist(gregexpr("Spectrum_csv", names(sqlquery))) > 0)
  dat$spectrum_col <- dat$spectrum_col[ length( dat$spectrum_col )]
  
  dat$numeric_cols <- lapply(strsplit(sqlquery[ , dat$spectrum_col], ";"), function(x) as.numeric(gsub(",", ".", x)))
  dat$spc <- data.table(do.call(rbind, dat$numeric_cols))
  names(dat$spc) <- paste0("X", wl)
  
  dat$raw <- data.table( sqlquery[ , -dat$spectrum_col], dat$spc)
  
  # Datum & Uhrzeit ####
  dat$raw$timestamp <- as.POSIXct( dat$raw$timestamp, tz = "UTC" )
  names( dat$raw )[ names( dat$raw ) %in% "timestamp"] <- "datetime"
  names( dat$raw )[ names( dat$raw ) %in% "DateTime"] <- "datetime"
  
  dat$raw <- cbind(dat$raw, date = as.Date( dat$raw$datetime, tz = "UTC" ))
  dat$raw <- cbind(dat$raw, time = strftime( dat$raw$datetime, format = "%H:%M:%S" ))
  dat$raw <- dat$raw[ , moveme( names(dat$raw), "location line datetime date time first"), with = F]
  
  dat$raw <- dat$raw[ order(dat$raw$datetime),]
  
  # Pfad ####
  setwd( export_path )
  
  # Wenn Datei mehr als einmal vorkommt, dann rbindlist ####
  if( length( dir( pattern = paste0(spectratype, "_R_export.csv"))) > 0 ){
    
    dat$raw.exist <- fread( xfile <- dir( pattern = paste0(spectratype, "_R_export.csv"))[ length( dir( pattern = paste0(spectratype, "_R_export.csv")))]
                            , sep = ";", dec = ",")
    dat$raw <- rbindlist( list(dat$raw, dat$rawexist))
    dat$raw <- dat$raw[ order( dat$raw$datetime) , ]
    unlink(xfile)
    unlink(dir( pattern = paste0(spectratype, "_R_export.csv")))
  }
  
  # .csv schreiben ####
  fwrite( dat$raw
          , dat$filename <- paste0(unique(dat$raw$date)[ 1 ], "_", max(unique(dat$raw$date)), "_", unique(dat$raw$location), "_", unique(dat$raw$line), "_", spectratype, "_R_export.csv")
          , sep = ";", dec = ",")
  
  return( paste0(export_path, "/", dat$filename ))
  
}

