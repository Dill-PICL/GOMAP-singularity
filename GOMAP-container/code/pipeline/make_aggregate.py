import logging, os, re
from code.utils.basic_utils import check_output_and_run
from pprint import pprint


def clean_duplicate(config):
    command = ["Rscript", "code/pipeline/clean_duplicate.r",config["input"]["config_file"]]
    check_output_and_run("test.pod",command)

def clean_redundant(config):
    command = ["Rscript","code/pipeline/clean_redundancy.r",config["input"]["config_file"]]
    check_output_and_run("test.pod",command)

def aggregate_datasets(config):
    command = ["Rscript","code/pipeline/aggregate_datasets.r",config["input"]["config_file"]]
    check_output_and_run("test.pod",command)
