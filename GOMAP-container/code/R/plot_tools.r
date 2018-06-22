library("data.table")
library("ggplot2")
library("reshape2")
library("tools")
library("scales")

aspect2one = function(aspect){
    tmp_list = list(MF="F",BP="P",CC="C")
    return(unlist(tmp_list[aspect]))
}

plot_disc = function(plot_data,tmp_measure,outfile,save_plot=T){
    print(tmp_measure)
    ppt_f = paste("plots/ppt/",outfile,".png",sep="")
    poster_f = paste("plots/",outfile,".png",sep="")
    lims = c(0,max(plot_data[measure==tmp_measure]$value*1.1))
    
    cbpallete = c("#a6d854","#fdcdac")
    p = ggplot(plot_data[measure==tmp_measure],aes(x=tool,y=value,fill=Type))
    p = p + geom_bar(stat="identity",color="#000000",size=0.5) #+ geom_errorbar()
    p = p + xlab("Dataset") + scale_y_continuous(expand=c(0,0),labels = comma,limits = lims)
    p = p + scale_fill_manual(values=cbpallete) + theme_bw() + ylab(measures[[tmp_measure]])
    p = p + facet_grid(.~aspect,scales = "free_y",labeller = labeller(aspect=aspect_lbl))
    p = p + theme(axis.text.x = element_text(angle=45,vjust = 1,hjust=1))
    print(p)
    if(save_plot){
        ggsave(ppt_f,width = 10.5,height=6,dpi=300)
        ggsave(poster_f,width = 10.5,height=3,dpi=300)    
    }
    
}

aspect_lbl = function(aspect){
    tmp_lbl = list(C="Cellular Component",P="Biological Process",F="Molecular Function")
    return(tmp_lbl[aspect])
}