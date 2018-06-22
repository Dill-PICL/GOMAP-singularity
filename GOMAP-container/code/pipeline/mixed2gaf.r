library("yaml",quietly = T)

#Reading config file name
args <- commandArgs(T)
config_file <- args[1]

if(F){
    config_file = "maize.W22.AGPv2.json"
    config_file = "../test/go-map-ZmAGPv4/ZmAGPv4.all.yml"
}

#Reading config file and creating config object
config = read_yaml(config_file)

source("code/R/gaf_tools.r")
source("code/R/obo_tools.r")
source("code/R/argot2gaf.r")
source("code/R/pannzer2gaf.r")
source("code/R/fanngo2gaf.r")
source("code/R/logger.r")

#set the logfile and initiate the logger
set_logger(config)

#setting the correct working directory
#setwd(config$input$work_dir)

workdir=paste(config$input$gomap_dir,"/",sep="")
gaf_dir = paste(workdir,config$data$gaf[["mixed_method_dir"]],"/",sep="")
basename <- config$input$basename

#processing argot2.5 results
argot_result_dir = paste(workdir,config[["data"]][["mixed-method"]][["argot2"]][["result_dir"]],sep="")
all_argot2_results = dir(argot_result_dir,full.names = T,pattern = "*.tsv")
argot2_results = all_argot2_results[grep(basename,all_argot2_results)]
argot2_gaf=paste(gaf_dir,paste(basename,"argot2.5","gaf",sep="."),sep = "")

if(!file.exists(argot2_gaf)){
    flog.info(paste("Generating GAF file from Argot2.5 Results"))
    argot2gaf(in_files=argot2_results,out_file=argot2_gaf,config=config)    
}else{
    old_gaf = sum(file.mtime(argot2_results) > file.mtime(argot2_gaf))>1
    if(old_gaf){
        flog.info(paste("Generating GAF file from Argot2.5 Results"))
        argot2gaf(in_files=argot2_results,out_file=argot2_gaf,config=config)    
    }else{
        flog.warn(paste("The",argot2_gaf,"exists. So not Running converting Argot-2.5 results"))
        flog.info(paste("Remove the file to reconvert"))    
    }
}


#processing PANNZER results
pannzer_result_dir = paste(workdir,config$data$`mixed-method`$pannzer$result_dir,sep="")
all_pannzer_results =  dir(pannzer_result_dir,pattern = ".GO",full.names = T)
pannzer_results = all_pannzer_results[grep(basename,all_pannzer_results)]
pannzer_gaf = paste(gaf_dir,paste(basename,"pannzer","gaf",sep="."),sep = "")

if(!file.exists(pannzer_gaf)){
    flog.info(paste("Generating GAF file from PANNZER Results"))
    pannzer2gaf(in_files = pannzer_results,out_gaf=pannzer_gaf,config)
}else{
    old_gaf = sum(file.mtime(pannzer_results) > file.mtime(pannzer_gaf))>1
    if(old_gaf){
        flog.info(paste("Generating GAF file from PANNZER Results"))
        pannzer2gaf(in_files = pannzer_results,out_gaf=pannzer_gaf,config)
    }else{
        flog.warn(paste("The",pannzer_gaf,"exists. So not Running converting PANNZER results"))
        flog.info(paste("Remove the file to reconvert"))
    }
}



if(F){
    #processing FANN-GO results
    # Commented out because matlab is cannot be supplied in an image
    fanngo_res= paste(config$`mixed-meth`$fanngo$output,"/",species,".score.txt",sep="")
    fanngo_gaf = paste(gaf_dir,paste(species,"fanngo","gaf",sep="."),sep = "")
    if(!file.exists(fanngo_gaf)){
        fanngo2gaf(fanngo_res,fanngo_gaf,config)
    }else{
        flog.warn(paste("The",fanngo_gaf,"exists. So not Running converting FANN-GO results"))
        flog.info(paste("Remove the file to reconvert"))
    }
}