import argparse
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.Alphabet import IUPAC
import re
import sys
import logging

#checking if the transcript pattern is supplied by the user and making
#regular expression objects of the pattern
def get_longest_transcript(input,output,gene_start,trans_pattern="\.[0-9]+"):
    trans_pattern = re.compile(trans_pattern)

    '''
    Parsing the gene start pattern so that we can filter out unwanted genes
    '''
    gene_pattern = re.compile(gene_start)

    #object to store the gene sequences
    seqs = {}

    '''
    Looping through to read and store the longest transscript sequence for each gene
    for each iteration regex replace the trans id to get gene id
    if length is longer than existing sequence replace or add the gene id sequence to dict
    '''
    for record in SeqIO.parse(input, "fasta"):
        gene_id = re.sub(trans_pattern,"",record.id)
        if gene_pattern.match(gene_id) is None:
            continue
        if gene_id in seqs:
            if len(seqs[gene_id].seq) < len(record.seq):
                seqs[gene_id] = record
        else:
            seqs[gene_id] = record

    '''
    This creates a list of sequences which can be saved into a file
    '''
    out_seqs = []
    for key in seqs.keys():
        curr_seq = seqs[key]
        curr_seq.id = key +" "+curr_seq.id
        curr_seq.seq = Seq(re.sub(r"[^A-Za-z]","",str(curr_seq.seq)),IUPAC.protein)
        out_seqs.append(curr_seq)

    #Write the output file as fasta
    SeqIO.write(out_seqs,output,"fasta")


'''
Parse arguments using argumentparser
'''
print ""
if __name__ is '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("input",help="Input sequence fasta file. Can be DNA or AA sequences")
    parser.add_argument("output",help="Output file. the file will be saved as fasta")
    parser.add_argument("gene_start",help="Pattern seen for gene IDs from the start")
    parser.add_argument("-p","--trans-pattern",help="String/RegEx Pattern that would recognize individual transcripts of a gene")
    trans_args = parser.parse_args()
    print(trans_args)
    get_longest_transcript(trans_args.input,trans_args.output,trans_args.gene_start,trans_args.trans_pattern)
