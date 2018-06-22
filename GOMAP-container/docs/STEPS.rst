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
