import argparse, string, sys, logging, os
from Bio import SeqIO


#checking if the transcript pattern is supplied by the user and making
#regular expression objects of the pattern
def split_fasta(input,outdir,num_seqs,suffix="fa"):
    al_chars = list(string.ascii_lowercase)
    all_seqs = list(SeqIO.parse(input, "fasta"))
    num_seqs = int(num_seqs)

    counter = 0
    for i in range(0 , len(all_seqs),num_seqs):
        counter = counter + 1
        logging.info("Processing chunk number " + str(counter) + " of " + str(int(len(all_seqs)/num_seqs)+1))
        infile_sep = os.path.basename(input).split(os.path.extsep)
        out_comp = infile_sep[:-1]
        out_comp.append(str(counter))
        out_comp.append(infile_sep[-1:][0])
        out_file = outdir+ "/" + str.join(os.path.extsep,out_comp)
        if os.path.isfile(out_file):
            logging.warn("The "+out_file+" exists so not overwriting. Delete the split fasta files if you want them to be recreated ")
            break
        SeqIO.write(all_seqs[i:(i+num_seqs)], out_file, "fasta")
        #print(all_seqs[i:(i+10)])

'''
Parse arguments using argumentparser
'''
if __name__ is '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("input",help="Input sequence fasta file. Can be DNA or AA sequences")
    parser.add_argument("outdir",help="Output folder. The input fasta will split by given number of sequences")
    parser.add_argument("num_seqs",help="Number of sequences to save per file")
    parser.add_argument("-s","--suffix",help="Extra suffix to add to the file")
    args = parser.parse_args()
    print(args)
    split_fasta(args.input,args.outdir,args.num_seqs,args.suffix)
