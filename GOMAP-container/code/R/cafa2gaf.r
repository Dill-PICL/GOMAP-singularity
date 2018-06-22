library("reshape2")

source("code/gaf_tools.r")
source("code/obo_tools.r")
source("code/argot2gaf.r")
source("code/pannzer2gaf.r")
source("code/fanngo2gaf.r")

library("jsonlite")

#Reading config file and creating config object
config = fromJSON("config.json")

#setting the correct working directory
setwd(config$input$work_dir)

gaf_dir = paste(config$`mixed-meth`$gaf,"/",sep="")
gaf_dir

#processing argot2.5 results
argot2_results = dir(config$`mixed-meth`$Argot$result_dir,full.names = T)

argot2_gaf=paste(gaf_dir,paste(config$input$species,config$input$inbred,config$input$version,"argot2.5","gaf",sep="."),sep = "")
filter_argot2(in_file=argot2_results,out_file=argot2_gaf,config=config)

#processing PANNZER results
pannzer_results =  dir(config$`mixed-meth`$PANNZER$result_dir,pattern = ".GO",full.names = T)
pannzer_gaf = paste(gaf_dir,paste(config$input$species,config$input$inbred,config$input$version,"pannzer","gaf",sep="."),sep = "")
pannzer2gaf(in_files = pannzer_results,out_gaf=pannzer_gaf,config)

#processing FANN-GO results
fanngo_res= config$`mixed-meth`$fanngo$output
fanngo_gaf = paste(gaf_dir,paste(config$input$species,config$input$inbred,config$input$version,"fanngo","gaf",sep="."),sep = "")
fanngo2gaf(fanngo_res,fanngo_gaf,config)
