import logging, os, re, sys
import code.basic_utils as basic_utils
import code.split_fa as split_fa
import pprint as pp


def run_fanngo(config):
    fanngo_conf = config["mixed-meth"]["fanngo"]
    fanngo_template = fanngo_conf["path"]+"/"+fanngo_conf["template"]
    run_file_str=os.path.basename(config["input"]["filt_fasta"]).replace(".fa","")+".fanngo.m"
    run_file_path = fanngo_conf["path"]+"/"+run_file_str
    #print fanngo_template
    conf_lines = open(fanngo_template,"r").readlines()
    run_file = open(run_file_path,"w")
    cwd=os.getcwd()
    output = cwd + "/" + fanngo_conf["output"]
    out_score = output + "/" + os.path.basename(config["input"]["filt_fasta"]).replace(".fa",".score.txt")



    for line in conf_lines:
        line = line.strip()
        if line.find("$PATH") > -1:
            code_path = cwd+"/"+fanngo_conf["path"]+"/code"
            outline = line.replace("$PATH",code_path)
            print >>run_file, outline
        elif line.find("$INPUT_FASTA") > -1:
            input_fasta = cwd+"/"+config["input"]["filt_fasta"]
            outline = line.replace("$INPUT_FASTA",input_fasta)
            print >>run_file, outline
        elif line.find("$OUTPUT_SCORE") > -1:
            outline = line.replace("$OUTPUT_SCORE",out_score)
            print >>run_file, outline
        else:
            print >>run_file, line
    run_file.close()
    cmd = ["matlab", "-nojvm", "-nodisplay", "-nosplash"]
    basic_utils.check_output_and_run(out_score,cmd,run_file_path,"temp/fanngo.log")
