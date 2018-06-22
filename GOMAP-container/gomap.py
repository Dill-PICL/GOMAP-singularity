#!/usr/bin/env python2

'''
Importing all the modules necessary for running the pipeline
pprint is only needed for debugging purposes
'''
import  os, re, logging, json, sys, argparse, jsonmerge, yaml
from argparse import RawTextHelpFormatter
from pprint import pprint
from code.gomap_preprocess import run_preprocess
from code.gomap_annotate import annotate
from code.utils.basic_utils import init_dirs, copy_input

from jsonmerge import Merger
schema = {
             "properties": {
                 "bar": {
                     "mergeStrategy": "append"
                 }
             }
         }
merger = Merger(schema)

'''
    Parsing the input config file that will be supplied by te user.
'''
main_parser = argparse.ArgumentParser(description='Welcome to running the GO-MAP pipeline',formatter_class=RawTextHelpFormatter)
main_parser.add_argument('--config',help="The config file in yml format. \nPlease see config.json for an example. \nIf a config file is not provided then the default parameters will be used.",required=True)
main_parser.add_argument('--step',help="GO-MAP has two distinct steps. Choose the step to run \n1) preprocess \n2) annotate", choices=['preprocess','aggregate','init'],required=True)
main_args = main_parser.parse_args()

'''
    This section loads the pipeline base config file from the pipeline script
    location. and loads the pipleine configutation
'''

with open("config/pipeline.yml") as tmp_file:
    pipe_config = yaml.load(tmp_file)



if main_args.config:
    config_file = main_args.config
    with open(config_file) as tmp_file:
        user_config = yaml.load(tmp_file)

config = merger.merge(pipe_config, user_config)

config = init_dirs(config)
copy_input(config)

conf_out = config["input"]["gomap_dir"]+"/"+config["input"]["basename"]+".all.yml"
config["input"]["config_file"] = conf_out
with open(conf_out,"w") as out_f:
	yaml.dump(config,out_f)



logging_config = config["logging"]
log_file = config["input"]["gomap_dir"] + "/log/" + config["input"]["basename"] + '.log'
logging.basicConfig(filename=log_file,level=logging_config['level'],filemode='a+',format=logging_config["format"],datefmt=logging_config["formatTime"])
logging.info("Starting to run the pipline for " + config["input"]["basename"])
'''
Depending the step selected by the user we are going to run the relevant part of GO-MAP
'''

if main_args.step == "preprocess":
	logging.info("Running Pre-processing Step")
	run_preprocess(config)
elif main_args.step == "aggregate":
    logging.info("Running Aggregate Step")
    annotate(config)
elif main_args.step == "init":
    logging.info("Creating the workdir")