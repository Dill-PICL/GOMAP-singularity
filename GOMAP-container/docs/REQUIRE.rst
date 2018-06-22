Requirements to be installed
============================

The [DOI release] of the GO-MAP pipeline contains code, software, and
data files to run the pipeline. Although, there are some basic
requirements which need to be installed. The requirements that have to
be installed are listed below.

What are the requirements that need to be installed to run GO-MAP?
------------------------------------------------------------------

-  Hardware

   -  Storage

      -  minimum: 250GB

      -  recommended: :math:`\geq`\ 300GB

   -  Memory

      -  minimum: 16 GB

      -  recommended: :math:`\geq`\ 32 GB

-  Software

   -  OS

      -  linux

   -  Programming Languages

      -  R v3.4

      -  Python v2

      -  Java v1.8

      -  Perl

   -  Software

      -  MATLAB :math:`\geq`\ v2016a

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

What are the software tools needed to run specific annotation methods?
----------------------------------------------------------------------

-  Sequence-similarity

   -  BLASTP

-  Domain-presence

   -  InterProScan5

-  Mixed-method Pipelines

   -  FANN-GO

      -  MATLAB\ :math:`^\dagger`

      -  BLASTP

   -  PANNZER

      -  MySQL/MariaDB\ :math:`^\dagger`

      -  BLASTP

   -  Argot2

      -  Hmmer

      -  BLASTP

      -  Web browser\ :math:`^{\dagger\ddagger}`

| :math:`^\dagger`\ Part of requirements installed as mentioned in this
  section
| :math:`^\ddagger`\ To submit jobs to batch processing
| The pipeline file downloaded from CyVerse contains the data files and
  software tools to run the process on a given protein sequence fasta
  file. The disk space required for the pipeline is large (~160GB) and
  when it runs it will require close to 300GB of disk space.
