setwd( "D:/r4dt_LG3")
source( "LG3_main.R")

library(taskscheduleR, lib.loc = lg3$path$libloc)
Rexe <- paste0(lg3$wd, "/R-Portable/App/R-Portable/bin/x64/Rscript.exe")

# tasklist <- taskscheduler_ls()
# View(tasklist)
# taskscheduler_delete("LG3_csv")

# LG3 send csv task
taskscheduler_create(taskname = "LG3_csv", rscript = paste0( lg3$wd, "/LG3_send_csv.R"),
                     schedule = "DAILY", starttime = as.character(lg3$para$time_csv), Rexe = Rexe)

# # LG3 drk validation
taskscheduler_create(taskname = "LG3_val_drk", rscript = paste0( lg3$wd, "/LG3_drk_val.R"),
                     schedule = "MINUTE", modifier = 15, Rexe = Rexe)

# # LG2 ref validation
# Sys.sleep(120)
# taskscheduler_create(taskname = "LG3_val_ref", rscript = paste0( lg3$wd, "/LG3_ref_val.R"),
#                      schedule = "MINUTE", modifier = 15, Rexe = Rexe)

# # do every task once ####
# taskscheduler_create(taskname = "LG3_csv_once", rscript = paste0( lg3$wd, "/LG3_send_csv.R"),
#                       schedule = "ONCE", Rexe = Rexe)
# taskscheduler_create(taskname = "LG3_val_drk_once", rscript = paste0( lg3$wd, "/LG3_drk_val.R"),
#                       schedule = "ONCE", Rexe = Rexe)
# taskscheduler_create(taskname = "LG3_val_ref_once", rscript = paste0( lg3$wd, "/LG3_ref_val.R"),
#                       schedule = "ONCE", Rexe = Rexe)

# Delete task ####
# taskscheduler_delete("LG3_csv")
# taskscheduler_delete("LG3_val_drk")
# taskscheduler_delete("LG3_val_ref")

# taskscheduler_delete("LG3_csv_once")
# taskscheduler_delete("LG3_val_drk_once")
# taskscheduler_delete("LG3_val_ref_once")
