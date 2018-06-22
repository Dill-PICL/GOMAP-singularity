argot2gaf <- function(in_files,out_file,config){
    print("Reading the input file")
    gaf_date = format(Sys.time(),"%m%d%Y")
    
    tmp_out = lapply(in_files,function(infile){
        tmp_data = fread(infile,sep = "\t",header = T)
        colnames(tmp_data) = gsub("#","",colnames(tmp_data))
        tmp_data
    })
    argot2_data = do.call(rbind,tmp_out)
    argot2_data = argot2_data[!grep("#",`SeqID`)]
    
    gaf_cols=fread(config$data$go$gaf_cols,header = F)$V1
    gaf_cols
    
    print("Converting to GAF 2.0")
    gaf_data = argot2_data[,.(`SeqID`,`GO ID`,`Int. Confidence`)]
    colnames(gaf_data) = c("db_object_id","term_accession","with")
    
    
    gaf_data$with = as.numeric(gaf_data$with)
    min_score=min(gaf_data$with)
    max_score=max(gaf_data$with)
    gaf_data$with = (gaf_data$with - min_score)/(max_score - min_score)
    
    
    obo_data = check_obo_data(config$data$go$obo)
    aspect = unlist(obo_data$aspect[gaf_data$term_accession])
    gaf_data[,aspect:=aspect]
    
    #gaf_data[,db_object_id:=tmp]
    
    gaf_data[,db_object_symbol:=db_object_id]
    gaf_data[,db:="maize-GAMER"]
    gaf_data[,qualifier:=""]
    gaf_data[,db_reference:="MG:0000"]
    gaf_data[,evidence_code:="IEA"]
    gaf_data[,db_object_name:=""]
    gaf_data[,db_object_synonym:=""]
    gaf_data[,db_object_type:="protein"]
    gaf_data[,taxon:="taxon:4577"]
    gaf_data[,date:=gaf_date]
    gaf_data[,assigned_by:="Argot2"]
    gaf_data[,annotation_extension:=""]
    gaf_data[,gene_product_form_id:=""]
    setcolorder(gaf_data,gaf_cols)

    
    print("Writing the outfile")
    write_gaf(gaf_data,out_file)
}