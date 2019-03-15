# ReformatInput.py requires and infile, an abbreviated file name.
# --inputFile <specify input file name> and --renameAs <rename and shorten.fa>
# Backups and intermediate files are placed into the intermedPreprocss directory that is created if the user replies yes to 
# the prompt, these do not have to be made, but backups are always nice. The -FMT.fa file will be used as the input for GOMAP,
# it does not have '*' or '\t'.

# Resources used:
''' https://biopython.org/wiki/SeqRecord --> record.seq
    https://biopython.org/DIST/docs/api/Bio.Seq.Seq-class.html --> look under rstrip
    https://biopython.org/wiki/SeqIO 
    https://docs.python.org/3/tutorial/inputoutput.html 
    https://stackoverflow.com/questions/42757283/seqio-parse-on-a-fasta-gz  
    https://docs.python.org/2/library/collections.html 
    https://docs.python.org/2/library/stdtypes.html
    https://biopython.org/wiki/Seq
    http://biopython.org/DIST/docs/api/Bio.SeqIO-module.html
    https://www.biostars.org/p/1709/ 
    http://biopython.org/DIST/docs/api/Bio.SeqIO.FastaIO.FastaWriter-class.html
    https://biopython.org/wiki/SeqIO 
    https://docs.python.org/2/library/textwrap.html#module-textwrap
    https://www.geeksforgeeks.org/textwrap-text-wrapping-filling-python/
    https://docs.python.org/2/tutorial/inputoutput.html 
    https://cmdlinetips.com/2014/03/how-to-run-a-shell-command-from-python-and-get-the-output/
    https://stackoverflow.com/questions/123198/how-do-i-copy-a-file-in-python 
    https://docs.python.org/3/library/shutil.html#shutil.copy2
    https://askubuntu.com/questions/747450/how-do-i-call-a-sed-command-in-a-python-script
    https://stackoverflow.com/questions/39903208/python-shutil-file-move-in-os-walk-for-loop
    https://stackoverflow.com/questions/32286403/how-to-implement-command-line-switches-to-my-script
    https://stackoverflow.com/questions/3041986/apt-command-line-interface-like-yes-no-input  ''' 

import Bio
import textwrap
import sys
import os
import subprocess
import shutil
import argparse
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.Alphabet import IUPAC
from sys import argv

parser = argparse.ArgumentParser()
parser.add_argument('--inputFile', action = 'store')
parser.add_argument('--renameAs', action = 'store')
parser.add_argument('--backUps', action = 'store')
args = parser.parse_args()

backUps = args.backUps

if os.path.exists(args.inputFile):
   pass
else:
   print("Not a file (inputFile)")

#Input should be in .fa
inputFile = args.inputFile 
renameAs = args.renameAs 
workingDirectory = './'

shutil.copy2(inputFile, renameAs)

print("Checking to ensure that the inputFile (.fasta) is the same as the renameAs (.fa)" + '\n')
# Check to ensure that the original .fasta file is the same as the .fa file for tabs to be removed
subprocess.call(['cmp', inputFile, renameAs])
print("Post compare" + '\n')

nameIn, extensionIn = os.path.splitext(renameAs)

tempFormatter = 'tempFormatter.fa'

# For option to create backups
makeBackups = backUps
while (makeBackups):
   if makeBackups == "yes":
      shutil.copy2(inputFile, inputFile + ".bak")
      shutil.copy2(renameAs, renameAs + ".bak")
      break
   elif makeBackups == "no":
      break
   else:
      makeBackups = raw_input("Please respond yes or no: ")

# Create a wrapper to print the sqeuences without * at the end in 60 FASTA format
wrapper = textwrap.TextWrapper(width = 60)

# Function to use the wrapper (fill for a single \n string), return my_seqwrap
def printInFasta(wo_asterisk):
   seq_wrapper = wrapper.fill(text=wo_asterisk)
   return (seq_wrapper); 

# A total sequence count (before stripping * at the end of lines)
totalseqcount = 0

# Post stripping of end of sequence *, line with * count 
asterisk_count = 0
wo_asterisk_count = 0

# A check that acount + nacount can be compared to totalseqcount
wwo_asterisk_count = 0

with open(renameAs, 'r') as f, open(tempFormatter, 'w') as g:
   for record in SeqIO.parse(f, "fasta"):
      
      wo_asterisk = str(record.seq.rstrip("*"))
      
      # Writing the description as a string and sequence without * at the end as a string to file specified as g
      g.write(">" + str(record.description) + '\n' + str(printInFasta(wo_asterisk)) + '\n')
      
      # After asterisks have been rstriped from the end, check if there are asterisks in the middle
      if wo_asterisk.find("*") == -1:
         wo_asterisk_count += 1
      else:
         asterisk_count += 1
      
      totalseqcount += 1

print('\n')
print("The total number of sequences present: " +  str(totalseqcount) + '\n')
print("The number of sequences without '*' in the middle: " + str(wo_asterisk_count) + '\n')
print("The number of sequences with '*' in the middle: " +  str(asterisk_count) + '\n')
print("Checking that with and without asterisks in the middle is equal to the total number of sequences: " + str((wo_asterisk_count+asterisk_count) == totalseqcount) + '\n')
print("Creating backup and removing tabs" + '\n')

subprocess.call(["sed", "-i", "-e", 's/\t/ /g', "tempFormatter.fa"])

formatFile = shutil.copy2(tempFormatter, nameIn + "-FMT" + extensionIn)

# If backups were made create a directory and move backups and temp files into the intermedPreprocess directory
if makeBackups == "yes":
   shutil.copy2(tempFormatter, tempFormatter + ".bak")
   
   subprocess.call(['mkdir', 'intermedPreprocess'])
   currentDirectory = os.listdir(workingDirectory)
   toDirectory = "./intermedPreprocess"
   
   for backups in currentDirectory:
      if backups.endswith(".bak") or backups.startswith("temp"):
         shutil.move(backups, toDirectory)
   print("Creating intermedPreprocess directory and moving backup and intermediate files to intermedPreprocess" + '\n')

print("Completed backup and tab removal" + '\n')

print("The -FMT.fa is the formatted file" + '\n')
