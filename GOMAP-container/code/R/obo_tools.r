library("ontologyIndex",quietly = T)
library("data.table",quietly = T)

check_obo_data = function(obo){
    obo_data = paste(obo,".data",sep="")
    
    print(paste("Checking if ", obo_data," exists", sep=""))
    if(file.exists(obo_data)){
        print(paste(obo_data," exists so loading R object", sep=""))
        print(system.time({
            load(obo_data)
        }))
        
    }else{
        print(paste("", obo_data," does not exist. So reading ",obo," and saving the R object", sep=""))
        print(paste("Reading",obo))
        print(system.time({
            go_obo = get_ontology(obo,propagate_relationships = c("is_a","part_of"),extract_tags="everything")
        }))
        alt_conv = get_alt_id(go_obo)
        go_obo$alt_conv = alt_conv
        go_obo$ns2go = get_ns2go(go_obo)
        go_obo$aspect = get_aspect(go_obo)
        save(go_obo,file=obo_data)
    }
    
    return(go_obo)
}

get_alt_id = function(go_obo){
    print("Getting a data.table to convert alt_id to main go_ids")
    print(system.time({tmp_alt = mapply(function(x,y){
        if(length(y)>0){
            tmp_out = cbind(main=data.table(x),alt_term=y)
        }
    },names(go_obo$alt_id),go_obo$alt_id)
    
    tmp_alt_dt = data.table(do.call(rbind,tmp_alt))
    colnames(tmp_alt_dt) = c("main_term","alt_term")}))
    
    out_list = as.list(tmp_alt_dt$main_term)
    names(out_list) = tmp_alt_dt$alt_term
    
    return(out_list)
}

get_ns2go = function(go_obo){
    tmp_ns = data.table(cbind(go_term=names(go_obo$namespace),ns=go_obo$namespace))[grep("GO",go_term)]
    tmp_ns
    ns2id = lapply(unique(tmp_ns$ns),function(in_ns){
        unlist(tmp_ns[ns==in_ns]$go_term)
    })
    names(ns2id) = unique(tmp_ns$ns)
    return(ns2id)
}

get_aspect = function(go_obo){
    ns2aspect=list(molecular_function="F",biological_process="P",cellular_component="C")
    go_ns2aspect = ns2aspect[unlist(obo_data$namespace)]
    names(go_ns2aspect) = names(go_obo$namespace)
    alt2aspect = ns2aspect[unlist(go_obo$namespace[unlist(go_obo$alt_conv)])]
    names(alt2aspect) = names(go_obo$alt_conv)
    all2aspect = c(go_ns2aspect,alt2aspect)
    return(all2aspect)
}



plot_go_graph = function(gene,go_term,dot_file){
    print(go_term)
    ns = unique(unlist(go_obo$namespace[go_term]))
    rel_colors = list(is_a="blue",part_of="red")
    cat("digraph G{\n",file = dot_file)
    cat("rankdir = BT\n",file = dot_file,append=T)
    cat('node[shape=box]\n',file = dot_file,append=T)
    #term_ans = go_obo$ancestors[[go_term]]
    term_ans = unique(unlist(go_obo$ancestors[go_term]))
    null_node = lapply(term_ans,function(x){
        tmp_node = paste("\"",x,"\"","[label=\"",x,"\n",go_obo$name[[x]],"\"]\n",sep="")
        cat(tmp_node,file = dot_file,append = T)
    })
    
    rel_list = lapply(term_ans,function(x){
        tmp_rel = go_obo$is_a[[x]]
        tmp_dt = NULL
        if(length(tmp_rel)>0){
            tmp_dt = cbind(child=x,parent=tmp_rel,rel="is_a")
        }
        
        if(sum(ns == "cellular_component")){
            tmp_part = go_obo$part_of[[x]]
            if(length(tmp_part)>0){
                tmp_part_dt = cbind(child=x,parent=tmp_part,rel="part_of")
                tmp_dt = rbind(tmp_dt,tmp_part_dt)
            }
        }
        tmp_dt
    })
    
    rel_dt = data.table(do.call(rbind,rel_list))
    
    null_rel = apply(rel_dt[child %in% term_ans],1,function(x){
        cat(sprintf('"%s" -> "%s" [color="%s"]',x["child"],x["parent"],rel_colors[[x["rel"]]]),file = dot_file,append=T)
    })
    
    cat("\n}",file = dot_file,append = T)
}

