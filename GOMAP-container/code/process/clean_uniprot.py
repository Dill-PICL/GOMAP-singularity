import os, re, logging, subprocess, json, sys, gzip
from Bio import SeqIO
import urllib
import pprint as pp
from datetime import date
from code.utils.blast_utils import make_blastdb

def download_gaf(gaf_url,tmp_gaf,raw_gaf,config):
    dirname = os.path.dirname(raw_gaf)
    if not os.path.isdir(dirname):
        os.makedirs(dirname)

    if not os.path.isfile(tmp_gaf):
        logging.info("Downloading UniProt GOA file")
        urllib.urlretrieve(gaf_url,tmp_gaf)
        '''
        TODO update the code to get date from existing files instead of the date
        '''
        today = date.today()
        config["data"]["seq-sim"]["uniprot"]["metadata"]["version"] = str(today)
        with open(config_file,"w") as outfile:
            json.dump(config,outfile,sort_keys=False,indent=4)
        logging.info("Downloading GAF from UniProt")
    else:
        logging.warning("Uniprot GOA gaf already exists.")
        logging.warning("Please delete "+tmp_gaf+" if it needs to be downlodade again")

    if not os.path.isfile(raw_gaf):
        logging.info("Filtering for HC evidence codes from "+tmp_gaf)

        omit_f = dirname+"/omit_ev.txt"
        with open(omit_f,"w") as omit_file:
            omit_file.writelines("\n".join(config["data"]["seq-sim"]["ev_codes"]["omit"]))
        omit_file.close()

        with open(raw_gaf,"w") as raw_gaf_f:
            zcat = subprocess.Popen(["zcat",tmp_gaf],stdout=subprocess.PIPE)
            fgrep = subprocess.Popen(["fgrep","-vf"+omit_f],stdin=zcat.stdout,stdout=raw_gaf_f)
            zcat.stdout.close()
            output = fgrep.communicate()[0]
            fgrep.wait()
    else:
        logging.warning("Uniprot high-confidence gaf already exists.")
        logging.warning("Please delete "+raw_gaf+" if it needs to be recreated")

def clean_raw_gaf(gaf_url,raw_gaf, tmp_gaf, clean_gaf, config):
    download_gaf(gaf_url,tmp_gaf,raw_gaf,config)
    dirname = os.path.dirname(clean_gaf)
    if not os.path.isdir(dirname):
        os.makedirs(dirname)

    uniprot_config = config["data"]["seq-sim"]["uniprot"]
    omit_tax = set(uniprot_config["cleaning"]["omit_tax"])
    sel_tax = set(uniprot_config["cleaning"]["sel_tax"])

    if not os.path.isfile(clean_gaf):
        download_gaf(gaf_url,tmp_gaf,raw_gaf,config)
        outfile = open(clean_gaf, "w")
        counter = 0
        with open(raw_gaf, "r") as infile:
            for line in infile:
                counter = counter + 1
                if re.match("^!", line):
                    outfile.write(line)
                else:
                    line_split = line.split("\t")
                    ev_code = line_split[6]
                    taxon = set(line_split[12].replace("taxon:", "").split("|"))
                    if set.intersection(taxon,sel_tax) and not set.intersection(taxon,omit_tax):
                        outfile.write(line)
                if counter % 100000 == 0:
                    print "Processed {:,} lines".format(counter)
                    outfile.flush()
        outfile.close()
    else:
        logging.warning("Clean GAF file for plant annotations already exists")
        logging.warning("Delete " + raw_gaf + " and " + clean_gaf + " to download again")

def download_uniprot_fasta(fasta_url,raw_fasta):
    dirname = os.path.dirname(raw_fasta)
    if not os.path.isdir(dirname):
        os.makedirs(dirname)
    if not os.path.isfile(raw_fasta):
        logging.info("Downloding UniProt raw fasta file from "+fasta_url)
        urllib.urlretrieve(fasta_url,raw_fasta)
    else:
        logging.warn("The UniProt raw fasta file already exists.")
        logging.info("Please delete the "+ raw_fasta + " if you want to download again")

def clean_uniprot_fasta(fasta_url,raw_fasta,clean_fasta,clean_gaf):
    download_uniprot_fasta(fasta_url,raw_fasta)

    sel_ids = set()
    with open(clean_gaf,"r") as clean_gaf_f:
        for line in clean_gaf_f:
            if not re.match("^!",line):
                line_split = line.split("\t")
                sel_ids.add(line_split[1])

    if not os.path.isfile(clean_fasta):
        logging.info("Cleaning UniProt raw fasta file")
        seqs = []
        with gzip.open(in_fasta,"rt") as handle:
            for record in SeqIO.parse(handle, "fasta"):
                id_split = record.description.split(" ")
                record.id = id_split[1]
                if record.id in sel_ids:
                    seqs.append(record)
        SeqIO.write(seqs,out_fasta,"fasta")
    else:
        logging.warn("The UniProt clean fasta file already exists.")
        logging.info("Please delete the "+ clean_fasta + " if you want to download again")

def clean_uniprot_data(config, config_file):
    uniprot_config = config["data"]["seq-sim"]["uniprot"]
    (gaf_url,fasta_url) = (uniprot_config["urls"]["gaf"],uniprot_config["urls"]["fasta"])
    raw_base = uniprot_config["basedir"] + "/raw/" + uniprot_config["filenames"]["basename"]
    clean_base = uniprot_config["basedir"] + "/clean/" + uniprot_config["filenames"]["basename"]
    (tmp_gaf,raw_gaf,clean_gaf) = (raw_base + ".gaf.gz",raw_base + ".gaf",clean_base+".gaf")
    (raw_fasta,clean_fasta) = (raw_base + ".fa.gz",clean_base+".fa")

    clean_raw_gaf(gaf_url,raw_gaf,tmp_gaf,clean_gaf,config)
    clean_uniprot_fasta(fasta_url,raw_fasta,clean_fasta,clean_gaf)
    make_blastdb(clean_fasta,config)
