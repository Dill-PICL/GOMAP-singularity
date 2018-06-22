#!/usr/bin/env python2

import logging, os, re,sys
from code.utils.basic_utils import check_output_and_run
from pprint import pprint

def run_iprs(config):
	dom_config = config["data"]["domain"]
	iprs_config = config["software"]["iprs"]
	workdir=config["input"]["gomap_dir"]+"/"
	out_file= workdir + dom_config["tmpdir"] + "/" + config["input"]["basename"]
	temp_dir= workdir + dom_config["tmpdir"] + "/temp"
	input_fa = workdir + "input/" + config["input"]["fasta"]
	cmd = [iprs_config["path"]+"/interproscan.sh","-goterms","-pa","-i",input_fa,"-dp","-b",out_file, "-T",temp_dir] + iprs_config["options"]
	check_out=out_file+".tsv"
	check_output_and_run(check_out,cmd)

def iprs2gaf(config):
	dom_config = config["data"]["domain"]
	input_config = config["input"]
	workdir=config["input"]["gomap_dir"]+"/"
	tsv_base=workdir + dom_config["tmpdir"] + "/" + config["input"]["basename"]
	infile=tsv_base+".tsv"
	tmpfile=tsv_base+".go.tsv"
	gaf_dir=workdir + config["data"]["gaf"]["raw_dir"]+"/"

	tmp_iprs=open(tmpfile,"w")

	with open(infile,"r+") as raw_iprs:
	    for line in raw_iprs:
	        if re.search("GO:",line) is not None:
	            tmp_iprs.write(line)
	            #print >> tmp_iprs, line
	tmp_iprs.close()


	out_gaf = gaf_dir+os.path.basename(infile)
	tool_ext="."+config["data"]["domain"]["tool"]["name"] + ".gaf"
	out_gaf = re.sub(".tsv",tool_ext,out_gaf)
	cmd = ["Rscript","code/pipeline/iprs2gaf.r",config["input"]["config_file"]]
	check_output_and_run(out_gaf,cmd)
