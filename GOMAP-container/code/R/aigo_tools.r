ont_conv = list(C="CC",F="MF",P="BP")
tmp_gene = ""

get_max_sim = function(gene,in_aspect,data){
    
    gold_dt = gold[gene][aspect==in_aspect,nomatch=0]
    out_list = list(max=-1,average=-1)
    if(NROW(gold_dt)>0){
        #print(data$term_accession)
        #print(gold_dt$term_accession)
        out_list$max = mgoSim(data$term_accession,gold_dt$term_accession,organism = "Arabidopsis",measure = "Wang", ont = ont_conv[[in_aspect]],combine = "max")
        if(NROW(gold_dt) > 1){
            out_list$average = mgoSim(data$term_accession,gold_dt$term_accession,organism = "Arabidopsis",measure = "Wang", ont = ont_conv[[in_aspect]],combine = "avg")    
        }else{
            out_list$average = out_list$max
        }
    }
    return(out_list)
}

get_hPr_hRc = function(gold_ans,tool_term){
    #gold_ans = unique(unlist(go_obo$ancestors[gold_term]))
    tool_ans =  unique(unlist(go_obo$ancestors[tool_term]))
    hPr = length(intersect(tool_ans,gold_ans))/length(tool_ans)
    hRc = length(intersect(tool_ans,gold_ans))/length(gold_ans)
    return(list(hPr=hPr,hRc=hRc))
}

get_hPr = function(tool_term,gold_terms,go_obo){
    tool_ns = go_obo$namespace[[tool_term]]
    tool_ans = unique(unlist(go_obo$ancestors[tool_term]))
    #tool_ans = tool_ans[go_obo$namespace[tool_ans] == tool_ns]
    tool_ans = intersect(tool_ans,go_obo$ns2go[[tool_ns]])
    tmp_list = lapply(gold_terms,function(term){
        gold_ans = unique(unlist(go_obo$ancestors[term]))
        #gold_ans = gold_ans[go_obo$namespace[gold_ans] == tool_ns]
        gold_ans = intersect(gold_ans,go_obo$ns2go[[tool_ns]])
        hPr = length(intersect(tool_ans,gold_ans))/length(tool_ans)
        return(hPr)
    })
    return(unlist(tmp_list))
}

get_hRc = function(gold_term,tool_terms,go_obo){
    tool_ns = go_obo$namespace[[gold_term]]
    gold_ans = unique(unlist(go_obo$ancestors[gold_term]))
    #gold_ans = gold_ans[go_obo$namespace[gold_ans] == tool_ns]
    gold_ans = intersect(gold_ans,go_obo$ns2go[[tool_ns]])
    tmp_list = lapply(tool_terms,function(term){
        tool_ans = unique(unlist(go_obo$ancestors[term]))
        #tool_ans = tool_ans[go_obo$namespace[tool_ans] == tool_ns]
        tool_ans = intersect(tool_ans,go_obo$ns2go[[tool_ns]])
        hRc = length(intersect(tool_ans,gold_ans))/length(gold_ans)
        return(hRc)
    })
    return(unlist(tmp_list))
}

get_annot_sim_score = function(gene,aspect,data,unit_size,idx,unit_perc,tool_data_list,go_obo,tool_name){
    
    print_dt_progress(unit_size,idx,unit_perc,tool_name)
    out_list = list(score=-1,hPr=-1,hRc=-1,max_hPr=-1,max_hRc=-1)
    #gold_ans = unique(unlist(go_obo$ancestors[gold_term]))
    
    tool_terms = unlist(unique(tool_data_list[[gene]][[aspect]]))
    gold_terms = unlist(unique(data$term_accession))
    
    #if(nrow(gold_dt)>0 | !is.null(gold_terms)){
    
    if(length(gold_terms) > 0 & length(tool_terms)>0){
        
        gold_terms = minimal_set(go_obo,unlist(unique(data$term_accession)))
        tool_terms = minimal_set(go_obo,unlist(tool_data_list[[gene]][[aspect]]))
        
        hPrs = lapply(tool_terms,function(term){
            get_hPr(term,gold_terms,go_obo)
        })
        
        out_list$hPr = mean(unlist(lapply(hPrs,mean)))
        out_list$max_hPr = mean(unlist(lapply(hPrs,max)))
        
        hRcs = lapply(gold_terms,function(term){
            get_hRc(term,tool_terms,go_obo)
        })
        
        out_list$hRc = mean(unlist(lapply(hRcs,mean)))
        out_list$max_hRc = mean(unlist(lapply(hRcs,max)))
        
        if(F & aspect!="C"){
            print(aspect)
            print(gold_terms)
            print(tool_terms)
            print(hPrs)
            print(hRcs)
        }
    }
    
    out_list = lapply(out_list,function(x){
        ifelse(is.na(x),-1,x)
    })
    return(out_list)
}

gaf2list = function(gaf){
    
    tmp2list = function(gene,aspect,terms){
        out = list()
        out[[gene]] = list()
        out[[gene]][[aspect]] = terms
        return(out)
    }
    
    tmp_gaf = gaf[,list(terms=tmp2list(db_object_symbol,aspect,unique(term_accession))),by=list(db_object_symbol,aspect)]
    
    list2list = function(gene,lists){
        out = list()
        out[[gene]] = unlist(lists,recursive = F)
        out
    }
    
    final_gaf = tmp_gaf[,list(final_list=list2list(db_object_symbol,terms)),by=db_object_symbol]
    final_list = final_gaf$final_list
    names(final_list) = final_gaf$db_object_symbol
    return(final_list)
}

