source("code/gaf_tools.r")

reduce_nr_data <- function(annot_file,gold){
    tool_data = read_gaf(annot_file)
    tool_data = gaf_check_simple(go_obo,tool_data)
    tool_data = tool_data[order(db_object_symbol,term_accession)]
    tool_data = tool_data[grep("AC|GRMZM",db_object_symbol)]
    setkey(tool_data,db_object_symbol)
    
    tool_data$with = as.numeric(tool_data$with)
    tool_data$with = 0
    
    red_tool_data = tool_data[db_object_symbol %in% gold$db_object_symbol]
    gaf_cols = fread("../gaf_cols.txt",header = F)$V1
    outfile = gsub("nr_data","sample_data",annot_file)
    write_gaf(red_tool_data,outfile)
    return(outfile)
}