import logging, os, re, ConfigParser, sys
from code.utils.basic_utils import check_output_and_run
from pprint import pprint
from dirsync import sync
from glob import glob

def copy_blast(config):
    workdir=config["input"]["gomap_dir"]+"/"
    tmp_blast_dir = workdir + config["data"]["mixed-method"]["preprocess"]["blast_out"]
    pannzer_blast_dir = workdir + config["data"]["mixed-method"]["pannzer"]["preprocess"]["blast"]
    sync(tmp_blast_dir,pannzer_blast_dir,"sync",exclude="temp")

def run_pannzer(config):
    workdir=config["input"]["gomap_dir"]+"/"
    pannzer_data=config["data"]["mixed-method"]["pannzer"]
    pannzer_conf=config["software"]["pannzer"]
    blast_dir=workdir + pannzer_data["preprocess"]["blast"]
    blast_files = glob(blast_dir+"/*.xml")    
    cwd = os.getcwd()
    os.chdir(cwd+"/"+pannzer_conf["path"])
    for blast_file in blast_files:
        blank_config = ConfigParser.ConfigParser()
        blank_config.read(pannzer_conf["conf_template"])
        blank_config.set("GENERAL_SETTINGS","INPUT_FOLDER",cwd+"/"+pannzer_data["preprocess"]["blast"])
        blank_config.set("GENERAL_SETTINGS","INPUT_FILE",blast_file)
        blank_config.set("GENERAL_SETTINGS","RESULT_FOLDER",workdir+pannzer_data["result_dir"])
        #blank_config.set("GENERAL_SETTINGS","db",cwd+"/"+pannzer_conf["path"]+"/db")
        
        blank_config.set("GENERAL_SETTINGS","QUERY_TAXON",config["input"]["taxon"])
        out_base = os.path.basename(blast_file).replace(".xml","")
        out_conf = workdir+pannzer_data["conf_dir"]+"/"+out_base+".conf"
        
        blank_config.set("GENERAL_SETTINGS","RESULT_BASE_NAME",out_base)
        blank_config.set("MYSQL","SQL_DB_HOST",pannzer_conf["database"]["SQL_DB_HOST"])
        blank_config.set("MYSQL","SQL_DB_PORT",pannzer_conf["database"]["SQL_DB_PORT"])
        blank_config.set("MYSQL","SQL_DB_USER",pannzer_conf["database"]["SQL_DB_USER"])
        # blank_config.set("MYSQL","SQL_DB_PASSWORD",pannzer_conf["database"]["SQL_DB_PASSWORD"])
        blank_config.set("MYSQL","SQL_DB",pannzer_conf["database"]["SQL_DB"])
        #pp.pprint(blank_config.items("GENERAL_SETTINGS"))
        # pprint(blank_config.items("GENERAL_SETTINGS"))
        
        blank_config.write(open(out_conf,"w"))
        pannzer_out = blank_config.get("GENERAL_SETTINGS","RESULT_FOLDER")+"/"+out_base + "_results.GO"
        pannzer_cmd = ["python","run.py",out_conf]
        check_output_and_run(pannzer_out,pannzer_cmd)
    os.chdir(cwd)

