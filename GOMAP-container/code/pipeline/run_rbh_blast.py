import os, re, logging, subprocess, sys
from code.utils.basic_utils import check_output_and_run
from code.utils.blast_utils import make_blastdb
from Bio import SeqIO
from pprint import pprint

outcols='6 qseqid sseqid qlen qstart qend slen sstart send evalue bitscore score length pident nident gaps'

'''
Make the blast database for the input sequence first
'''
def make_input_blastdb(config):
	input_fa = config["input"]["gomap_dir"]+"/input/"+config["input"]["fasta"]
	make_blastdb(input_fa,config)

'''
Run the Reciprocal Blast searched between tair and input fasta
'''
def run_tair_blast(config):
	pipeline_loc = config["pipeline"]["pipeline_loc"]+"/"
	tair_config = config["data"]["seq-sim"]["TAIR"]
	tair_fa = pipeline_loc+tair_config["basedir"]+"/"+tair_config["basename"]+".fa"
	blast_config = config["software"]["blast"]
	blast_bin = pipeline_loc+blast_config["bin"]+"/blastp"
	workdir=config["input"]["gomap_dir"]+"/"
	input_fa = workdir+"/input/"+config["input"]["fasta"]
	tmp_base_dir = workdir+tair_config["tmpdir"]

	#running main vs other blast.
	main2other_file=tmp_base_dir+"/"+config["input"]["basename"]+"-vs-"+tair_config["basename"]+".bl.out"
	main2other_cmd = [blast_bin,"-outfmt",outcols, "-db",tair_fa,"-query",input_fa,"-out",main2other_file,"-num_threads",str(blast_config["num_threads"]),"-evalue",str(blast_config["evalue"])]
	check_output_and_run(main2other_file,main2other_cmd)

	#running other vs main blast
	other2maize_file=tmp_base_dir+"/"+tair_config["basename"]+"-vs-"+config["input"]["basename"]+".bl.out"
	other2maize_cmd = [blast_bin,"-outfmt",outcols, "-db",input_fa,"-query",tair_fa,"-out",other2maize_file,"-num_threads",str(blast_config["num_threads"]),"-evalue",str(blast_config["evalue"])]
	check_output_and_run(other2maize_file,other2maize_cmd)

'''
Function to Run the Reciprocal Blast searched between uniprot and input fasta
'''
def run_uniprot_blast(config):
	pipeline_loc = config["pipeline"]["pipeline_loc"]+"/"
	uniprot_config = config["data"]["seq-sim"]["uniprot"]
	uniprot_fa = pipeline_loc + uniprot_config["basedir"] + "/" + uniprot_config["basename"]+".fa"
	blast_config = config["software"]["blast"]
	blast_bin = pipeline_loc+blast_config["bin"]+"/blastp"
	workdir=config["input"]["gomap_dir"]+"/"
	input_fa = workdir+"/input/"+config["input"]["fasta"]
	tmp_base_dir = workdir+uniprot_config["tmpdir"]

	#running main vs other blast.
	main2other_file=tmp_base_dir+"/"+config["input"]["basename"]+"-vs-"+uniprot_config["basename"]+".bl.out"
	main2other_cmd = [blast_bin,"-outfmt",outcols, "-db",uniprot_fa,"-query",input_fa,"-out",main2other_file,"-num_threads",str(blast_config["num_threads"]),"-evalue",str(blast_config["evalue"])]
	check_output_and_run(main2other_file,main2other_cmd)

	#running other vs main blast
	other2maize_file=tmp_base_dir+"/"+uniprot_config["basename"]+"-vs-"+config["input"]["basename"]+".bl.out"
	other2maize_cmd = [blast_bin,"-outfmt",outcols, "-db",input_fa,"-query",uniprot_fa,"-out",other2maize_file,"-num_threads",str(blast_config["num_threads"]),"-evalue",str(blast_config["evalue"])]
	check_output_and_run(other2maize_file,other2maize_cmd)

def get_rbh_annotations(config):
	file_exist = True
	out_file= config["input"]["gomap_dir"] + "/" + config["data"]["seq-sim"]["uniprot"]["tmpdir"]+"/test"
	command = ["Rscript", "code/pipeline/run_rbh.r", config["input"]["config_file"]]
	check_output_and_run(out_file,command)
    # for key in ss_config.keys():
    #     base_dir = os.path.dirname(os.path.dirname(ss_config[key]["fasta"]))
    #     out_file=base_dir+"/blast/"+config["input"]["basename"]+"-"+ss_config[key]["basename"]+".bl.out"
    #     logging.info(out_file)
    #     out_gaf=config["gaf"]["raw_dir"]+"/"+config["input"]["basename"]+"."+ss_config[key]["species"]+".gaf"
    #     logging.info(out_gaf)
	#
	# 	command = ["Rscript", "steps/_4_run_rbh.r",config["input"]["config_file"]]
	# 	check_output_and_run(out_file,other2maize_cmd)
