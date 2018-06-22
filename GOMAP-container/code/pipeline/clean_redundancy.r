library("yaml",quietly = T)

source("code/R/gaf_tools.r")
source("code/R/obo_tools.r")
source("code/R/gen_utils.r")
source("code/R/get_nr_dataset.r")
source("code/R/logger.r")

#Reading config file name
args <- commandArgs(T)
config_file <- args[1]

#Reading config file and creating config object
config = read_yaml(config_file)

#set the logfile and initiate the logger
set_logger(config)

#setting the correct working directory
#setwd(config$input$work_dir)

workdir=paste(config$input$gomap_dir,"/",sep="")
uniq_gaf_dir = paste(workdir,config$data$gaf$uniq_dir,sep="")
uniq_datasets=dir(uniq_gaf_dir,full.names = T)
in_gaf=uniq_datasets[1]

tmp_out = lapply(uniq_datasets,function(in_gaf){
    non_red_dir=paste(workdir,config$data$gaf$non_red_dir,sep="")
    out_gaf=paste(non_red_dir,"/",basename(in_gaf),sep="")
    if(file.exists(out_gaf) & file.mtime(in_gaf)<file.mtime(out_gaf)){
        flog.warn(paste("The",out_gaf,"exists, So not removing duplicates from",in_gaf))
        flog.info(paste("Remove the ",out_gaf,"file to regenerate"))
    }else{
        flog.info(paste("The",out_gaf,"missing, So removing duplicates from",in_gaf))
        remove_redundancy(in_gaf,out_gaf,config)
    }
})