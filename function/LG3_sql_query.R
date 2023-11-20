sql_query <- function(driver = lg3$sql$driver
                      , server = lg3$sql$server
                      , database = lg3$sql$database
                      , t0 = lg3$sql$time.t0
                      , t1 = lg3$sql$time.t1
                      , ref.sql = paste0(lg3$wd, "/sql/dt_sql_bgd_XGuard.sql")
                      , drk.sql = paste0(lg3$wd, "/sql/dt_sql_drk_XGuard.sql")
                      , spc.sql = paste0(lg3$wd, "/sql/dt_sql_spc_XGuard.sql")
                      , wl = 190 : 598
                      , ask = c("ref", "drk", "spc")
                      , wd = lg3$wd
                      , export_path){
  
  # SQL Connection ####
  con <- dbConnect(odbc()
                   , driver = driver
                   , server = server
                   , database = database
                   # uid = dat$sql$uid,
                   # pwd = dat$sql$pwd
                   # Port = dat$sql$port
  )
  
  # SQL-Abfragen ####
  setwd( wd )
  
  if( "ref" %in% ask ){
    ref.sql.get <-  getSQL(ref.sql)[ 1 ]
    ref.sql.get <- gsub("YYYY-MM-DD HH:MM:SS_t0", t0, ref.sql.get)
    ref.sql.get <- gsub("YYYY-MM-DD HH:MM:SS_t1", t1, ref.sql.get)
    ref.sql.get <- dbGetQuery(con, ref.sql.get)
  }
  
  if( "drk" %in% ask ){
    drk.sql.get <-  getSQL(drk.sql)[ 1 ]
    drk.sql.get <- gsub("YYYY-MM-DD HH:MM:SS_t0", t0, drk.sql.get)
    drk.sql.get <- gsub("YYYY-MM-DD HH:MM:SS_t1", t1, drk.sql.get)
    drk.sql.get <- dbGetQuery(con, drk.sql.get)
  }
  
  if( "spc" %in% ask ){
    spc.sql.get <-  getSQL(spc.sql)[ 1 ]
    spc.sql.get <- gsub("YYYY-MM-DD HH:MM:SS_t0", t0, spc.sql.get)
    spc.sql.get <- gsub("YYYY-MM-DD HH:MM:SS_t1", t1, spc.sql.get)
    spc.sql.get <- dbGetQuery(con, spc.sql.get)
  }
  
  # Abfragen als .csv schreiben ####
  if( "ref" %in% ask )  if( nrow( ref.sql.get) > 0) sql_to_csv_LG3( sqlquery = ref.sql.get
                                                                    , wl = wl
                                                                    , spectratype = "ref"
                                                                    , export_path = export_path)
  
  if( "drk" %in% ask ) if( nrow( drk.sql.get) > 0) sql_to_csv_LG3( sqlquery = drk.sql.get
                                                                   , wl = wl
                                                                   , spectratype = "drk"
                                                                   , export_path = export_path)
  
  if( "spc" %in% ask ) if( nrow( spc.sql.get) > 0) sql_to_csv_LG3( sqlquery = spc.sql.get
                                                                   , wl = wl
                                                                   , spectratype = "spc"
                                                                   , export_path = export_path)
}



