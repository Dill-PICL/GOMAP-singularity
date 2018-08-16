#!/usr/bin/env python

from spython.main import Client
import configparser, argparse, sys, os
from argparse import RawTextHelpFormatter
from pprint import pprint

parser = argparse.ArgumentParser(description='Welcome to the GOMAP-singularity Container',formatter_class=RawTextHelpFormatter)
parser.add_argument('--config',help="The config file in yaml format. \nPlease see test/config.yml for an example.",required=True)
parser.add_argument('--step',help="GOMAP will be run in distinct steps. Choose the step to run.", choices=['setup','seqsim','domain','mixmeth-preproc','mixmeth','aggregate'],required=True)
parser.add_argument('--tmpdir',help="Location of the local temporary directory in each node for use (requires ~50-60GB of space)", required=True)
parser.add_argument("--ini",help="The ini file with information about the location of the GOMAP container and data.\n This is optional and is usually available at the same location \nas the container image and this python script")
args = parser.parse_args()

script_loc = os.path.dirname(os.path.realpath(__file__))

config = configparser.ConfigParser()
if args.ini is None:
    config.read(script_loc+'/GOMAP.ini')
else:
    config.read(args.ini)
code_binds = [config["GOMAP"]["code_bind"]]
data_binds = [ config["GOMAP"]["gomap_data_loc"]+"/"+bind for bind in config["GOMAP"]["data_binds"].split(",")]
tmp_bind = [args.tmpdir+":/tmpdir"]

work_bind=[os.getcwd()+":/workdir"]
binds = code_binds + work_bind + tmp_bind + data_binds

image_loc=os.path.relpath(config["GOMAP"]["gomap_loc"])

if str(args.step) is not "mixmeth":
    Client.load(image=image_loc)
    result = Client.run(args=["--config",str(args.config),"--step",str(args.step)],bind=binds)
else:
    gomap_instance = Client.instance(image=image_loc)