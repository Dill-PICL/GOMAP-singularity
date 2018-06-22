if(F){
    in_gaf <- "gaf/uniq/maize.B73.AGPv4.arabidopsis.gaf"
}
remove_redundancy = function(in_gaf,out_gaf,config){
    
    go_obo = check_obo_data(config$data$go$obo)
    obs_and_alt = c(unlist(go_obo$alt_id[go_obo$obsolete]),names(go_obo$obsolete[go_obo$obsolete]))
    # gaf_cols = fread(config$data$go$gaf_cols,sep = "\t",header = F)$V1
    
    print(paste("Reading",in_gaf))
    data = read_gaf(in_gaf)
    colnames(data) <- gaf_cols
    
    flog.info("Checking for anomalies for alt_ids and aspect before removing redundancy\n")
    data = gaf_check_simple(go_obo,data)
    
    flog.info(paste("Removing Redundancy from ",in_gaf))
    unit_perc = 1
    unit_size=nrow(data) %/% (100/unit_perc)
    #out_gaf = in_gaf[,rm_red(.SD,aspect,db_object_id,.I,total_rows,graph,obsolete_terms,alt_ids),by=list(aspect,db_object_id)]
    out_data = data[,rm_red(.SD,aspect,db_object_id,go_obo,obs_and_alt,.I,unit_size,unit_perc,in_gaf),by=list(aspect,db_object_id)]
    setcolorder(out_data,gaf_cols)
    
    print(paste("Writing NR of ",in_gaf, "to",out_gaf))
    write_gaf(out_data,out_gaf)
}

rm_gaf_red  = function(in_gaf,go_obo){
    back_buff = paste(rep("b",16),collapse = "")
    
    obs_and_alt = c(unlist(go_obo$alt_id[go_obo$obsolete]),names(go_obo$obsolete[go_obo$obsolete]))
    
    in_gaf = gaf_check_simple(go_obo,in_gaf)
    #cat(back_buff,"\n")
    gaf_col_order = colnames(in_gaf)
    
    unit_perc = 1
    unit_size=nrow(in_gaf) %/% (100/unit_perc)
    #out_gaf = in_gaf[,rm_red(.SD,aspect,db_object_id,.I,total_rows,graph,obsolete_terms,alt_ids),by=list(aspect,db_object_id)]
    out_gaf = in_gaf[,rm_red(.SD,aspect,db_object_id,go_obo,obs_and_alt,.I,unit_size,unit_perc),by=list(aspect,db_object_id)]
    setcolorder(out_gaf,gaf_col_order)
    
    return(out_gaf)
}

rm_red <- function(data,aspect,gene,go_obo,obs_and_alt,idxs,unit_size,unit_perc,tool_name){
    print_dt_progress(unit_size,idxs,unit_perc,tool_name)
    
    #leaf_terms = get_minimal_set(list(unique(data$term_accession)),graph,obsolete_terms,alt_ids)
    leaf_terms = get_minimal_set(list(unique(data$term_accession)),go_obo,obs_and_alt)
    return(unique(data[term_accession %in% leaf_terms]))
}

get_minimal_set = function(go_nodes,go_obo,obs_and_alt){
    go_nodes = unlist(go_nodes)
    root_nodes=c("GO:0003674",'GO:0005575','GO:0008150','GO:0005515')
    out_nodes = minimal_set(go_obo,go_nodes)
    out_nodes = out_nodes[!out_nodes %in% c(obs_and_alt,root_nodes)]
    return(out_nodes)
}