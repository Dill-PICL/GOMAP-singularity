library("data.table")

aspect_lbl = function(aspect){
    tmp_lbl = list(C="Cellular Component",P="Biological Process",F="Molecular Function")
    return(tmp_lbl[aspect])
}

gam_type_lbl = function(type){
    type_lbl = fread("type_lbl.txt")
    type_lbl_list = as.list(unlist(type_lbl$label))
    names(type_lbl_list) = type_lbl$code
    return(type_lbl_list[type])
}

venn_face_col = function(gp,cbpallete){
    faces = names(gp$Face)[-1]
    tmp_cols = lapply(faces,function(x){
        first = as.numeric(substr(x,1,1))
        second=as.numeric(substr(x,2,2))
        third=as.numeric(substr(x,3,3))
        
        col1 = unlist(col2rgb(cbpallete[3])*first)
        col2 = unlist(col2rgb(cbpallete[2])*second)
        col3 = unlist(col2rgb(cbpallete[1])*third)
        
        total_col=c(col1+col2+col3)
        blend_col=round(total_col/sum(first+second+third),0)
        gp$Face[[x]]$fill <<- rgb(blend_col[1],blend_col[2],blend_col[3],max = 255)
    })
    return(gp)
}
