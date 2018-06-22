library("yaml",quietly = T)

#Reading config file name
args <- commandArgs(T)
config_file <- args[1]

if(F){
    config_file = "maize.B73.AGPv4.json"
}

#Reading config file and creating config object
config = read_yaml(config_file)

source("code/R/gaf_tools.r")
source("code/R/obo_tools.r")
source("code/R/gen_utils.r")
source("code/R/get_comp.r")
source("code/R/get_nr_dataset.r")
source("code/R/logger.r")

#set the logfile and initiate the logger
set_logger(config)

#setting the correct working directory
#setwd(config$input$work_dir)

workdir=paste(config$input$gomap_dir,"/",sep="")
nr_dir = paste(workdir,config$data$gaf$non_red_dir,sep="")
all_nr_datasets=dir(nr_dir,full.names = T)
nr_datasets = all_nr_datasets[grep(config$input$basename,all_nr_datasets)]

agg_dir=paste(workdir,config$data$gaf$agg_dir,"/",sep="")
out_gaf=paste(agg_dir,paste(config$input$basename,"aggregate","gaf",sep="."),sep = "")

new_gaf=sum(file.mtime(nr_datasets)>file.mtime(out_gaf))==0

if(file.exists(out_gaf) & new_gaf){
    flog.warn(paste("The",out_gaf,"exists, So not regenerating aggregate dataset"))
    flog.info(paste("Remove the ",out_gaf,"file to regenerate"))
}else{
    flog.info(paste("The",out_gaf,"missing, So generating the dataset"))
    compile_comprehensive(nr_datasets,out_gaf,config)
}
