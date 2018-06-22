library("futile.logger",quietly = T)

set_logger <- function(config){
    logfile = paste(config[["input"]][["gomap_dir"]], "/log/", config[["input"]][["basename"]], '.log',sep = "")
    a = flog.appender(appender.file(logfile),name="ROOT")
}