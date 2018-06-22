'''
====================================================================
Cleaning input fasta downloaded from gramene
====================================================================
'''
import os, re, logging, sys, json
from code.utils.get_longest_transcript import get_longest_transcript
from code.utils.basic_utils import check_output_and_run,make_dir
from code.utils.blast_utils import make_blastdb


def clean_input(config_input,config_pipline):
    logging.info("Processing input fasta")
    basedir=config_input["dir"]["work_dir"]+"/"+config_input["dir"]["input_dir"]
    input_fasta = basedir + "/raw/" + config_input["files"]["raw_fa"]
    output_fasta = basedir + "/clean/" + config_input["files"]["basename"]+".fa"

    gene_start = config_input["cleaning"]["gene_start"]
    trans_pattern = config_input["cleaning"]["trans_pattern"]

    if os.path.isfile(output_fasta):
        logging.warn("The "+os.path.basename(output_fasta)+" already exists.")
        logging.warn("Please remove "+output_fasta+" if you want it to be recreated.")
    else:
        make_dir(output_fasta)
        get_longest_transcript(input_fasta,output_fasta,gene_start,trans_pattern)
        make_blastdb(output_fasta,config_pipline)
