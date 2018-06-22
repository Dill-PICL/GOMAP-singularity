compile_comprehensive = function(nr_datasets,out_gaf,config){
    
    #check if the obo object is available if not read go.obo file
    go_obo = check_obo_data(config$data$go$obo)
    obs_and_alt = c(unlist(go_obo$alt_id[go_obo$obsolete]),names(go_obo$obsolete[go_obo$obsolete]))
    
    
    #read all the datasets
    print(paste("Reading All Datasets"))
    tmp_datasets = lapply(nr_datasets,function(x){
        data = read_gaf(x)
    })
    all_datasets = do.call(rbind,tmp_datasets)
    all_datasets = gaf_check_simple(go_obo,all_datasets)
    
    #remove redundancy to get the minimal set
    print(paste("Removing Redundancy"))
    unit_perc = 1
    unit_size = (NROW(all_datasets) %/% 100 / unit_perc)+1
    print(unit_size)
    
    #order the dataset by gene and aspect for index to make sense
    all_datasets = all_datasets[order(db_object_id,aspect)]
    out_uniq_data <- compile_nr_comp(all_datasets)
    out_data = out_uniq_data[,rm_red(.SD,aspect,db_object_id,go_obo,obs_and_alt,.I,unit_size,unit_perc,"Comp"),by=list(db_object_id,aspect)]

    #the columns will be reordered so make sure to reorder the columns for GAF 2.x specs
    setcolorder(out_data,gaf_cols)
    
    out_data[,assigned_by:="maize-GAMER"]
    
    #collapse the annotaions and combine assigned by
    write_gaf(out_data,out_gaf)
}


collapse_tools = function(data,db_object_id,term_accession,unit_size, idxs){
    print_dt_progress(unit_size,idxs)
    if(nrow(data)>1){
        out_data = data[1]
        out_data$assigned_by = paste(unique(data$assigned_by),collapse = ",")
        return(out_data)
    }else{
        return(data)
    }
}

compile_nr_comp = function(out_gaf){
    cat("Compiling Non-Redundant Comprehensive Data\n")
    gaf_col_order = colnames(out_gaf)
    out_gaf = out_gaf[order(db_object_id,term_accession)]
    unit_size = nrow(out_gaf) %/% 100
    comp_gaf = out_gaf[,collapse_tools(.SD,db_object_id,term_accession,unit_size,.I),by=list(db_object_id,term_accession)]
    setcolorder(comp_gaf,gaf_col_order)
    return(comp_gaf)
}
