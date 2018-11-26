.. _OVERVIEW:

Overview
========

    **GOMAP-singularity** is the containerized version of the Gene Ontology Meta Annotator for Plants (**GOMAP**) pipeline. **GOMAP** is a high-throughput pipeline to annotate GO terms to plant protein sequences. The pipeline uses three different approaches to annotate GO terms to plant protein sequences, and compile the annotations together to generate an aggregated dataset. GOMAP uses Python code to run the component tools to generate the GO annotations, and R code to clean and aggregate the GO annotations from the component tools.

    .. image:: _static/gomap-overview.png
       :target: _static/gomap-overview.png

    The GOMAP-singularity container is designed with two uses in mind, namely `reproducability` and `portability`. The pipeline development is still ongoing and the major bugs are fixed. We have prioritized the quality of the dataset over other features. Some anotations tools are which produce good annotations are not available in a containerized format, so the pipeline cannot be converted into a self-contained container. As new members are added to the team, and more tools are evaluated we may update the pipeline to be self-contained in future. 


Methods used in GOMAP
---------------------

1. Sequence-similarity

    Sequence-similarity methods search for similar sequences in other species for the given input sequences, and inheric curated/reviewed GO terms from other species to maize. Two datasets are used for the sequence-similarity datasets namely `Arabidopsis`_ and `UniProt`_ .

#. Domain-presence

    Domains-presense method searches for known protein domains and signatures in the input sequences and assign GO terms from curated domains and signatures to the input sequences

#. Mixed-methods

    Mixed-methods or CAFA tools used in the pipeline were Argot2 and PANNZER. Both tools use information generated from sequence-similarity and domain presence to predict better Annotations from the dataset.

Sequence-similarity
+++++++++++++++++++

Arabidopsis
***********

    Sequence-similarity search is performed against Arabidopsis protein sequences downloaded and curated/reviewed annotations downloaded from `TAIR <https://www.arabidopsis.org>`_. The exact steps used for annotations are given below.

    .. image:: _static/arab-rbh.png
       :target: _static/arab-rbh.png

UniProt
*******

    Sequence-similarity search is performed against plant protein sequences for the top 10 annotated plant species. The protein sequences and curated/reviewed annotations were downloaded from  `QuickGO <https://www.ebi.ac.uk/QuickGO/>`_. The exact steps used for annotations are given below.

    .. image:: _static/uniprot-rbh.png
       :target: _static/uniprot-rbh.png

Domain-presence
+++++++++++++++

    Domain-presence step uses InterProScan to search for signatures present in the input sequences and annotate GO terms to protein sequences. InterProScan-5.25-64.0 was downloaded from `https://github.com/ebi-pf-team/interproscan/wiki <https://github.com/ebi-pf-team/interproscan/wiki>`_ and used to annotate input sequences.

Mixed-methods
+++++++++++++

Argot2.5
********

    

PANNZER
*******


