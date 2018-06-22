library("yaml",quietly = T)

if(F){
    config_file = "../test3/GOMAP-ZmAGPv4/ZmAGPv4.all.yml"
}

#Reading config file name
args <- commandArgs(T)
config_file <- args[1]

#Reading config file and creating config object
config = read_yaml(config_file)


source("code/R/gaf_tools.r")
source("code/R/obo_tools.r")
source("code/R/filter_mixed.r")
source("code/R/logger.r")

#set the logfile and initiate the logger
set_logger(config)

#setting the correct working directory
#setwd(config$input$work_dir)

workdir=paste(config$input$gomap_dir,"/",sep="")
mm_gaf_dir=paste(workdir,config$data$gaf$mixed_method_dir,"/",sep="")
raw_gaf_dir=paste(workdir,config$data$gaf$raw_dir,"/",sep="")

#processing argot2.5 results
argot2_cafa=paste(mm_gaf_dir,paste(config$input$basename,"argot2.5","gaf",sep="."),sep = "")
argot2_raw=paste(raw_gaf_dir,paste(config$input$basename,"argot2.5","gaf",sep="."),sep = "")

if(!file.exists(argot2_raw)){
    filter_mixed_gaf(argot2_cafa,argot2_raw,"argot2",config=config)
}else{
    if(file.mtime(argot2_cafa) > file.mtime(argot2_raw)){
        flog.info(paste("Filtering Argot2 GAF"))
        filter_mixed_gaf(argot2_cafa,argot2_raw,"argot2",config=config)    
    }else{
        flog.warn(paste("The",argot2_raw,"exists. So not filtering Argot-2.5 results"))
        flog.info(paste("Remove the file to reconvert"))    
    }
    
}


#processing PANNZER results
pannzer_cafa = paste(mm_gaf_dir,paste(config$input$basename,"pannzer","gaf",sep="."),sep = "")
pannzer_raw = paste(raw_gaf_dir,paste(config$input$basename,"pannzer","gaf",sep="."),sep = "")

if(!file.exists(pannzer_raw)){
        filter_mixed_gaf(pannzer_cafa,pannzer_raw,"pannzer",config=config)
}else{
    if(file.mtime(pannzer_cafa)>file.mtime(pannzer_raw)){
        flog.info(paste("Filtering PANNZER GAF"))
        filter_mixed_gaf(pannzer_cafa,pannzer_raw,"pannzer",config=config)    
    }else{
        flog.warn(paste("The",pannzer_raw,"exists. So not filtering PANNZER results"))
        flog.info(paste("Remove the file to reconvert"))    
    }
    
}
#processing FANN-GO results

if(F){
    fanngo_cafa = paste(mm_gaf_dir,paste(config$input$basename,"fanngo","gaf",sep="."),sep = "")
    fanngo_raw = paste(raw_gaf_dir,paste(config$input$basename,"fanngo","gaf",sep="."),sep = "")
    if(!file.exists(fanngo_raw)){
        filter_mixed_gaf(fanngo_cafa,fanngo_raw,"fanngo",config)
    }else{
        flog.warn(paste("The",fanngo_raw,"exists. So not filtering FANN-GO results"))
        flog.info(paste("Remove the file to reconvert"))
    }    
}