plot_go_overlap = function(gene,gold_terms,tool_terms,dot_file){
    print(go_term)
    ns = unique(unlist(go_obo$namespace[go_term]))
    print(ns)
    #rel_colors = list(is_a="blue",part_of="red")
    rel_colors = list(is_a="black",part_of="black")
    cat("digraph G{\n",file = dot_file)
    cat("\trankdir = BT\n",file = dot_file,append=T)
    cat('\tnode[shape=box,style=filled]\n',file = dot_file,append=T)
    
    #term_ans = go_obo$ancestors[[go_term]]
    gold_ans = unique(unlist(go_obo$ancestors[gold_terms]))
    term_ans = unique(unlist(go_obo$ancestors[tool_terms]))
    all_nodes = unique(c(gold_ans,term_ans))
    
    overlap = intersect(gold_ans,term_ans)
    tool_uniq = setdiff(term_ans,gold_ans)
    gold_uniq = setdiff(gold_ans,term_ans)
    
    
    #cat("\tsubgraph cluster_overlap{\n",file = dot_file,append=T)
    #cat('\t\tnode[style=filled,color="#b3e2cd"]\n',file = dot_file,append=T)
    null_node = lapply(overlap,function(x){
        print_dot_node(x,go_obo,dot_file,color="#b3e2cd")
    })
    #cat("\t}",file = dot_file,append=T)
    
    #cat("\tsubgraph cluster_tool_uniq{\n",file = dot_file,append=T)
    #cat('\t\tnode[style=filled,color="#fdcdac"]\n',file = dot_file,append=T)
    null_node = lapply(tool_uniq,function(x){
        print_dot_node(x,go_obo,dot_file,color="#fdcdac")
    })
    #cat("\t}\n",file = dot_file,append=T)
    
    #cat("\tsubgraph cluster_gold_uniq{\n",file = dot_file,append=T)
    #cat('\tnode[style=filled,color="#cbd5e8"]\n',file = dot_file,append=T)
    null_node = lapply(gold_uniq,function(x){
        print_dot_node(x,go_obo,dot_file,color="#cbd5e8")
    })
    #cat("\t}",file = dot_file,append=T)
    
    rel_list = lapply(all_nodes,function(x){
        tmp_rel = go_obo$is_a[[x]]
        tmp_dt = NULL
        if(length(tmp_rel)>0){
            tmp_dt = cbind(child=x,parent=tmp_rel,rel="is_a")
        }
        
        if(sum(ns == "cellular_component")){
            tmp_part = go_obo$part_of[[x]]
            if(length(tmp_part)>0){
                print(x)
                tmp_part_dt = cbind(child=x,parent=tmp_part,rel="part_of")
                print(tmp_part_dt)
                tmp_dt = rbind(tmp_dt,tmp_part_dt)
            }
        }
        tmp_dt
    })
    
    rel_dt = data.table(do.call(rbind,rel_list))
    
    null_rel = apply(rel_dt,1,function(x){
        cat(sprintf('"%s" -> "%s" [color="%s"]\n',x["child"],x["parent"],rel_colors[[x["rel"]]]),file = dot_file,append=T)
    })
    
    cat("\n}",file = dot_file,append = T)
    
}

print_dot_node = function(node,go_obo,dot_file,color="#fdcdac"){
    tmp_node = paste("\t\t\"",node,"\"","[label=<",node," <br/> ",go_obo$name[[node]],'>,color="',color,'"]\n',sep="")
    cat(tmp_node,file = dot_file,append = T)
}

if(F){
    
    tool_perf[1]
    tmp_perf = tool_perf[avg_fscore == 0.5][1]
    gene=tmp_perf$db_object_symbol
    tmp_aspect=tmp_perf$aspect
    gold_terms = gold[db_object_symbol == gene & aspect == tmp_aspect]$term_accession
    tool_terms = tool_data[db_object_symbol == gene & aspect %in% tmp_aspect]$term_accession
    go_term=tool_terms
    dot_file="go_plots/tmp.dot"
    #plot_go_overlap(tmp_gene,gold_terms,tool_terms,dot_file)
    plot_go_illus(tmp_gene,gold_terms,tool_terms,dot_file)
}

