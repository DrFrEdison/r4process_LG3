setwd( "D:/r4dt_LG3")
source( "LG3_main.R")

# Zeitspanne für Abfrage ####
lg3$sql$time.t0 <- paste0(Sys.Date() - 1, " 00:00:00")
lg3$sql$time.t1 <- paste0(Sys.Date() - 1, " 23:59:59")

lg3$query <- sql_query(driver = lg3$para$sql_driver
                       , server = lg3$para$sql_server
                       , database = lg3$para$database
                       , t0 = lg3$sql$time.t0
                       , t1 = lg3$sql$time.t1
                       , ref.sql = paste0(lg3$wd, "/sql/dt_sql_bgd_XGuard.sql")
                       , drk.sql = paste0(lg3$wd, "/sql/dt_sql_drk_XGuard.sql")
                       , spc.sql = paste0(lg3$wd, "/sql/dt_sql_spc_XGuard.sql")
                       , wl = 190 : 598
                       , ask = c("ref", "drk", "spc")
                       , wd = lg3$wd 
                       , export_path = paste0("C://Users/", lg3$para$uid, "/Documents/"))

# SQL Abfrage und Versenden ####
sql_to_email(from.email = lg3$para$Fromemail
             , to.email = lg3$para$Toemail_files
             , Host = lg3$para$Host
             , wd = lg3$wd
             , export_path = paste0("C://Users/", lg3$para$uid, "/Documents/")
             , lg.identify = lg3$identify
             , i.len = round(abs(as.numeric(difftime(as.POSIXct( lg3$sql$time.t0, tz = "UTC" )
                                                     , as.POSIXct( lg3$sql$time.t1, tz = "UTC" ), units = "hours")))) - 1)




