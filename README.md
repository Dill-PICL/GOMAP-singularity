# Introduction
---

## What is GOMAP-Singularity?

**GOMAP-Singularity** is the containerized version of the Gene Ontology Meta Annotator for Plants (**GOMAP**) pipeline. 



is a pipeline that annotates GO terms to plant protein sequences. The pipeline uses three different approaches to annotate GO terms to plant protein sequences, and compile the annotations together to generate an aggregated dataset. GOMAP uses Python code to run the component tools to generate the GO annotations, and R code to clean and aggregate the GO annotations from the component tools.

## How do I use GOMAP-Singularity?


<!--
 What methods are used to annotate GO terms?
-------------------------------------------

Sequence-similarity based methods
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sequence-similarity based GO annotations were performed using the
reciprocal-best-hit method against two different datasets namely TAIR
and UniProt. The NCBI BLASTP tool will be used reciprocally to search
for similar sequences between the protein sequences of target species
being annotated and other datasets. The results from BLASTP search will
be processed using R script to determine the reciprocal-best-hits and
assign GO terms from TAIR and UniProt to the target species.

Domain-presence based methods
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Putative protein domains will be assinged to the protein sequence using
InterProScan5 pipeline. InterProScan5 uses a java based pipeline to find
protein domain signatures in target sequences and assigns GO terms based
on the presence of the domain signatures.

Mixed-method pipelines/tools
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Three best performing pipelines/tools which have competed in the first
iteration of the `CAFA <http://biofunctionprediction.org>`__ competition
will be used to assign GO terms to proteins. These tools are
`Argot2.5 <http://www.medcomp.medicina.unipd.it/Argot2-5/>`__,
`PANNZER <http://ekhidna.biocenter.helsinki.fi/pannzer>`__, and
`FANN-GO <http://montana.informatics.indiana.edu/fanngo/fanngo.html>`__.
Each of the tools have specific requirements, setup instructions and
pre-processing steps. These all will be explained in the setup section.

Requirements to be installed
============================

| The GO-MAP pipeline itself will have all the code to run the pipeline,
  but some requirements have to be installed before GO-MAP can be used.

What are the requirements for GO-MAP?
-------------------------------------

-  OS

   -  linux

-  Programming Languages

   -  R v3.4

   -  Python v2

   -  Java v1.8

   -  Perl

-  software

   -  MATLAB

   -  MySQL/MariaDB

-  Python Packages

   -  biopython

   -  numpy

   -  scipy

   -  MySQL-python

-  R packages

   -  ontologyIndex

   -  data.table

   -  ggplot2

   -  futile.logger

   -  jsonlite

The pipeline if downloaded from CyVerse containsthe data files and
following software to run the process on a given protein sequence fasta
file. The disk space required for the pipeline is large (~160GB) and
when it runs it will require close to 300GB of disk space.

-  Sequence-similarity

-  BLAST 2.6.0

-  InterProScan5

-  Java 1.8\*

-  Python 2\*

-  Perl\*

-  FANN-GO

-  Matlab\*

-  PANNZER

-  Python 2

-  MySQL/MariaDB\*

-  Argot2

-  BLASTP

-  Hmmer

-  Web browser to submit jobs to batch processing

Setting up GO-MAP
=================

What are the steps needed to setup the pipeline?
------------------------------------------------

#. Install dependencies

#. Install required packages for R and Python

-  A shell script is provided to make the installation of the packages
   easy.

-  Run ``bash install/install_packages.sh`` from GAMER-pipeline
   directory

-  Users with a python2 virtual environment please activate before
   running the script

#. Setup MySQL database for Pannzer

-  Create a database named pannzer

-  Create a user names pannzer and grant all privileges on the database
   pannzer

-  The password should be ``pannzer``

-  If you decide to change any of this, please update the config.json
   [mix-meth.PANNZER.database] file accordingly.

Running GO-MAP
==============

How to run the GAMER-pipeline?
------------------------------

GAMER-pipeline is run in two steps using pipeline1.py and pipleine2.py.
First part of the pipeline runs the Sequence-similarity methods and
domain-based methods, and FANN-GO and PANNZER. It also runs the
pre-processing steps for Argot2.5. Second part of the pipeline processes
results from different methods and compiles the final GO annotation
dataset from all differnt approaches. The main steps are given below.

#. Add the protein fasta file to ``input/raw/``

#. Make necessary changes to the config.json file

-  Update the ``work_dir`` in the pipeline section

-  Update the ``input`` section

   -  Give the correct input FASTA file name

   -  If the fasta contains multiple transcripts per gene then put the
      fasta in the ``input/raw`` directory and set the ``raw_fasta``
      parameter

   -  If the fasta file contains only on transcript per gene put it in
      the ``input/filt`` directory, and set the ``fasta`` parameter

   -  Update the species, inbred and version parameters for your species

-  [Optional] Update the ``seq-sim`` section

   -  (All the files should be already processed in this section)

