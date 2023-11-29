setwd( "D:/r4dt_LG3")
source( "LG3_main.R")

args <- commandArgs(trailingOnly = TRUE)

# Check if there is at least one argument (the batch filename)
if (length(args) >= 1) {
  # Extract the batch filename (without extension) from the argument
  batch_filename <- tools::file_path_sans_ext(args[1])
  
  # Split the batch filename by underscores
  filename_parts <- unlist(strsplit(batch_filename, "_"))
  
  if (length(filename_parts) >= 3) {
    # Extract the type and n values
    batch_type <- filename_parts[2]
    batch_n <- as.numeric(filename_parts[3])
    
    # Use batch_type and batch_n in your R code
    cat("Batch Type:", batch_type, "\n")
    cat("Batch n:", batch_n, "\n")
    
    # Zeitspanne für Abfrage ####
    lg3$sql$time.t0 <- substr(as.character(Sys.time() - batch_n * 60), 1, 19)
    lg3$sql$time.t1 <- substr(as.character(Sys.time()), 1, 19)
    
    print(lg3$sql$time.t0)
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
                           , export_path = paste0("C://Users/", lg3$para$uid, "/Documents/"))
    
    # Read .csv file
    dat <- list()
    dat$raw <- fread(lg3$query, sep = ";", dec = ",")
    dat$ppp <- transfer_csv.num.col(dat$raw)
    
    png(gsub("\\.csv$", "\\.png", basename(lg3$query))
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
    
    cumsump <- cumsum(c(0, diff(dat$raw$datetime)))
    if( max(cumsump) / 60 < 180 )
      text(x3 + diff(par("usr")[c(1,2)]) * .0125/2, y3
           , paste("vor", round((cumsump / 60 )[seq(1, length(cumsump / 60), len = 5)] , 1), "Minuten")
           , adj = 0, xpd = T, cex = .75)
    
    if( max(cumsump) / 60 >= 180 )
      text(x3 + diff(par("usr")[c(1,2)]) * .0125/2, y3
           , paste("vor", round((cumsump / 60 / 60 )[seq(1, length(cumsump / 60 / 60), len = 5)] , 1), "Stunden")
           , adj = 0, xpd = T, cex = .75)
    
    dev.off()
  }
} else {
  cat("Invalid filename format. Please use 'plot_type_n.bat' format.\n")
}
