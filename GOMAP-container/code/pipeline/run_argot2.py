import logging, os, re, sys,shutil
from code.utils.basic_utils import check_output_and_run
import code.utils.split_fa as split_fa
from pprint import pprint
from lxml import etree
from glob import glob
import zipfile

def convert_blast(config):
    workdir=config["input"]["gomap_dir"]+"/"
    blast_xml_dir=workdir+config["data"]["mixed-method"]["preprocess"]["blast_out"]
    blast_xml_files=glob(blast_xml_dir+"/*xml")

    argot_tsv_dir=workdir + config["data"]["mixed-method"]["argot2"]["preprocess"]["blast"]

    xslt_root = etree.parse("config/bl_xml2argot.xsl")
    transform = etree.XSLT(xslt_root)

    for blast_xml in blast_xml_files:
        argot_out=argot_tsv_dir+"/"+re.sub(r'.xml$',".tsv",os.path.basename(blast_xml))
        bl_tree = etree.parse(blast_xml)
        result_txt = transform(bl_tree)
        result_txt.write_output(argot_out)
        zipfile_loc=argot_out+'.zip'
        if os.path.isfile(zipfile_loc):
            logging.info(zipfile_loc +" already exists. Please delete if you need this recreated")
        else:
            zf = zipfile.ZipFile(zipfile_loc, mode='w')
            zf.write(argot_out)
        
def run_hmmer(config):
    workdir = config["input"]["gomap_dir"] + "/"
    fa_dir = workdir+config["data"]["mixed-method"]["preprocess"]["fa_path"]    
    fa_files = glob(fa_dir+"/*fa")
    hmmer_bin = config["software"]["hmmer"]["path"]+"/hmmscan"
    hmmerdb=config["data"]["mixed-method"]["preprocess"]["hmmerdb"]
    cpu = str(config["software"]["hmmer"]["cpu"])
    tmp_file=workdir+"hmmscan.tmp"
        
    for infile in fa_files:
        outfile = workdir+config["data"]["mixed-method"]["argot2"]["preprocess"]["hmmer"] + "/" + re.sub("\.fa",".hmm.out",os.path.basename(infile))
        cmd = [hmmer_bin,"-o",tmp_file,"--tblout",outfile,"--cpu",cpu,hmmerdb,infile]
        zipfile = outfile+".zip"
        check_output_and_run(zipfile,cmd)
        check_output_and_run(zipfile,["zip","-9",zipfile,outfile])
        if os.path.isfile(tmp_file):
            os.remove(tmp_file)

def process_argot2(config):
    workdir = config["input"]["gomap_dir"] + "/"
    result_dir = workdir + config["data"]["mixed-method"]["argot2"]["result_dir"]
    zipfiles=glob(result_dir+"/*zip")
    for result_zip in zipfiles:
        outfile=re.sub(r".zip",".tsv",result_zip)
        if not os.path.isfile(outfile):
            logging.info("Unzipping " + os.path.basename(result_zip))
            archive = zipfile.ZipFile(result_zip)
            pprint(archive.namelist())
            result_file="argot_results_ts0.tsv"            
            archive.extract(result_file,".")
            shutil.move(result_file, outfile)
        else:
            logging.info("Outfile " + outfile + " already exists.\n Please delete it to regenerate")
        