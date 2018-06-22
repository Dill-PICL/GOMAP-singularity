get_robust = function(comp_data,obo){
    #comp_data="comp_data/maize_v3.comp.gaf"
    obo="obo/go.obo"
    
    #check if the obo object is available if not read go.obo file
    go_obo = check_obo_data(obo)
    obs_and_alt = c(unlist(go_obo$alt_id[go_obo$obsolete]),names(go_obo$obsolete[go_obo$obsolete]))
    
    #read all the datasets
    print(paste("Reading Comprehensive Dataset"))
    #comp_dataset = read_gaf(comp_data)
    comp_dataset = gaf_check_simple(go_obo,comp_data)
    
    #order the dataset by gene and aspect for index to make sense
    comp_dataset = comp_dataset[order(db_object_id,aspect,assigned_by)]
    
    
    # get the correct order of the columns for a gaf
    gaf_col_order = colnames(comp_dataset)
    
    #get the unit size to calculate progress
    unit_size = nrow(comp_dataset) %/% 100
    
    outfile = "comp_data/maize_v3.3tool.robust.gaf"
    maj_th = 3
    #generate out_gaf with consensus data
    out_gaf = comp_dataset[,get_simple_majority(.SD,aspect,db_object_id,.I,unit_size,go_obo,obs_and_alt,maj_th),by=list(db_object_id,aspect),]
    
    #the columns will be reordered so make sure to reorder the columns for GAF 2.x specs
    setcolorder(out_gaf,gaf_col_order)
    
    #write the outfile
    write_oufile(out_gaf,outfile)
    
    maj_th = 2
    outfile = "comp_data/maize_v3.2tool.robust.gaf"
    out_gaf = comp_dataset[,get_simple_majority(.SD,aspect,db_object_id,.I,unit_size,go_obo,obs_and_alt,maj_th),by=list(db_object_id,aspect),]
    setcolorder(out_gaf,gaf_col_order)
    out_gaf
    
    write_oufile(out_gaf,outfile)
}

get_simple_majority <- function(in_data,aspect,db_object_id,idxs,unit_size,go_obo,obs_and_alt,maj_th){
    #print(idxs)
    print_dt_progress(unit_size,idxs)
    num_tools = length(unique(in_data$assigned_by))
    
    if(num_tools>=maj_th){
        tryCatch({
            tool_ancestors = in_data[,list(term_accession=get_tool_ancestors(.SD,go_obo)),by=assigned_by]    
        },error = function(e){
            cat(db_object_id,aspect,"\n")
            stop(e)
        })
        
        tool_go_terms = tool_ancestors[,list(num_tools=length(unique(assigned_by))),by=term_accession][num_tools>=maj_th]
        #print(tool_go_terms)
        if(nrow(tool_go_terms)>0){
            nr_go_terms = get_minimal_set(tool_go_terms$term_accession,go_obo,obs_and_alt)
            assigned_by_txt = paste(unique(tool_ancestors[term_accession %in% nr_go_terms]$assigned_by),collapse = ",")
            out_data = data.table(cbind(in_data[1][,-c("term_accession","assigned_by"),with=F],assigned_by=assigned_by_txt,term_accession=nr_go_terms))
            return(out_data) 
        }else{
            return(NULL)   
        }
    }else{
        return(NULL)
    }
}

get_tool_ancestors = function(data,go_obo){
    root_nodes=c("GO:0003674",'GO:0005575','GO:0008150','GO:0005515')
    tmp_ancestors = get_ancestors(go_obo,data$term_accession)
    ancestors = setdiff(tmp_ancestors,root_nodes)
    return(ancestors)
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

write_oufile <- function(out_gaf,outfile){
    cat("Writing Complied Consensus Data to",outfile,"\n")
    write_gaf(out_gaf,outfile)
}
