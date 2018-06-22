library("data.table")
library("ggplot2")
library("reshape2")
library("tools")


read_data = function(type){
    inpath=paste(type,"/eval",sep="")
    tool_files = dir(inpath,recursive = T,full.names = T,pattern = "*.tdf")
    print(tool_files)
    
    tool_tmp = lapply(tool_files,function(x){
        tmp_data = fread(x)
        tmp_data = cbind(tmp_data,type=type)
    })
    
    tool_data = do.call(rbind,tool_tmp)
    print(tool_data)
    
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
    tool_fscore = tool_data[,list(fscore=calc_fscore(.SD)),by=list(tool,gene,ont)]
    return(tool_fscore)
}

get_avg_f_meas = function(tool_fscore){
    tool_th_fscore = tool_fscore[,list(avg_fscore=mean(fscore)),by=list(tool,ont)]
    return(tool_th_fscore)
}

plot_avg_f_score = function(tool_th_fscore,tool){
    p = ggplot(tool_th_fscore,aes(x=th,y=avg_fscore,fill=ont))
    p = p + geom_bar(stat = "identity") + xlab("Score") + ylab("Average F-Score")
    p = p + facet_grid(ont~.) + ggtitle(tool)
    p
}