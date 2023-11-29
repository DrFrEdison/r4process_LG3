setwd( "D:/r4dt_LG3")
source( "LG3_main.R")
source( paste0(lg3$wd, "/function/_function_val_drk.R"))

# Zeitspanne für Abfrage ####
lg3$sql$time.t0 <- paste0(as.character(Sys.time() - 60 * 30))
lg3$sql$time.t1 <- paste0(as.character(Sys.time()))

# drk Pfad ####
setwd(lg3$wd)
dir.create("drk_val")
setwd( "./drk_val")
lg3$wd.drk <- getwd()

# drk query ####
lg3$query <- sql_query(driver = lg3$para$sql_driver
                       , server = lg3$para$sql_server
                       , database = lg3$para$database
                       , t0 = lg3$sql$time.t0
                       , t1 = lg3$sql$time.t1
                       , ref.sql = paste0(lg3$wd, "/sql/dt_sql_bgd_XGuard.sql")
                       , drk.sql = paste0(lg3$wd, "/sql/dt_sql_drk_XGuard.sql")
                       , spc.sql = spc.sql
                       , wl = 190 : 598
                       , ask = c("drk")
                       , wd = lg3$wd
                       , export_path = lg3$wd.drk)

# Datei ####
setwd( lg3$wd.drk )
drk.file <- dir( pattern = "_drk_R_export.csv")[ length( dir( pattern = "_drk_R_export.csv"))]

# einlesen ####
lg3$raw$drk <- fread(drk.file, sep = ";", dec = ",")
lg3$raw$drk <- lg3$raw$drk[ nrow( lg3$raw$drk ) , ]
lg3$ppp$drk <- transfer_csv.num.col(lg3$raw$drk)

# nach Datum/Zeit umbenennen
drk.file.rename <- paste0(gsub("-", "", gsub(":", "", gsub(" ", "_", as.character(lg3$raw$drk$datetime))))
                          , substr(drk.file, 22, nchar( drk.file)))

# wenn keine neune Dunkelwertmessung vorhanden ist, bricht das Skript hier ab
if(length(dir( pattern = drk.file.rename)) != 0) stop("Kein neuer Dunkelwert gemessen")

# Ansonsten wird die Datei umbenannt
file.rename(drk.file, drk.file.rename)

# Validierung
drk.file.status <- as.character(spectra.validation.drk( lg3$raw$drk[ , lg3$ppp$drk$numcol, with = F]))

# Wenn Dunkelwertspektrum != valid, dann email! ####
tryCatch(
  {
    if( drk.file.status != "valid"){
      attachmentObject <- mime_part(x = paste0(lg3$wd.drk , "/", drk.file.rename)
                                    ,name = drk.file.rename)
      body <- "csv"
      bodyWithAttachment <- list(body,attachmentObject)
      
      sendmail(from = lg3$para$Fromemail
               , to = lg3$para$Toemail
               , subject = paste0("Dunkelwertspektrum in ", lg3$para$location, "_", lg3$line
                                  , " am ", substr(as.character(lg3$raw$drk$datetime), 1, 10)
                                  , " um ", substr(as.character(lg3$raw$drk$datetime), 12, nchar(as.character(lg3$raw$drk$datetime)))
                                  , " Uhr ", drk.file.status, "!")
               , bodyWithAttachment
               , control = list(
                 smtpServer=lg3$para$Host
               ))
    }
  },
  error = function(e){
    cat("An error occurred during sendmail: ", conditionMessage(e), "\n")
  }
)

# Alte Dateien löschen ####
drk.old.files <- dir( pattern = ".csv")
drk.old.files.date <- as.Date(as.POSIXct( substr(drk.old.files, 1, 8), format = "%Y%m%d"))

for(i in 1 : length(drk.old.files)){
  if( drk.old.files.date[ i ] < Sys.Date()- 3) unlink(drk.old.files[ i ])
}