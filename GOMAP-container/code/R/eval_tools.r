library("data.table",quietly = T)
library("ggplot2",quietly = T)
library("reshape2",quietly = T)
library("tools",quietly = T)
#library("GOSemSim")
library("parallel",quietly = T)

source("code/obo_tools.r")
source("code/gen_utils.r")
source("code/gaf_tools.r")
source("code/get_robust.r")
source("code/get_nr_dataset.r")
source("code/aigo_tools.r")


eval_red_data <- function(annot_file,gold,go_obo){
    #make output names
    #plot_name = paste("plots/annot_score_vs_eval-",tool_name,".png",sep="")
    #tbl_name = paste("tables/max_scores-",tool_name,".csv",sep="")
    #out_gaf_f = paste("red_data/maize_v3.",tool_name,".gaf",sep="")
    if(F){
        annot_file="red_data/maize_v3.tair.all.gaf"
        tool_name = gsub("^.*maize_v3.","",annot_file)
        tool_name = gsub(".gaf$","",tool_name)
        go_file="obo/go.obo"
        gold_file="nr_data/gold.gaf"
    }
    
    tool_name = gsub("^.*maize_v3.","",annot_file)
    tool_name = gsub(".gaf$","",tool_name)
    eval_tbl = paste("tables/maize_v3.aigo_eval.",tool_name,".csv",sep="")
    
    cat("Evaluating ",tool_name,"\n")
    
    #read the tool data
    tool_data = read_gaf(annot_file)
    tool_data = gaf_check_simple(go_obo,tool_data)
    tool_data = tool_data[order(db_object_symbol,term_accession)]
    tool_data = tool_data[grep("AC|GRMZM",db_object_symbol)]
    setkey(tool_data,db_object_symbol)
    
    tool_data$with = as.numeric(tool_data$with)
    tool_data$with = 0
    
    #create breaks to lapply for evaluation
    tool_eval = get_tool_score(0,tool_data,gold,go_obo,tool_name)
    print(tool_eval)
    #summarize the scores from each tool into a concise table
    #will calculate avg & max hPr hRc and fscores
    #this will get the values/gene
    tool_th_summary = get_tool_score_summary(tool_eval)
    
    
    breaks = seq(0.0,1.0,0.05)
    
    breaks = unlist(lapply(breaks,rep,times=nrow(tool_th_summary)))
    
    tool_th_summary_th = cbind(tool_th_summary[,-c("th"),with=F],th=breaks)

    write.table(tool_th_summary_th,eval_tbl,quote = F,sep = "\t",row.names = F)
    return(tool_th_summary_th)
}

eval_nr <- function(annot_file,gold,go_obo){
    #make output names
    #plot_name = paste("plots/annot_score_vs_eval-",tool_name,".png",sep="")
    #tbl_name = paste("tables/max_scores-",tool_name,".csv",sep="")
    #out_gaf_f = paste("red_data/maize_v3.",tool_name,".gaf",sep="")
    if(F){
        annot_file="red_data/maize_v3.tair.all.gaf"
        tool_name = gsub("^.*maize_v3.","",annot_file)
        tool_name = gsub(".gaf$","",tool_name)
        go_file="obo/go.obo"
        gold_file="nr_data/gold.gaf"
    }
    
    tool_name = gsub("^.*maize_v3.","",annot_file)
    tool_name = gsub(".gaf$","",tool_name)
    eval_tbl = paste("tables/maize_v3.aigo_eval.",tool_name,".csv",sep="")
    
    cat("Evaluating ",tool_name,"\n")
    
    #read the tool data
    tool_data = read_gaf(annot_file)
    tool_data = gaf_check_simple(go_obo,tool_data)
    tool_data = tool_data[order(db_object_symbol,term_accession)]
    tool_data = tool_data[grep("AC|GRMZM",db_object_symbol)]
    setkey(tool_data,db_object_symbol)
    
    tool_data$with = as.numeric(tool_data$with)
    tool_data$with = 0
    
    #create breaks to lapply for evaluation
    tool_eval = get_tool_score(0,tool_data,gold,go_obo,tool_name)
    #summarize the scores from each tool into a concise table
    #will calculate avg & max hPr hRc and fscores
    #this will get the values/gene
    tool_th_summary = get_tool_score_summary(tool_eval)
    
    print(paste("Writing evaluation results to",eval_tbl))
    write.table(tool_th_summary,eval_tbl,quote = F,sep = "\t",row.names = F)
    return(tool_th_summary)
}

eval_sample <- function(annot_file,gold,go_obo){
    #make output names
    #plot_name = paste("plots/annot_score_vs_eval-",tool_name,".png",sep="")
    #tbl_name = paste("tables/max_scores-",tool_name,".csv",sep="")
    #out_gaf_f = paste("red_data/maize_v3.",tool_name,".gaf",sep="")
    if(F){
        annot_file="red_data/maize_v3.tair.all.gaf"
        tool_name = gsub("^.*maize_v3.","",annot_file)
        tool_name = gsub(".gaf$","",tool_name)
        go_file="obo/go.obo"
        gold_file="nr_data/gold.gaf"
    }
    
    tool_name = gsub("^.*maize_v3.","",annot_file)
    tool_name = gsub(".gaf$","",tool_name)
    eval_tbl = paste("bootstrap/maize_v3.aigo_eval.",tool_name,".csv",sep="")
    
    cat("Evaluating ",tool_name,"\n")
    
    #read the tool data
    tool_data = read_gaf(annot_file)
    tool_data = gaf_check_simple(go_obo,tool_data)
    tool_data = tool_data[order(db_object_symbol,term_accession)]
    tool_data = tool_data[grep("AC|GRMZM",db_object_symbol)]
    setkey(tool_data,db_object_symbol)
    
    tool_data$with = as.numeric(tool_data$with)
    tool_data$with = 0
    
    
    tmp_gold_counts = gold[,list(count=.N),by=list(aspect)]
    min_cnt = min(tmp_gold_counts$count)
    num_iters = 1000
    tmp_evals = lapply(1:num_iters,function(y){
        tmp_asp_samples = lapply(tmp_gold_counts$aspect,function(x){
            asp_cnt = NROW(gold[aspect==x])
            sample_idx = sample.int(asp_cnt,min_cnt,replace = T)
            asp_sample = gold[aspect==x][sample_idx]
        })
        
        gold_sample = data.table(do.call(rbind,tmp_asp_samples))
        setkey(gold_sample,db_object_symbol)
        
        #create breaks to lapply for evaluation
        tool_eval = get_tool_score(0,tool_data,gold_sample,go_obo,tool_name)
        #summarize the scores from each tool into a concise table
        #will calculate avg & max hPr hRc and fscores
        #this will get the values/gene
        tool_th_summary = get_tool_score_summary(tool_eval)
        tool_th_summary = cbind(tool_th_summary,sample=paste("Sample-",y,sep=""))
    })
    
    all_evals = do.call(rbind,tmp_evals)
    print(paste("Writing evaluation results to",eval_tbl))
    write.table(all_evals,eval_tbl,quote = F,sep = "\t",row.names = F)
    all_evals = cbind(all_evals,dataset=tool_name)
    return(all_evals)
}