plot_go_illus = function(gene,ns,gold_terms,tool_term,dot_file,title){
    
    #rel_colors = list(is_a="blue",part_of="red")
    rel_colors = list(is_a="black",part_of="black")
    cat("digraph G{\n",file = dot_file)
    cat("\ttype = fdp\n",file = dot_file,append=T)
    cat("\trankdir = BT\n",file = dot_file,append=T)
    cat("\tranksep = 0.1\n",file = dot_file,append=T)
    cat('\tlabel=""\n',file = dot_file,append=T)
    cat('\tnode[shape=circle,style=filled]\n',file = dot_file,append=T)
    #term_ans = go_obo$ancestors[[go_term]]
    gold_ans = unique(unlist(go_obo$ancestors[gold_terms]))
    term_ans = unique(unlist(go_obo$ancestors[tool_term]))
    all_nodes = unique(c(gold_ans,term_ans))
    
    overlap = intersect(gold_ans,term_ans)
    tool_uniq = setdiff(term_ans,gold_ans)
    gold_uniq = setdiff(gold_ans,term_ans)
    print(gold_uniq)
    
    #cat("\tsubgraph cluster_overlap{\n",file = dot_file,append=T)
    #cat('\t\tnode[style=filled,color="#b3e2cd"]\n',file = dot_file,append=T)
    null_node = lapply(overlap,function(x){
        if(x %in% tool_term | x %in% gold_terms){
            leaf = "DG*"    
        }else{
            leaf = "DG"
        }
        
        print_metric_node(x,go_obo,dot_file,color="#b3e2cd",leaf)
    })
    #cat("\t}",file = dot_file,append=T)
    
    #cat("\tsubgraph cluster_tool_uniq{\n",file = dot_file,append=T)
    #cat('\t\tnode[style=filled,color="#fdcdac"]\n',file = dot_file,append=T)
    null_node = lapply(tool_uniq,function(x){
        if(x %in% tool_term){
            leaf = "D*"
            
        }else{
            leaf = "D"
        }
        
        print_metric_node(x,go_obo,dot_file,color="#cbd5e8",leaf)
    })
    #cat("\t}\n",file = dot_file,append=T)
    
    #cat("\tsubgraph cluster_gold_uniq{\n",file = dot_file,append=T)
    #cat('\tnode[style=filled,color="#cbd5e8"]\n',file = dot_file,append=T)
    null_node = lapply(gold_uniq,function(x){
        if(x %in% gold_terms){
            leaf = "G*"
        }else{
            leaf = "G"    
        }
        
        print_metric_node(x,go_obo,dot_file,color="#fdcdac",leaf)
    })
    #cat("\t}",file = dot_file,append=T)
    
    rel_list = lapply(all_nodes,function(x){
        tmp_rel = go_obo$is_a[[x]]
        tmp_dt = NULL
        if(length(tmp_rel)>0){
            tmp_dt = cbind(child=x,parent=tmp_rel,rel="is_a")
        }
        
        #if(sum(ns == "cellular_component")){
        if(sum(ns != "")){
            tmp_part = go_obo$part_of[[x]]
            if(length(tmp_part)>0){
                tmp_part_dt = cbind(child=x,parent=tmp_part,rel="part_of")
                tmp_dt = rbind(tmp_dt,tmp_part_dt)
            }
        }
        tmp_dt
    })
    
    rel_dt = data.table(do.call(rbind,rel_list))
    
    null_rel = apply(rel_dt,1,function(x){
        cat(sprintf('\t\t"%s" -> "%s" [color="%s"]\n',x["child"],x["parent"],rel_colors[[x["rel"]]]),file = dot_file,append=T)
    })
    
    cat("\n}",file = dot_file,append = T)
}

