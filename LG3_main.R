lg3 <- list()
lg3$wd <- "D:/r4dt_LG3"

# Lade alle Pakete aus der Bibliothek ####
setwd(lg3$wd)
lg3$path$liblock <- paste0(getwd(), "/renv/library/R-4.2/x86_64-w64-mingw32")

suppressPackageStartupMessages(library(odbc, lib.loc = lg3$path$libloc))
suppressPackageStartupMessages(library(RODBC, lib.loc = lg3$path$libloc))
suppressPackageStartupMessages(library(this.path, lib.loc = lg3$path$libloc))
suppressPackageStartupMessages(library(data.table, lib.loc = lg3$path$libloc))
suppressPackageStartupMessages(library(sendmailR, lib.loc = lg3$path$libloc))

# Lade die benötigten Funktionen ####
setwd( lg3$wd )
source("function/LG3_sql_query.R")
source("function/LG3_sql_to_csv.R")
source("function/LG3_sql_to_email.R")
source("function/global.R")

# Auf welcher Anlage befindet sich dieses Skript? ####
lg3$identify <- dir( pattern = "identify.txt")

# Lade Übersichtsdatei und finde die entsprechende Zeile ####
setwd( lg3$wd )
lg3$para <- fread("r4process_LG3.csv")

lg3$customer <- substr( lg3$identify, 1, gregexpr("_", lg3$identify)[[ 1 ]][ 1 ] - 1)
lg3$location <- substr( lg3$identify, gregexpr("_", lg3$identify)[[ 1 ]][ 1 ] + 1, gregexpr("_", lg3$identify)[[ 1 ]][ 2 ] - 1)
lg3$line <- substr( lg3$identify, gregexpr("_", lg3$identify)[[ 1 ]][ 2 ] + 1, gregexpr("_", lg3$identify)[[ 1 ]][ length( gregexpr("_", lg3$identify)[[ 1 ]]) ] - 1)

lg3$para$sql_server <- gsub("\\\\+", "\\\\", lg3$para$sql_server)

lg3$para <- lg3$para[which(lg3$para$customer == lg3$customer &
                             lg3$para$location == lg3$location &
                             lg3$para$line == lg3$line) , ]

# SQL Abfrage für LG3 oder SG3
if(lg3$para$LG == "LG3") spc.sql <- paste0(lg3$wd, "/sql/dt_sql_spc_XGuard.sql")
if(lg3$para$LG == "SG3") spc.sql <- paste0(lg3$wd, "/sql/dt_sql_spc_XGuard_SG3.sql")



