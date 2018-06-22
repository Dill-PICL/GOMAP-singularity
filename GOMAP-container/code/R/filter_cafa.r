library("data.table")
library("ggplot2")
library("reshape2")
library("tools")
#library("GOSemSim")
library("parallel")

source("code/R/obo_tools.r")
source("code/R/gen_utils.r")
source("code/R/gaf_tools.r")
source("code/R/get_nr_dataset.r")
source("code/R/aigo_tools.r")


read_data = function(tool){
    inpath=paste("eval/",tool,sep="")
    tool_files = dir(inpath,recursive = T,full.names = T)
    print(tool_files) 
    tool_tmp = lapply(tool_files,function(x){
        th = as.numeric(gsub(".+-|.tdf","",basename(x)))
        tmp_data = fread(x)
        tmp_data = cbind(tmp_data,th)
    })
    tool_data = do.call(rbind,tool_tmp)
    
    tool_fscore = get_f_meas(tool_data)
    #tool_fscore = cbind("tool"=tool,tool_fscore)
    
    tool_th_fscore = get_avg_f_meas(tool_fscore)
    #tool_th_fscore = cbind("tool"=tool,tool_th_fscore)
    
    return(list("data"=tool_data,"fscore"=tool_fscore,"avg_fscore"=tool_th_fscore))
}

get_f_meas = function(tool_data){
    calc_fscore = function(data){
        pr = as.numeric(data[metric=="precision"]$value)
        pr = ifelse(pr<0,0,pr)
        rc = as.numeric(data[metric=="recall"]$value)
        rc = ifelse(rc<0,0,rc)
        if(pr+rc>0)
            return(2*(pr*rc)/(pr+rc))
        else
            return(0)
    }
    tool_fscore = tool_data[,list(fscore=calc_fscore(.SD)),by=list(tool,gene,ont,th)]
    return(tool_fscore)
}

get_avg_f_meas = function(tool_fscore){
    tool_th_fscore = tool_fscore[,list(avg_fscore=mean(fscore)),by=list(tool,th,ont)]
    
    return(tool_th_fscore)
}

plot_avg_f_score = function(tool_th_fscore,tool){
    p = ggplot(tool_th_fscore,aes(x=th,y=avg_fscore,fill=ont))
    p = p + geom_bar(stat = "identity") + xlab("Score") + ylab("Average F-Score")
    p = p + facet_grid(ont~.) + ggtitle(tool)
    p
}

filter_cafa = function(annot_file,gold_file,go_file,tool_name,num_cores=1){
    
    #make output names
    plot_name = paste("plots/annot_score_vs_eval-",tool_name,".png",sep="")
    eval_tbl = paste("tables/maize_v3.aigo_eval.",tool_name,".csv",sep="")
    tbl_name = paste("tables/max_scores-",tool_name,".csv",sep="")
    out_gaf_f = paste("raw_data/maize_v3.",tool_name,".gaf",sep="")
    
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
    print(unique(tool_th_eval$th))
    write.table(tool_th_eval,eval_tbl,quote = F,sep = "\t",row.names = F)
    
    #summarize the scores from each tool into a concise table
    #will calculate avg & max hPr hRc and fscores
    #this will get the values/gene
    tool_th_summary = get_tool_score_summary(tool_th_eval)
    
    write.table(tool_th_summary,eval_tbl,quote = F,sep = "\t",row.names = F)
    
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
        print(in_asp)
        print(dim(tool_data[aspect == in_asp & with >= score_th]))
        tool_data[aspect == in_asp & with >= score_th]
    })
    
    out_gaf = do.call(rbind,tmp_gaf)
    out_gaf$with = as.character(out_gaf$with)
    out_gaf$with = ""
    print(dim(out_gaf))
    write_gaf(out_gaf,out_gaf_f)
}
