source("code/get-rbh.r")
source("code/gaf_tools.r")
library("data.table",quietly = T)
gaf_cols <- fread("misc/gaf_cols.txt",header=F)$V1

if(F){
    rbh_file <- "blast_out/maize_v3_vs_tair10.rbh.txt"
    gaf_file <- "arab/ATH_GO_GOSLIM.txt"
    out_file <- "datasets/blast/mz_tair10_go.txt"
    out_cafa <- "datasets/blast/mz_tair10_go.cafa.txt"
}

assign_tair_go <- function(rbh_data,gaf_file,out_file,out_cafa,hc=T){
    rbh_hits <- fread(rbh_file,header = F,sep = "\t")
    colnames(rbh_hits) <- c("maize","arab")
    
    rbh_hits$maize <- gsub("_P[0-9]+","",rbh_hits$maize)
    rbh_hits$maize <- gsub("FGP","FG",rbh_hits$maize)
    rbh_hits$arab  <- gsub("\\.[0-9]+","",rbh_hits$arab)
    
    tair_gaf_cols <- c("locus","tair_accession","object_name","rel_type","go_term","go_id","tair_kw_id","aspect","goslim_term","ev_code","ev_desc","ev_with","ref","source","date")
    arab_gaf <- fread(gaf_file,header = F,sep = "\t",quote = "",stringsAsFactors = F)
    colnames(arab_gaf) <- tair_gaf_cols
    
    arab_gaf <- data.table(arab_gaf)
    
    print(hc)
    
    if(hc){
        arab_gaf_hc <- arab_gaf[ev_code != "IEA" & ev_code != "ND" & ev_code != "NAS"]    
    }else{
        arab_gaf_hc = arab_gaf
    }
    arab_gaf_hc <- arab_gaf_hc[grep("AT",arab_gaf_hc$locus)]
    setkey(arab_gaf_hc,locus)
    
    
    tmp_out <- apply(rbh_hits,1,function(x){
        tmp_dt <- arab_gaf_hc[x[2],nomatch=0]
        if(dim(tmp_dt)[1]>0){
            cbind(x[1],tmp_dt$locus,tmp_dt$go_id,tmp_dt$aspect,tmp_dt$ev_code,tmp_dt$rel_type)
        }
    })
    out_table <- do.call(rbind,tmp_out)
    colnames(out_table) <- c("maize_gene","arab_gene","go_id","aspect","ev_code","rel_type")
    out_table <- data.table(out_table)
    setkeyv(out_table,c("maize_gene","go_id"))
    out_table <- unique(out_table)
    out_dir <- gsub("\\/[^/]+$","",out_file)
    ifelse(!dir.exists(out_dir),dir.create(out_dir),paste(out_dir,"already exists so not creating one"))
    write.table(out_table,out_file,quote = F,sep = "\t",row.names = F)
    write.table(out_table[,c(1,3,4),with=F],out_cafa,quote = F,sep = "\t",row.names = F)
}

