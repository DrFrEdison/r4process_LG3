# Arbeitspfad und Funktionen laden ####
setwd( "D:/r4dt_LG3")
source( "LG3_main.R")
source( paste0(lg3$wd, "/function/_function_val_ref.R"))

# Zeitspanne für Abfrage ####
lg3$sql$time.t0 <- paste0(as.character(Sys.time() - 60 * 30))
lg3$sql$time.t1 <- paste0(as.character(Sys.time()))

# ref Pfad ####
setwd(lg3$wd)
dir.create("ref_val", showWarning = F)
setwd( "./ref_val")
lg3$wd.ref <- getwd()

# ref sql query ####
lg3$query <- sql_query(driver = lg3$para$sql_driver
                       , server = lg3$para$sql_server
                       , database = lg3$para$database
                       , t0 = lg3$sql$time.t0
                       , t1 = lg3$sql$time.t1
                       , ref.sql = paste0(lg3$wd, "/sql/dt_sql_bgd_XGuard.sql")
                       , drk.sql = paste0(lg3$wd, "/sql/dt_sql_drk_XGuard.sql")
                       , spc.sql = spc.sql
                       , wl = 190 : 598
                       , ask = c("ref")
                       , wd = lg3$wd
                       , export_path = lg3$wd.ref)

# Datei ####
setwd( lg3$wd.ref )
ref.file <- dir( pattern = "ref_R_export.csv")[ length( dir( pattern = "ref_R_export.csv"))]

# einlesen ####
lg3$raw$ref <- fread(ref.file, sep = ";", dec = ",")
lg3$raw$ref <- lg3$raw$ref[ nrow( lg3$raw$ref ) , ]
lg3$ppp$ref <- transfer_csv.num.col(lg3$raw$ref)

# nach Datum/Zeit umbenennen
ref.file.rename <- paste0(gsub("-", "", gsub(":", "", gsub(" ", "_", as.character(lg3$raw$ref$datetime))))
                          , substr(ref.file, unlist(gregexpr("_", ref.file)[[ 1 ]])[ 2 ], nchar( ref.file)))

# wenn keine neue Referenzmessung vorhanden ist, bricht das Skript hier ab
if(length(dir( pattern = ref.file.rename)) != 0) stop("Kein neuer Dunkelwert gemessen")

# Ansonsten wird die Datei umbenannt
file.rename(ref.file, ref.file.rename)

# Validierung
ref.file.status <- as.character(spectra.validation.ref( lg3$raw$ref[ , lg3$ppp$ref$numcol, with = F]))

# Test für invalide Referenz
# Wenn Dunkelwertspektrum != valid, dann email! ####
tryCatch(
  {
    if( ref.file.status != "valid"){
      attachmentObject <- mime_part(x = paste0(lg3$wd.ref , "/", ref.file.rename)
                                    ,name = ref.file.rename)
      
      body <- paste0("Maximale Counts liegen bei ", max(lg3$raw$ref[ , lg3$ppp$ref$numcol, with = F], na.rm = T))
      bodyWithAttachment <- list(body,attachmentObject)
      
      sendmail(from = lg3$para$Fromemail
               , to = lg3$para$Toemail
               , subject = paste0("Referenz-Spektrum in ", lg3$para$location, "_", lg3$line
                                  , " am ", substr(as.character(lg3$raw$ref$datetime), 1, 10)
                                  , " um ", substr(as.character(lg3$raw$ref$datetime), 12, nchar(as.character(lg3$raw$ref$datetime)))
                                  , " Uhr ", ref.file.status, "!")
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
ref.old.files <- dir( pattern = ".csv")
ref.old.files.date <- as.Date(as.POSIXct( substr(ref.old.files, 1, 8), format = "%Y%m%d"))

for(i in 1 : length(ref.old.files)){
  if( ref.old.files.date[ i ] < Sys.Date()- 3) unlink(ref.old.files[ i ])
}