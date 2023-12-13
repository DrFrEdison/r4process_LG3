setwd( "D:/r4dt_LG3")

save.wd <- getwd()

source( "LG3_main.R")

args <- commandArgs(trailingOnly = TRUE)

# Check if there is at least one argument (the batch filename)
if (length(args) >= 1) {
  # Extract the batch filename (without extension) from the argument
  batch_filename <- tools::file_path_sans_ext(args[1])
  
  # Split the batch filename by underscores
  filename_parts <- unlist(strsplit(batch_filename, "_"))
  
  if (length(filename_parts) == 3) {
    # Extract the type and n values
    batch_type <- filename_parts[2]
    batch_n <- as.numeric(filename_parts[3])
    
    # Use batch_type and batch_n in your R code
    cat("Batch Type:", batch_type, "\n")
    cat("Batch n:", batch_n, "\n")
    
    # Zeitspanne für Abfrage ####
    lg3$sql$time.t0 <- substr(as.character(Sys.time() - batch_n * 60), 1, 19)
    lg3$sql$time.t1 <- substr(as.character(Sys.time()), 1, 19)
    
    lg3$query <- sql_query(driver = lg3$para$sql_driver
                           , server = lg3$para$sql_server
                           , database = lg3$para$database
                           , t0 = lg3$sql$time.t0
                           , t1 = lg3$sql$time.t1
                           , ref.sql = paste0(lg3$wd, "/sql/dt_sql_bgd_XGuard.sql")
                           , drk.sql = paste0(lg3$wd, "/sql/dt_sql_drk_XGuard.sql")
                           , spc.sql = spc.sql
                           , wl = 190 : 598
                           , ask = c(batch_type)
                           , wd = lg3$wd 
                           , export_path = paste0("C://Users/", lg3$para$uid, "/Documents/")
                           , bat = T)
    
    # Read .csv file
    dat <- list()
    dat$raw <- lg3$query[[ 2 ]]
    dat$ppp <- transfer_csv.num.col(dat$raw)
    
    setwd(save.wd)
    setwd("..")
    
    filenamep <- paste(gsub(":", "", gsub(" ", "_", gsub("-", "", paste( substr(lg3$sql$time.t0, 3, nchar( lg3$sql$time.t0 ))
                                                                         , substr(lg3$sql$time.t1, 3, nchar( lg3$sql$time.t0 ))
                                                                         , sep = "_bis_"))))
                       , gsub("\\.csv$", "\\.png", substr(basename(lg3$query[[ 1 ]]), 23, nchar( basename(lg3$query[[ 1 ]]) )))
                       , sep = "_")
    filenamep <- gsub("_R_export", "", filenamep)
    
    png(filenamep
        ,xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")
    
    par( mar = c(3,3,2,8))
    matplot( dat$ppp$wl
             , ydat1 <- t( dat$raw[ , dat$ppp$numcol, with = F])
             , lty = 1, type = "l"
             , xlab = ""
             , ylab = ""
             , col = y1.col <- hcl.colors( ncol(ydat1)))
    mtext(expression(paste(lambda, " in nm")), 1, 2)
    mtext(ifelse(batch_type == "spc", "AU", "Counts"), 2, 2)
    mtext( paste0("Spektren zwischen ", lg3$sql$time.t0, " und ", lg3$sql$time.t1, "\nin ", lg3$para$location, ", Linie ", lg3$para$line)
           , 3, 0)
    
    legend_image <- as.raster(matrix( y1.col, ncol=1))
    
    x1 <- par("usr")[2]
    x2 <- x1 + diff(par("usr")[c(1,2)]) * .03
    y1 <- par("usr")[4]
    y2 <- par("usr")[3] # <- median(par("usr")[c(3,4)])
    
    rasterImage(legend_image, x1 ,y1, x2, y2, xpd = T)
    segments(x2
             , y3 <- seq(y1, y2, len = 5)
             , x3 <- x2 + diff(par("usr")[c(1,2)]) * .0125
             , y3
             , xpd = T)
    rect(x1,y1,x2,y2, xpd = T)
    
    timestamps <- c(as.character(dat$raw$datetime), as.character(as.POSIXct(lg3$sql$time.t1, tz = "UTC")))
    timestamps <- as.POSIXct(timestamps, tz   = "UTC")
    
    timestamps.list <- list()
    for(i in 2 : length( timestamps )){
      
      timestamps.list[[ i - 1]] <- as.numeric(difftime(timestamps[ i ], timestamps[ i - 1], units = "sec"))
      
    }
    
    timestamps.list <- unlist( timestamps.list )    
    
    
    cumsump <- cumsum(c(0, timestamps.list))
    if( max(cumsump) / 60 < 180*60 )
      text(x3 + diff(par("usr")[c(1,2)]) * .0125/2, y3
           , paste("vor", round(seq(range(cumsump)[1], range(cumsump)[2], len = 5)/60, 1), "Minuten")
           , adj = 0, xpd = T, cex = .75)
    
    if( max(cumsump) / 60 >= 180*60 )
      text(x3 + diff(par("usr")[c(1,2)]) * .0125/2, y3
           , paste("vor", round(seq(range(cumsump)[1], range(cumsump)[2], len = 5)/60/60, 1), "Stunden")
           , adj = 0, xpd = T, cex = .75)
    
    dev.off()
  }
  
  if (length(filename_parts) > 3) {
    # Extract the type and n values
    batch_type <- filename_parts[2]
    batch_n <- as.numeric(filename_parts[3])
    batch_lambda <- as.numeric(filename_parts[4])
    
    # Use batch_type and batch_n in your R code
    cat("Batch Type:", batch_type, "\n")
    cat("Batch n:", batch_n, "\n")
    cat("Batch lambda:", batch_lambda, "\n")
    
    # Zeitspanne für Abfrage ####
    lg3$sql$time.t0 <- substr(as.character(Sys.time() - batch_n * 60), 1, 19)
    lg3$sql$time.t1 <- substr(as.character(Sys.time()), 1, 19)
    
    lg3$query <- sql_query(driver = lg3$para$sql_driver
                           , server = lg3$para$sql_server
                           , database = lg3$para$database
                           , t0 = lg3$sql$time.t0
                           , t1 = lg3$sql$time.t1
                           , ref.sql = paste0(lg3$wd, "/sql/dt_sql_bgd_XGuard.sql")
                           , drk.sql = paste0(lg3$wd, "/sql/dt_sql_drk_XGuard.sql")
                           , spc.sql = spc.sql
                           , wl = 190 : 598
                           , ask = c(batch_type)
                           , wd = lg3$wd 
                           , export_path = paste0("C://Users/", lg3$para$uid, "/Documents/")
                           , bat = T)
    
    # Read .csv file
    dat <- list()
    dat$raw <- lg3$query[[ 2 ]]
    dat$ppp <- transfer_csv.num.col(dat$raw)
    
    setwd(save.wd)
    setwd("..")
    
    filenamep <- paste(gsub(":", "", gsub(" ", "_", gsub("-", "", paste( substr(lg3$sql$time.t0, 3, nchar( lg3$sql$time.t0 ))
                                                                         , substr(lg3$sql$time.t1, 3, nchar( lg3$sql$time.t0 ))
                                                                         , sep = "_bis_"))))
                       , paste0("lambda", batch_lambda)
                       , gsub("\\.csv$", "\\.png", substr(basename(lg3$query[[ 1 ]]), 23, nchar( basename(lg3$query[[ 1 ]]) )))
                       , sep = "_")
    filenamep <- gsub("_R_export", "", filenamep)
    
    png(filenamep
        ,xxx<-4800,xxx/16*9,"px",12,"white",res=500,"sans",T,"cairo")
    
    ydat1 <- dat$raw[ , get( grep(batch_lambda, names( dat$raw), value = T))]
    
    plot(as.POSIXct(dat$raw$datetime, tz = "UTC")
         , ydat1
         , xlab = ""
         , ylab = ""
         , col = y1.col <- hcl.colors( length(ydat1)))
    
    mtext(ifelse(batch_type == "spc"
                 , paste0("Absorption bei ", batch_lambda, "nm zwischen\n"
                          , lg3$sql$time.t0, " und ", lg3$sql$time.t1
                          , " in ", lg3$para$location, ", Linie ", lg3$para$line)
                 , paste0("Counts bei ", batch_lambda, "nm zwischen "
                          , lg3$sql$time.t0, " und ", lg3$sql$time.t1
                          , "\nin ", lg3$para$location, ", Linie ", lg3$para$line))
          , 2, 2)
    
    dev.off()
  }
  
} else {
  cat("Invalid filename format. Please use 'plot_type_n.bat' format.\n")
}
