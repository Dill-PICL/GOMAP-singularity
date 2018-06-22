fanngo2gaf <- function(in_file,out_gaf,config){
    print("Reading the input file")
    #in_file="FANNGO_linux_x64/scores.txt"
    #out_gaf="FANNGO_linux_x64/gaf/fanngo-0.0.gaf"
    gaf_date = format(Sys.time(),"%m%d%Y")
    
    fanngo_data = fread(in_file)
    tmp = gsub("_P[0-9]+","",fanngo_data$gene_id)
    tmp = gsub("FGP","FG",tmp,fixed = T)
    tmp
    fanngo_data[,gene_id:=tmp]
    
    fanngo_melt = melt(fanngo_data,id.vars = "gene_id")
    colnames(fanngo_melt) = c("db_object_id","term_accession","with")
    
    
    gaf_cols=fread(config$go$gaf_cols,header = F)$V1
    gaf_cols
    
    print("Converting to GAF 2.0")
    gaf_data = data.table(fanngo_melt)
    rm(fanngo_melt,fanngo_data)
    
    gaf_data$term_accession = gsub("_",":",gaf_data$term_accession,fixed = T)
    
    obo_data = check_obo_data(config$go$obo)
    
    #tmp_aspect = get_aspect(obo_data,gaf_data$term_accession)
    
    tmp_aspect=lapply(gaf_data$term_accession,function(x){
        out = obo_data$aspect[[x]]
        if(is.null(out)){
            print(x)
            "N"
        }else{
            out    
        }
    })
    gaf_data[,aspect:=unlist(tmp_aspect)]
    
    min_score=min(gaf_data$with)
    max_score=max(gaf_data$with)
    gaf_data$with = (gaf_data$with - min_score)/(max_score - min_score)
    
    gaf_cols[!gaf_cols %in% colnames(gaf_data)]
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
    gaf_data[,assigned_by:="FANN-GO"]
    gaf_data[,annotation_extension:=""]
    gaf_data[,gene_product_form_id:=""]
    setcolorder(gaf_data,gaf_cols)
    
    print("Writing the outfile")
    write_gaf(gaf_data,out_gaf)
}