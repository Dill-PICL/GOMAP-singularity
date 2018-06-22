#Loading Necessary libraries and packages
library("yaml",quietly = T)

args <- commandArgs(T)

config_file <- args[1]

#Reading config file and creating config object
config = read_yaml(config_file)
if(F){
    config = fromJSON("maize.W22.AGPv2.json")
}

source("code/R/get-rbh.r")
source("code/R/logger.r")

#set the logfile and initiate the logger
set_logger(config)

#setting the correct working directory
#if(dir.exists(config$input$work_dir)){
#    setwd(config$input$work_dir)
#}

ommited_ev_codes = config$go$evidence_codes$omitted


#processing arabidopsis results
spp = "TAIR"
flog.info(paste("Processing", spp))
eval_th = as.numeric(config$software$blast$evalue)
bl_out = get_blast_out(config[["input"]],config[["data"]][["seq-sim"]][[spp]])
main2other = bl_out$main2other
other2main = bl_out$other2main
gaf_file = paste(config[["data"]]$`seq-sim`[[spp]]$basedir,"/",config[["data"]]$`seq-sim`[[spp]]$basename,".gaf",sep="")
out_gaf_file=paste(config[["input"]][["gomap_dir"]],"/",config$data$gaf$raw_dir,"/",config$input$basename,".",config[["data"]]$`seq-sim`[[spp]][["metadata"]]$species,".gaf",sep = "")
rbh_out = gsub("bl.out","rbh.out",main2other)

if(!file.exists(rbh_out)){
    rbh_hits = get_rbh(main2other,other2main,eval_th)
}else{
    flog.info(paste(rbh_out, "already exists. Delete to regenerate"))
    rbh_hits = fread(rbh_out,header = F)
    colnames(rbh_hits) <- c("qseqid","sseqid")
}


if(!file.exists(out_gaf_file)){
    assign_gaf_go(rbh_hits,spp,gaf_file,ommited_ev_codes,out_gaf_file)    
}else{
    flog.info(paste(out_gaf_file, "already exists. Delete to regenerate"))
}


#Processing UniProt plants results
spp = "uniprot"
flog.info(paste("Processing", spp))
bl_out = get_blast_out(config[["input"]],config[["data"]][["seq-sim"]][[spp]])
main2other = bl_out$main2other
other2main = bl_out$other2main
gaf_file = paste(config[["data"]]$`seq-sim`[[spp]]$basedir,"/",config[["data"]]$`seq-sim`[[spp]]$basename,".gaf",sep="")
out_gaf_file=paste(config[["input"]][["gomap_dir"]],"/",config$data$gaf$raw_dir,"/",config$input$basename,".",config[["data"]]$`seq-sim`[[spp]][["metadata"]]$species,".gaf",sep = "")
rbh_out = gsub("bl.out","rbh.out",main2other)

if(!file.exists(rbh_out)){
    rbh_hits = get_rbh(main2other,other2main,eval_th)
}else{
        flog.info(paste(rbh_out, "already exists. Delete to regenerate"))
        rbh_hits = fread(rbh_out,header = F)
        colnames(rbh_hits) <- c("qseqid","sseqid")
}
if(!file.exists(out_gaf_file)){
    assign_gaf_go(rbh_hits,spp,gaf_file,ommited_ev_codes,out_gaf_file)    
}else{
    flog.info(paste(out_gaf_file, "already exists. Delete to regenerate"))
}
