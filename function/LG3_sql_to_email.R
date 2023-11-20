sql_to_email <- function(querylist
                         , from.email = lg3$para$Fromemail
                         , to.email = lg3$para$Toemail_files
                         , Host = lg3$para$Host
                         , i.len = 24
                         , wd = lg3$wd
                         , lg.identify = lg3$identify
                         , export_path = paste0("C://Users/", lg3$para$uid, "/Documents/")){
  
  setwd( export_path )
  # Ref ####
  ref.file <- dir(pattern = "ref_R_export.csv")[length(dir(pattern = "ref_R_export.csv"))]
  if(as.numeric(difftime(Sys.time()
                         , file.info(ref.file)$mtime
                         , unit = "hours")) < 18){
    
    tryCatch(
      {
        attachmentObject <- mime_part(x = paste0(getwd() , "/", ref.file)
                                      ,name = ref.file)
        body <- "csv"
        bodyWithAttachment <- list(body,attachmentObject)
        
        
        sendmail(from = from.email
                 , to = to.email
                 , subject = paste0(substr(ref.file, 1, 10), "_", substr( lg.identify, 1, gregexpr("_", lg.identify)[[ 1 ]][ 3 ] - 1), "_ref")
                 , bodyWithAttachment
                 , control = list(smtpServer= Host))
        
      },
      error = function(e){
        cat("An error occurred during sendmail: ", conditionMessage(e), "\n")
      }
    )
  }
  # Drk ####
  drk.file <- dir(pattern = "drk_R_export.csv")[ length(dir(pattern = "drk_R_export.csv"))]
  if(as.numeric(difftime(Sys.time()
                         , file.info(drk.file)$mtime
                         , unit = "hours")) < 18){
    tryCatch(
      {
        attachmentObject <- mime_part(x = paste0(getwd() , "/", drk.file)
                                      ,name = drk.file)
        body <- "csv"
        bodyWithAttachment <- list(body,attachmentObject)
        
        sendmail(from = from.email
                 , to = to.email
                 , subject = paste0(substr(drk.file, 1, 10), "_", substr( lg.identify, 1, gregexpr("_", lg.identify)[[ 1 ]][ 3 ] - 1), "_drk")
                 
                 , bodyWithAttachment
                 , control = list(smtpServer=Host))
      },
      error = function(e){
        cat("An error occurred during sendmail: ", conditionMessage(e), "\n")
      }
    )
  }
  
  # spc mit Split ####
  dat <- list()
  spc.file <- dir(pattern = "spc_R_export.csv")[ length(dir(pattern = "spc_R_export.csv")) ]
  if(as.numeric(difftime(Sys.time()
                         , file.info(spc.file)$mtime
                         , unit = "hours")) < 18){
    dat$files$spc <- spc.file
    dat$spc$csv <- fread(dat$files$spc, sep = ";", dec = ",")
    
    dat$split <- round(seq(1, nrow(dat$spc$csv), len = i.len), 0)
    
    for(i in 2:i.len){
      
      tryCatch(
        {
          
          if( i != i.len) xdat <- dat$spc$csv[ dat$split[ (i-1) ]:  dat$split[ (i)], ]
          if( i == i.len) xdat <- dat$spc$csv[ dat$split[ (i-1) ]: dat$split[ i ], ]
          
          fwrite( xdat
                  , xfile <- paste0(gsub("\\.csv", "", spc.file), "_", formatC(i-1, width = 3, format = "d", flag = "0"), ".csv")
                  , sep = ";", dec= ",")
          
          attachmentObject <- mime_part(x = xfile
                                        ,name = xfile)
          body <- "csv"
          bodyWithAttachment <- list(body,attachmentObject)
          
          sendmail(from = from.email
                   , to = to.email
                   , subject = paste0(substr(spc.file, 1, 10), "_", substr( lg.identify, 1, gregexpr("_", lg.identify)[[ 1 ]][ 3 ] - 1), "_spc")
                   , bodyWithAttachment
                   , control = list(smtpServer=Host))
          
          unlink(xfile)
        },
        error = function(e){
          cat("An error occurred during sendmail: ", conditionMessage(e), "\n")
        }
      )
    }
  }
}

