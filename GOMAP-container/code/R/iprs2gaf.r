library("data.table",quietly = T)
source("code/R/obo_tools.r")
source("code/R/gaf_tools.r")


iprs_cols = fread(config[["software"]][["iprs"]][["cols"]],header = F)$V1

iprs2gaf <- function(go_obo,iprs_out,gaf_file){
    
    obo_data = check_obo_data(go_obo)
    #rbh_hits <- fread(rbh_file,header = F,sep = "\t")
    data = fread(iprs_out,header = F)
    colnames(data) = iprs_cols
    gaf_date = format(Sys.time(),"%m%d%Y")
    
    gaf_data = data[,list(GO=unlist(strsplit(go,"\\|"))),by=list(acc)]
    colnames(gaf_data) = c("db_object_id","term_accession")
    
    gaf_data[,db:="maize-GAMER"]
    gaf_data[,db_object_symbol:=db_object_id]
    #gaf_data[,qualifier:=""]
    gaf_data[,evidence_code:="IEA"]
    #gaf_data[,with:=""]
    gaf_data[,db_reference:="MG:0000"]
    
    gaf_data[,date:=gaf_date]
    gaf_data[,assigned_by:="IPRS"]
    #gaf_data[,annotation_extension:=""]
    #gaf_data[,gene_product_form_id:=""]
    gaf_data[,taxon:="taxon:4577"]
    gaf_data[,db_object_type:="protein"]
    #gaf_data[,db_object_synonym:=""]
    #test = "db_object_type"
    #gaf_data[,test:=""]
    gaf_data_filt <- gaf_data[term_accession %in% obo_data$id]
    gaf_data_filt[,aspect:=unlist(obo_data$aspect[gaf_data$term_accession])]
    
    write_gaf(gaf_data_filt,gaf_file)
}