-  [Optional] Update the ``mix-meth`` section

   -  (All the files and fields should be already set, except changes to
      database section for PANNZER )

-  [Optional] Update ``blast`` and ``hmmer`` sections

   -  This is to enable the correct number cpu threads for these
      software

-  All other sections should only be updated if things have been
   drastically changed.

#. execute ``python pipeline1.py config.json``

-  The pipeline will generate a number of intermidiate output files

-  Especially the mixed-method tools will require the input fasta to be
   split into smaller chunks. the chunks will be numbered serially.
   (e.g. test.1.fa, test.2.fa)

-  Argot 2.5 tool will NOT be executed within the pipeline

#. Submit the files in ``mixed-meth/argot2.5/blast`` and
   ``mixed-meth/argot2.5/hmmer`` using correct pairing

#. Extract the Argot2.5 result files for each job, in the
   ``mixed-meth/argot2.5/results`` directory and rename with correct
   prefix

-  Argot2.5 names all results as ``argot_results_ts0.tsv`` so the file
   should be renamed correctly (e.g. test.1.tsv, test.2.tsv)

-  Please do not leave any other file in the argot2.5 results directory,
   otherwise it will influence certain metrics.

#. execute ``python pipeline2.py config.json``

What are the steps needed to setup the pipeline?
------------------------------------------------

#. Install dependencies

#. Install required packages for R and Python

-  A shell script is provided to make the installation of the packages
   easy.

-  Run ``bash install/install_packages.sh`` from GAMER-pipeline
   directory

-  Users with a python2 virtual environment please activate before
   running the script

#. Setup MySQL database for Pannzer

-  Create a database named pannzer

-  Create a user names pannzer and grant all privileges on the database
   pannzer

-  The password should be ``pannzer``

-  If you decide to change any of this, please update the config.json
   [mix-meth.PANNZER.database] file accordingly.

How to run the GAMER-pipeline?
------------------------------

GAMER-pipeline is run in two steps using pipeline1.py and pipleine2.py.
First part of the pipeline runs the Sequence-similarity methods and
domain-based methods, and FANN-GO and PANNZER. It also runs the
pre-processing steps for Argot2.5. Second part of the pipeline processes
results from different methods and compiles the final GO annotation
dataset from all differnt approaches. The main steps are given below.

#. Add the protein fasta file to ``input/raw/``

#. Make necessary changes to the config.json file

-  Update the ``work_dir`` in the pipeline section

-  Update the ``input`` section

   -  Give the correct input FASTA file name

   -  If the fasta contains multiple transcripts per gene then put the
      fasta in the ``input/raw`` directory and set the ``raw_fasta``
      parameter

   -  If the fasta file contains only on transcript per gene put it in
      the ``input/filt`` directory, and set the ``fasta`` parameter

   -  Update the species, inbred and version parameters for your species

-  [Optional] Update the ``seq-sim`` section

   -  (All the files should be already processed in this section)

-  [Optional] Update the ``mix-meth`` section

   -  (All the files and fields should be already set, except changes to
      database section for PANNZER )

-  [Optional] Update ``blast`` and ``hmmer`` sections

   -  This is to enable the correct number cpu threads for these
      software

-  All other sections should only be updated if things have been
   drastically changed.

#. execute ``python pipeline1.py config.json``

-  The pipeline will generate a number of intermidiate output files

-  Especially the mixed-method tools will require the input fasta to be
   split into smaller chunks. the chunks will be numbered serially.
   (e.g. test.1.fa, test.2.fa)

-  Argot 2.5 tool will NOT be executed within the pipeline

#. Submit the files in ``mixed-meth/argot2.5/blast`` and
   ``mixed-meth/argot2.5/hmmer`` using correct pairing

#. Extract the Argot2.5 result files for each job, in the
   ``mixed-meth/argot2.5/results`` directory and rename with correct
   prefix

-  Argot2.5 names all results as ``argot_results_ts0.tsv`` so the file
   should be renamed correctly (e.g. test.1.tsv, test.2.tsv)

-  Please do not leave any other file in the argot2.5 results directory,
   otherwise it will influence certain metrics.

#. execute ``python pipeline2.py config.json``

What are the outputs of GAMER-pipeline?
---------------------------------------

GO annotations from GAMER-pipeline will be presented in Go Annotation
2.0 Format (GAF). All the annotations from different methods will
converted to GAF format files and will be saved in sub folders in the
gaf directory. The sub-directory structure in gaf is as follows -
mixed-method (Raw output from mixed-method piplines) - raw (Raw output
from Sequence-similarity and Domain-presence based methods, mixed-method
output filtered to exclude low quality annotations from mixed-method
pipelines) - uniq (Unique annotations from each tool cleaned by removing
duplicate annotations from the raw annotation files) - non\_red
(Non-redundant annotations filtered by removing ancestral GO terms from
the unique annotation files) - agg (Final aggregate dataset created by
combining annotations from all 6 Non-redundant annotation datasets) -->
