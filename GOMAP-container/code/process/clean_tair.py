'''
Clean TAIR peptide fasta to get longest sequence per gene_start
Clean TAIR GO annotation file to convert it into GAF 2.0
'''
import os, re, logging, subprocess, sys
import pprint as pp
from code.utils.get_longest_transcript import get_longest_transcript
import code.utils.basic_utils as basic_utils
from code.utils.blast_utils import make_blastdb

'''
Step 1 is to clean the arabidopsis protein sequences and filter for longest
translated protein sequence for each gene.
As future releases go, we cannot distribute the data with the pipeline, as the
data is not open source
'''
def clean_tair_fasta(raw_fasta,clean_fasta,gene_start,trans_pattern):
    logging.info("Processing TAIR fasta to select longest translated protein sequences")
    if os.path.isfile(clean_fasta) == True:
        logging.warn("The  clean "+os.path.basename(clean_fasta)+" file already exists.")
        logging.warn("Please remove "+ clean_fasta +" if you want it to be recreated")
    else:
        basic_utils.make_dir(clean_fasta)
        get_longest_transcript(raw_fasta,clean_fasta,gene_start,trans_pattern)
        logging.info("Finished Processing TAIR fasta file")

'''
    The function to clean the Arabidopsis GO annotation downloaded from TAIR
'''
def tair_go2gaf(in_go,out_gaf,config_file):
    logging.info("Converting TAIR GO file to GAF format")
    basic_utils.check_output_and_run(out_gaf,["Rscript","code/R/tair2gaf.r",config_file])

'''
main function which will call the other functions
'''
def clean_tair_data(config,config_file):
    tair_config = config["data"]["seq-sim"]["TAIR"]
    raw_fasta = tair_config["basedir"] + "/raw/" + tair_config["file_names"]["raw"]
    gene_start = tair_config["cleaning"]["gene_start"]
    clean_fasta = tair_config["basedir"] + "/clean/" + tair_config["file_names"]["basename"]+".fa"
    trans_pattern = tair_config["cleaning"]["trans_pattern"]
    in_go = tair_config["basedir"]+"/raw/"+tair_config["file_names"]["go_file"]
    out_gaf = tair_config["basedir"]+"/clean/"+tair_config["file_names"]["basename"]+".gaf"

    clean_tair_fasta(raw_fasta,clean_fasta,gene_start,trans_pattern)
    tair_go2gaf(in_go,out_gaf,config_file)
    make_blastdb(clean_fasta,config)