print_metric_node = function(node,go_obo,dot_file,color="#fdcdac",leaf=NULL){
    tmp_node = paste('\t\t"',node,'"','[label="',leaf,'",color="',color,'"]\n',sep="")
    cat(tmp_node,file = dot_file,append = T)
}


plot_perf_fig = function(perf_line,gold,tool_data,dot_file,title){
    gene=perf_line$db_object_symbol
    tmp_aspect=perf_line$aspect
    gold_terms = gold[db_object_symbol == gene & aspect == tmp_aspect]$term_accession
    tool_term = tool_data[db_object_symbol == gene & aspect %in% tmp_aspect]$term_accession[1]
    #plot_go_overlap(tmp_gene,gold_terms,tool_terms,dot_file)
    plot_go_illus(tmp_gene,gold_terms,tool_term,dot_file,title)    
}

plot_example_fig = function(gold,tool_data,gene,aspect,dot_file,title){
    aspect2ns = list(C="cellular_component",F="molecular_function",P="biological_process")
    tmp_aspect=aspect
    ns=aspect2ns[[tmp_aspect]]
    gold_terms = gold[db_object_symbol == gene & aspect == tmp_aspect]$term_accession
    tool_term = tool_data[db_object_symbol == gene & aspect %in% tmp_aspect]$term_accession
    
    #plot_go_overlap(tmp_gene,gold_terms,tool_terms,dot_file)
    plot_go_illus(gene,ns,gold_terms,tool_term,dot_file,title)
}

plot_gold = function(gold,gene,tmp_aspect,dot_file,title){
    gold_terms = gold[db_object_symbol == gene & aspect == tmp_aspect]$term_accession
    tool_term = gold[db_object_symbol == gene & aspect %in% tmp_aspect]$term_accession
    #plot_go_overlap(tmp_gene,gold_terms,tool_terms,dot_file)
    plot_go_overlap(tmp_gene,gold_terms,tool_term,dot_file)
}

plot_illus_single = function(gene_row,dataset,node_color,node_symbol,dot_file,title){
    
    #rel_colors = list(is_a="blue",part_of="red")
    rel_colors = list(is_a="black",part_of="black")
    cat("digraph G{\n",file = dot_file)
    cat("\trankdir = BT\n",file = dot_file,append=T)
    cat("\tranksep = 0.1\n",file = dot_file,append=T)
    cat('label=""\n',file = dot_file,append=T)
    cat('\tnode[shape=circle,style=filled]\n',file = dot_file,append=T)
    #term_ans = go_obo$ancestors[[go_term]]
    go_terms = dataset[db_object_symbol == gene_row$db_object_symbol & aspect == gene_row$aspect]$term_accession
    term_ans = unique(unlist(go_obo$ancestors[go_terms]))
    all_nodes = unique(term_ans)
    
    null_node = lapply(all_nodes,function(x){
        leaf = node_symbol
        print_metric_node(x,go_obo,dot_file,color=node_color,leaf)
    })
    #cat("\t}",file = dot_file,append=T)
    
    rel_list = lapply(all_nodes,function(x){
        tmp_rel = go_obo$is_a[[x]]
        ns = unique(unlist(go_obo$namespace[[x]]))
        tmp_dt = NULL
        if(length(tmp_rel)>0){
            tmp_dt = cbind(child=x,parent=tmp_rel,rel="is_a")
        }
        
        if(sum(ns == "cellular_component")){
            tmp_part = go_obo$part_of[[x]]
            if(length(tmp_part)>0){
                tmp_part_dt = cbind(child=x,parent=tmp_part,rel="part_of")
                tmp_dt = rbind(tmp_dt,tmp_part_dt)
            }
        }
        tmp_dt
    })
    
    rel_dt = data.table(do.call(rbind,rel_list))
    
    null_rel = apply(rel_dt,1,function(x){
        cat(sprintf('\t\t"%s" -> "%s" [color="%s"]\n',x["child"],x["parent"],rel_colors[[x["rel"]]]),file = dot_file,append=T)
    })
    
    cat("\n}",file = dot_file,append = T)
}
#colorbrewer
#b3e2cd
#fdcdac
#cbd5e8
#f4cae4
#e6f5c9


get_specificity = function(terms,obo_data){
    
}