import  os, re, logging, json, sys
from pprint import pprint


def annotate(config):

    from code.pipeline.run_argot2 import process_argot2
    process_argot2(config)
    
    
    from code.pipeline.mixed2gaf import mixed2gaf, filter_mixed
    mixed2gaf(config)
    filter_mixed(config)

    
    from code.pipeline.make_aggregate import clean_duplicate, clean_redundant, aggregate_datasets
    clean_duplicate(config)
    clean_redundant(config)
    aggregate_datasets(config)