get_tool_score = function(th,tool_data,gold_data,go_obo,tool_name="data"){
    back_buff = paste(rep(" ",16),collapse = "")
    cat("\nProcessing threshold:",th,"for",tool_name,"\n")
    
    tool_data_filt = tool_data[with>=as.numeric(th)]
    common_genes = unique(tool_data_filt[tool_data_filt$db_object_symbol %in% gold_data$db_object_symbol]$db_object_symbol)
    tool_data_filt = tool_data_filt[common_genes]
    if(NROW(tool_data_filt)>0){
        tool_data_filt = gaf_check_simple(go_obo,tool_data_filt)
        setkey(tool_data_filt,db_object_symbol)
        tool_data_list = gaf2list(tool_data_filt)
        rownames(tool_data_filt) = NULL
        
        cat("Number of Rows ",NROW(tool_data_filt),"\n\n")
        cat(back_buff,"\n")
        
        
        unit_perc = 1
        unit_size = nrow(gold_data) %/% (100/unit_perc)
        
        if(F){
            th = 0.05
            gold_data = gold    
            tools_data$argot2$data[th==0.05][gene=="4577.AC182617.3_FG001"]
            tool_data[db_object_symbol == "AC182617.3_FG001"][with>=0.05]
            tool_score_perf[order(db_object_symbol)][db_object_symbol == "AC182617.3_FG001"]
        }
        
        
        tool_score_perf = gold_data[sort(common_genes),get_annot_sim_score(db_object_symbol,aspect,.SD,unit_size,.I,unit_perc,tool_data_list,go_obo,tool_name),by=list(db_object_symbol,aspect)]
        #tool_score_perf = tool_data_filt[sort(com_genes),get_annot_sim_score(db_object_symbol,term_accession,.SD,unit_size,.I,unit_perc),by=list(db_object_symbol,term_accession)]
        tool_score_filt = tool_score_perf[tool_score_perf[, .I[hPr > -1 & hRc > -1 & max_hPr > -1 & max_hRc > -1],]]
        #tool_score_filt = tool_score_perf
        #tool_score_filt[,fscore:=ifelse(hPr==0 & hRc==0,0,2*(hPr*hRc)/(hPr+hRc))]
        no_annot_idxs = which(!gold_data$db_object_symbol %in% tool_score_filt$db_object_symbol)
        #no_annot_idxs = which(!paste(gold_data$db_object_symbol,gold_data$term_accession)  %in% paste(tool_score_filt$db_object_symbol,tool_score_filt$term_accession) )
        if(length(no_annot_idxs)>0){
            no_annot = gold_data[no_annot_idxs,.(db_object_symbol,aspect)]
            no_annot = unique(no_annot)
            tool_score_filt = rbind(tool_score_filt,cbind(no_annot,score=0,hPr=0,hRc=0,max_hPr=0,max_hRc=0))
        }
        tool_score_filt = cbind(tool_score_filt,th)
    }else{
        no_annot_idxs = which(!gold_data$db_object_symbol %in% tool_data_filt$db_object_symbol)
        no_annot = gold_data[no_annot_idxs,.(db_object_symbol,aspect)]
        no_annot = unique(no_annot)
        tool_score_filt = cbind(no_annot,score=0,hPr=0,hRc=0,max_hPr=0,max_hRc=0)
        tool_score_filt = cbind(tool_score_filt,th)
    }
    
    return(tool_score_filt)
}

get_tool_score_summary = function(tool_score_filt){
    tool_score_summary = tool_score_filt[,
                                         list(max_hPr=max(max_hPr),
                                              max_hRc=max(max_hRc),
                                              avg_hPr=mean(hPr),
                                              avg_hRc=mean(hRc)
                                         ),
                                         by=list(db_object_symbol,aspect,th)]
    tool_score_summary[,avg_fscore := ifelse(avg_hPr==0 & avg_hRc==0,0,2*(avg_hPr*avg_hRc)/(avg_hPr + avg_hRc))]
    tool_score_summary[,max_fscore := ifelse(max_hPr==0 & max_hRc==0,0,2*(max_hPr*max_hRc)/(max_hPr + max_hRc))]
    #tool_th_fscore = tool_score_summary[,list(avg_fscore=mean(avg_fscore),max_fscore=mean(max_fscore)),by=list(aspect)]
    return(tool_score_summary)
}

summarize_aspect_th <- function(tool_th_summary){
    tool_avg_eval = tool_th_summary[,list(
        avg_fscore=mean(avg_fscore),
        max_fscore=mean(max_fscore),
        avg_hRc=mean(avg_hRc),
        avg_hPr=mean(avg_hPr),
        max_hPr=mean(max_hPr),
        max_hRc=mean(max_hRc)),
        by=list(aspect,th)]
    return(tool_avg_eval)
}

read_measures = function(x,basedir){
    in_file = paste(basedir,x["file"],sep = "")
    in_file = gsub("gaf","tdf",in_file)
    in_dt = fread(in_file)
    in_dt = cbind(dataset=x["dataset"],stage=dirname(basedir),in_dt)
    return(in_dt)
}