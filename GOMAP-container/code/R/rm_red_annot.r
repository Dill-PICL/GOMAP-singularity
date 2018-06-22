source("code/gaf_tools.r")
source("code/obo_tools.r")
source("code/gen_utils.r")
source("code/get_nr_dataset.r")

#in_args = commandArgs(trailingOnly = T)
datasets = fread("datasets.txt")
exist_dataset = fread("exist_datasets.txt")
datasets = rbind(datasets,exist_dataset)

obo_file="obo/go.obo"
proc_dts = datasets#[5:6]

tmp_out = apply(proc_dts,1,function(dataset){
    infile = paste("uniq_data/",dataset["file"],sep="")
    print(paste("Processing",dataset["dataset"]))
    remove_redundancy(infile,obo=obo_file)
})

print(warnings())

if(F){
    
    go_obo = check_obo_data("obo/go.obo")
    tmp_gaf = read_gaf("red_data/maize_v3.argot2.gaf")
    alt_idxs = tmp_gaf[,.I[tmp_gaf$term_accession %in% names(go_obo$alt_conv)],]
    out_gaf = tmp_gaf
    
    if(length(alt_idxs)>0){
        out_gaf$term_accession[alt_idxs]
        go_obo$alt_conv[out_gaf$term_accession[alt_idxs]]
        out_gaf$term_accession[alt_idxs] = unlist(go_obo$alt_conv[out_gaf$term_accession[alt_idxs]])
        namespace2aspect=list("molecular_function"="F","biological_process"="P","cellular_component"="C")
        length(go_obo$namespace[out_gaf$term_accession])
        tmp_aspect = unlist(namespace2aspect[unlist(go_obo$namespace[out_gaf$term_accession])])
        old_aspect = tmp_gaf$aspect
        out_gaf$aspect = tmp_aspect
    }
    
    out_gaf$evidence_code[out_gaf$evidence_code==""] = "IEA"
    head(tmp_gaf[out_gaf$aspect != old_aspect])
    head(out_gaf[out_gaf$aspect != old_aspect])
}