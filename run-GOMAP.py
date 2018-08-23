#!/usr/bin/env python3

from spython.main import Client
import configparser, argparse, sys, os
from argparse import RawTextHelpFormatter
from pprint import pprint
from itertools import product, chain

GOMAP_LOC=os.environ.get("GOMAP_LOC")
GOMAP_DATA_LOC=os.environ.get("GOMAP_DATA_LOC")

parser = argparse.ArgumentParser(description='Welcome to the GOMAP-singularity Container')
parser.add_argument('--config',help="The config file in yaml format. \nPlease see test/config.yml for an example.",required=True)
parser.add_argument('--step',help="GOMAP will be run in distinct steps. Choose the step to run.", choices=['setup','seqsim','domain','mixmeth-preproc','mixmeth','aggregate'],required=True)
parser.add_argument('--gomap_loc',help="Location of the GOMAP-singularity container image. Needed if the environment variable $GOMAP_LOC is not set.", default=GOMAP_LOC, required=False if "GOMAP_LOC" in os.environ else True)
parser.add_argument('--gomap_data_loc',help="Location of the data necessary to run GOMAP. Needed if the environment variable $GOMAP_DATA_LOC is not set.", default=GOMAP_DATA_LOC, required=False if "GOMAP_DATA_LOC" in os.environ else True )
parser.add_argument('--tmpdir',help="Location of the local temporary directory in each node for use (requires ~50-60GB of space)", required=True)
parser.add_argument("--dev",help="this option lets you bind the development code to the container to develop or bug fix GOMAP code. \n The GOMAP code directory should be supplied to be bound to the container",default=None)
args = parser.parse_args()

script_loc = os.path.dirname(os.path.realpath(__file__))

data_bind_sub = ["mysql/lib:/var/lib/mysql","mysql/log:/var/log/mysql",":/opt/GOMAP/data"]

data_binds = [ args.gomap_data_loc+"/"+bind for bind in data_bind_sub]
tmp_bind = [args.tmpdir+":/tmpdir"]
work_bind=[os.getcwd()+":/workdir"]
if args.dev is not None:
    code_binds = [args.dev+":/opt/GOMAP"]
    binds = code_binds + work_bind + tmp_bind + data_binds
else:    
    binds = work_bind + tmp_bind + data_binds

image_loc=args.gomap_loc

if str(args.step) == "mixmeth":
    print("Starting instance")
    instance_binds = list(chain.from_iterable(product(["--bind"],binds)))
    instance_name="GOMAP"
    if Client.instances(instance_name,quiet=True) is None:
        gomap_instance = Client.instance(image=image_loc,options=instance_binds,start=True,name=instance_name)
    else:
        gomap_instance = Client.instances(instance_name,quiet=True)
    result = Client.run(gomap_instance,args=["--config",str(args.config),"--step",str(args.step)])
    gomap_instance.stop()
else:
    result = Client.run(image=image_loc,args=["--config",str(args.config),"--step",str(args.step)],bind=binds)