#!/usr/bin/env python2
'''
Importing all the modules necessary for running the pipeline
pprint is only needed for debugging purposes
'''

'''
will this be included?
'''

import  logging, sys
from pprint import pprint

def run_preprocess(config):
	"""A really useful function.

    Returns None
    """

	logging.info("Processing Sequence-Similarity Steps")
	from code.pipeline.run_rbh_blast import make_input_blastdb,run_tair_blast,run_uniprot_blast,get_rbh_annotations
	make_input_blastdb(config)
	run_tair_blast(config)
	run_uniprot_blast(config)
	get_rbh_annotations(config)

	'''
	Step 5 is to run interproscan5 against the clean input protein sequences
	'''
	logging.info("Running domain annotations using IPRS")
	from code.pipeline.run_iprs import run_iprs,iprs2gaf
	run_iprs(config)
	iprs2gaf(config)

	'''
	Step 6 is to run components of preprocessing pipeline to create input data for the mixed method pipelines
	'''
	from code.pipeline.run_mm_preproc import process_fasta,make_tmp_fa, run_uniprot_blast, compile_blast_out
	process_fasta(config)
	make_tmp_fa(config)
	run_uniprot_blast(config)
	logging.info("All the blast commands have been run and temporary files have been generated")
	compile_blast_out(config)

	preproc_argot2(config)

	'''
	Step 8 is to run the mixed-method pipeline PANNZER
	'''
	from code.pipeline.run_pannzer import copy_blast, run_pannzer
	copy_blast(config)
	run_pannzer(config)

def preproc_argot2(config):
	'''
	Step 7 is to run the preprocessing steps for Argot2.5
	sadsdsadsa
	'''
	from code.pipeline.run_argot2 import convert_blast,run_hmmer
	convert_blast(config)
	run_hmmer(config)	