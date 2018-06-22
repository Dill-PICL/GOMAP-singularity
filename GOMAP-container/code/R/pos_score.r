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

get_annot_sim_score = function(gene,aspect,data,unit_size,idx,unit_perc,tool_data_list,go_obo){
    
    print_dt_progress(unit_size,idx,unit_perc)
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
        
        if(F & gene==tmp_gene){
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
    
    tmp_gaf = gaf[,list(terms=tmp2list(db_object_id,aspect,unique(term_accession))),by=list(db_object_id,aspect)]
    
    list2list = function(gene,lists){
        out = list()
        out[[gene]] = unlist(lists,recursive = F)
        out
    }
    
    final_gaf = tmp_gaf[,list(final_list=list2list(db_object_id,terms)),by=db_object_id]
    final_list = final_gaf$final_list
    names(final_list) = final_gaf$db_object_id
    return(final_list)
}

get_tool_score = function(th,tool_data,gold_data,go_obo){
    back_buff = paste(rep(" ",16),collapse = "")
    cat("\nProcessing threshold:",th,"\n")
    
    
    
    tool_data_filt = tool_data[with>=as.numeric(th)]
    common_genes = unique(tool_data_filt[tool_data_filt$db_object_symbol %in% gold_data$db_object_symbol]$db_object_symbol)
    tool_data_filt = tool_data_filt[common_genes]
    if(NROW(tool_data_filt)>0){
        
        tool_data_filt = gaf_check_simple(go_obo,tool_data_filt)
        cat("Number of Rows ",NROW(tool_data_filt),"\n\n")
        cat(back_buff,"\n")
        #tool_data_filt = rm_gaf_red(tool_data_filt,go_obo)
        #cat(back_buff,"\n")
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
        
        
        tool_score_perf = gold_data[sort(common_genes),get_annot_sim_score(db_object_symbol,aspect,.SD,unit_size,.I,unit_perc,tool_data_list,go_obo),by=list(db_object_symbol,aspect)]
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
            tool_score_filt = cbind(tool_score_filt,th)
        }
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
    print(tool_score_filt)
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

filter_cafa = function(annot_file,gold_file,go_file,tool_name,num_cores=1){
    
    #make output names
    plot_name = paste("plots/annot_score_vs_eval-",tool_name,".png",sep="")
    tbl_name = paste("tables/max_scores-",tool_name,".csv",sep="")
    out_gaf_f = paste("red_data/maize_v3.",tool_name,".gaf",sep="")
    eval_tbl = paste("tables/maize_v3.aigo_eval.",tool_name,".csv",sep="")
    
    #set the cores to be used for mclapply
    mc.cores = getOption("mc.cores", num_cores)
    
    #check and read/load the go.obo file
    go_obo = check_obo_data(go_file)
    
    #read the tool data
    tool_data = read_gaf(annot_file)
    tool_data = gaf_check_simple(go_obo,tool_data)
    tool_data = tool_data[order(db_object_symbol,term_accession)]
    setkey(tool_data,db_object_symbol)
    
    #read the gold standard file
    gold = read_gaf(gold_file)
    setkey(gold,db_object_symbol)
    gold = gold[grep("GRMZM|AC",db_object_symbol)]
    #this line is to remove duplicate annotations with different evidence codes
    gold = gold[,.SD[1],by=list(db_object_symbol,term_accession)]
    setkey(gold,db_object_symbol)
    
    #create breaks to lapply for evaluation
    breaks=seq(0.0,1.0,0.05)
    
    #run the function to get the evaluation metric for each tool
    tmp_eval = mclapply(breaks,get_tool_score,tool_data=tool_data,gold_data=gold,go_obo=go_obo)
    tool_th_eval = do.call(rbind,tmp_eval)
    
    write.table(tool_th_eval,eval_tbl,quote = F,sep = "\t",row.names = F)
    
    #summarize the scores from each tool into a concise table
    #will calculate avg & max hPr hRc and fscores
    #this will get the values/gene
    tool_th_summary = get_tool_score_summary(tool_th_eval)
    
    hist(tool_th_summary[th==0]$avg_hPr)
    hist(tool_th_summary[th==0]$avg_hRc)
    
    #summarize the values for each aspect and th to get max values
    tool_avg_eval = tool_th_summary[,list(
        avg_fscore=mean(avg_fscore),
        max_fscore=mean(max_fscore),
        avg_hRc=mean(avg_hRc),
        avg_hPr=mean(avg_hPr),
        max_hPr=mean(max_hPr),
        max_hRc=mean(max_hRc)),
        by=list(aspect,th)]

    #melt the tool_avg_eval to get into a simple format for plotting and saving
    tool_avg_eval_melt  = melt(tool_avg_eval,id.vars = c("aspect","th"))
    
    #plot the eval values into a graph
    plot_name = paste("plots/annot_score_vs_eval-",tool_name,".png",sep="")
    p = ggplot(tool_avg_eval_melt,aes(x=th,y=value,color=variable))
    p = p + geom_line() + ylim(c(0,1))
    p = p + geom_point(size=1)
    p = p + facet_grid(aspect~.) + scale_color_brewer(type="qual")
    p
    ggsave(plot_name,width = 8.5,height = 11,units = "in")
    
    #get the max values and save it as a table
    max_metrix_score = tool_avg_eval_melt[,list(max_val=max(value),th=th[which.max(value)]),by=list(aspect,variable)]
    write.table(max_metrix_score,file = tbl_name,quote = F,sep = "\t",row.names = F)
    
    # max_metrix_score = fread("tables/max_scores-argot2.csv")
    # tool_data = read_gaf("cafa/argot2/argot2-0.0.gaf")
    tmp_gaf = lapply(unique(max_metrix_score$aspect),function(in_asp){
        score_th = max_metrix_score[aspect==in_asp & variable=="avg_fscore"]$th
        tool_data[aspect == in_asp & with >= score_th]
    })
    
    out_gaf = do.call(rbind,tmp_gaf)
    write_gaf(out_gaf,out_gaf_f)
    
}
