#!/usr/bin/env python2

'''
Importing all the modules necessary for running the pipeline
pprint is only needed for debugging purposes
'''
import  os, re, logging, json, sys, argparse, jsonmerge
import pprint as pp

'''
    Parsing the input config file that will be supplied by te user.
'''
main_parser = argparse.ArgumentParser(description='Running the first part of GAMER pipeline')
main_parser.add_argument('config_file',help="The config file in json format. Please see config.json for an example")
main_args = main_parser.parse_args()

'''
    This section loads the pipeline base config file from the pipeline script
    location. and loads the pipleine configutation
'''

config_file = main_args.config_file
with open(config_file) as tmp_file:
    config = json.load(tmp_file)

config["pipeline_location"] = os.path.dirname(sys.argv[0])

logging_config = config["logging"]
log_file = logging_config["file_name"] + ('.log' if re.match(".*\.log$",logging_config["file_name"]) == None else '')
logging.basicConfig(filename=log_file,level=logging_config['level'],filemode='w+',format=logging_config["format"],datefmt=logging_config["formatTime"])

'''
Step 1 is to clean the fasta file downloaded from TAIR to get longest
representative sequence. We need to check if the filt file already exists
The TAIR file cannot be downloaded anymore. It has become a subscription
only resource and is not freely distibuted
'''
logging.info("Cleaning TAIR Files")
from code.process.clean_tair import clean_tair_fasta,tair_go2gaf,clean_tair_data
clean_tair_data(config,config_file)

'''
Step 2 is to get relavent sequences from UniProt for the taxonomy ids mentioned in the config files
'''
logging.info("Downloading and processing UniProt files")
from code.process.clean_uniprot import clean_uniprot_data
clean_uniprot_data(config,config_file)
