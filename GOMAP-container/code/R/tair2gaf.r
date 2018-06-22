source("code/R/gaf_tools.r")
source("code/R/logger.r")

library("data.table",quietly = T)
library("jsonlite",quietly = T)

in_args = commandArgs(T)

if(F){
    # This is for debugging purposes
    config <- fromJSON("pipeline.json")
}

config <- fromJSON(in_args[1])

#set the logfile and initiate the logger
set_logger(config)

base_dir = config$data$`seq-sim`$TAIR$basedir
go_file= paste(base_dir , "/raw/" , config$data$`seq-sim`$TAIR$file_names$go_file,sep = "")
gaf_file = paste(base_dir, "/clean/", config$data$`seq-sim`$TAIR$file_names$basename,".gaf",sep = "")
tair_data = fread(go_file)
tair_cols = fread(paste(dirname(go_file),"/arab_ath_cols.txt",sep = ""),header = F)$V1
colnames(tair_data) = tair_cols

arab_gaf = tair_data[grep("^AT.G",object_name),.(locus_name,go_id,aspect,ev_code,ev_with,reference,assigned_by,date)]
arab_gaf$locus_name = substr(arab_gaf$locus_name,1,9)
arab_gaf = cbind(arab_gaf,db="TAIR")
arab_gaf = cbind(arab_gaf,db_object_id=arab_gaf$locus_name,db_object_symbol=arab_gaf$locus_name)
arab_gaf = cbind(arab_gaf,db_object_name="",db_object_synonym="",db_object_type="protein",taxon="taxon:3702")
colnames(arab_gaf)[grep("ev_with",colnames(arab_gaf))] = "with"
colnames(arab_gaf)[grep("reference",colnames(arab_gaf))] = "db_reference"
colnames(arab_gaf)[grep("go_id",colnames(arab_gaf))] = "term_accession"
colnames(arab_gaf)[grep("ev_code",colnames(arab_gaf))] = "evidence_code"
arab_gaf = cbind(arab_gaf,annotation_extension="",gene_product_form_id="",qualifier="")

arab_gaf = arab_gaf[,-c("locus_name"),with=F]
setcolorder(arab_gaf,gaf_cols)

write_gaf(arab_gaf,gaf_file)

flog.info("Finished Processing TAIR GO annotations")