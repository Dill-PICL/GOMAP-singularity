Introduction
============

What is GO-MAP?
---------------

**G**\ ene **O**\ ntology - **M**\ eta **A**\ nnotator for **P**\ lants
(**GO-MAP**) is a pipeline that annotates GO terms to plant protein
sequences. The pipeline uses 3 different approaches to annotate GO terms
to plant proteins and uses a mix of custom code and existing software
tools to assign GO terms. The pipeline was designed to create a high
confidence GO annotation dataset for reference proteomes, and it is
recommended that the pipeline in it’s current form used to annotate
proteomes. The main pipeline is written in Python and R, and other
software tools used will be briefly described in the next Section.

What annotation methods are used to assign GO terms?
----------------------------------------------------

Sequence-similarity based methods
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sequence-similarity based GO annotations were performed using the
reciprocal-best-hit method against two different datasets, namely TAIR
and UniProt. The NCBI BLASTP tool will be used reciprocally to search
for similar sequences between the protein sequences of target species
being annotated and other datasets. The results from BLASTP search will
be processed using R script to determine the reciprocal-best-hits and
assign GO terms from TAIR and UniProt to the target species.

Domain-presence based methods
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Putative protein domains will be assigned to the protein sequence using
InterProScan5 pipeline. InterProScan5 is a java based pipeline that
finds protein domain signatures in target sequences and assigns GO terms
based on the presence of the protein signatures.

Mixed-method pipelines or tools
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Three top performing pipelines/tools which have competed in the first
iteration of the `CAFA <http://biofunctionprediction.org>`__ competition
will be used to assign GO terms to proteins. These tools are
`Argot2.5 <http://www.medcomp.medicina.unipd.it/Argot2-5/>`__,
`PANNZER <http://ekhidna.biocenter.helsinki.fi/pannzer>`__, and
`FANN-GO <http://montana.informatics.indiana.edu/fanngo/fanngo.html>`__.
Each of the tools have specific requirements, setup instructions and
pre-processing steps. The details of these steps will be explained in
the following sections [TODO]
