import os, re, logging, subprocess, sys, yaml,shutil
from yamldirs import create_files
from dirsync import sync
from logging import Logger

def make_dir(file):
    dir_name = os.path.dirname(file)
    if not os.path.exists(dir_name) and dir_name != '':
        os.makedirs(dir_name)

def check_output_and_run(outfile,command,stdin_file=None,stdout_file=None):
    if not os.path.exists(outfile):
        logging.info(outfile+" not present so running command\n" +" ".join(command))
        if stdin_file is not None:
            stdin_file = open(stdin_file,"r")
        if stdout_file is not None:
            stdout_file = open(stdout_file,"w")
        subprocess.check_call(command,stdin=stdin_file,stdout=stdout_file)
        logging.info("Step completed")
    else:
        logging.warn("The "+outfile+" exists so not running the command\n\""+" ".join(command)+"\"")
        logging.warn("Delete existing output file(s) to rerun the previous command")

def get_files_with_ext(in_dir,extension="fa"):
    all_files  = os.listdir(in_dir)
    out_files = []
    [out_files.append(tmp_file) if tmp_file.endswith(extension) else None for tmp_file in all_files]
    return out_files

def init_dirs(config):
    gomap_dir = config["input"]["workdir"]+"/GOMAP-"+config["input"]["basename"]
    config["input"]["gomap_dir"] = gomap_dir
    if not os.path.exists(gomap_dir):
        os.makedirs(gomap_dir, mode=0777)
    with open(config["pipeline"]["dir_struct"]) as tmp_file:
        dir_struct = tmp_file.read()
        with create_files(dir_struct) as workdir:
            sync(workdir,gomap_dir,"update")
    return(config)

def copy_input(config):
    src=config["input"]["workdir"]+"/"+config["input"]["fasta"]
    dest=config["input"]["gomap_dir"]+"/input"
    shutil.copy(src, dest)
