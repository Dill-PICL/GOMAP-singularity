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

    Sequence-similarity search is performed against Arabidopsis protein sequences downloaded and curated/reviewed annotations downloaded from `TAIR <https://www.arabidopsis.org>`_ :cite:`lamesch_2012`. The exact steps used for annotations are given below.

    .. image:: _static/arab-rbh.png
       :target: _static/arab-rbh.png

UniProt
*******

    Sequence-similarity search is performed against plant protein sequences for the top 10 annotated plant species. The protein sequences and curated/reviewed annotations were downloaded from  `QuickGO <https://www.ebi.ac.uk/QuickGO/>`_ :cite:`uniprotconsortium_2015,huntley_2015,binns_2009`. The exact steps used for annotations are given below.

    .. image:: _static/uniprot-rbh.png
       :target: _static/uniprot-rbh.png

Domain-presence
+++++++++++++++

    Domain-presence step uses InterProScan to search for signatures present in the input sequences and annotate GO terms to protein sequences. InterProScan-5.25-64.0 was downloaded from `https://github.com/ebi-pf-team/interproscan/wiki <https://github.com/ebi-pf-team/interproscan/wiki>`_ and used to annotate input sequences :cite:`jones_2014`.

Mixed-methods
+++++++++++++

    Three mix-methods have been used in GOMAP, namely Argot2.5, FANN-GO and PANNZER :cite:`falda_2012,clark_2011,koskinen_2015`. Argot2.5 and PANNZER require preprocessing if the input sequences before they can be used to annotate GO terms to input sequences. The overall steps for running the mixed-methods have been given in the diagram below.

    .. image:: _static/mix-meth.png
       :target: _static/mix-meth.png



    The main step common to Argot2.5 and PANNZER tools is the mixmeth-blast. This runs the BLASTP search against UniprotDB and creates the XML output for chunked input :cite:`altschul_1990,uniprotconsortium_2015`. The XML files from the mixmeth-blast are used for annotation with PANNZER tool. The XML files are converted to CSV for Argot2.5. The Argot2.5 also requires Pfam hits for the input sequences from HMMER. These two files are submitted to Argot2.5 webserver for annotation. The annotations are retrieved after job completion emails are sent by Argot2.5.


Datasets used in GOMAP
----------------------

Public datasets used in GOMAP
+++++++++++++++++++++++++++++

    ============== =================== ========= =================== ====================== ===============================
    Database       Type                Format    Version             Species                Citation
    ============== =================== ========= =================== ====================== ===============================
    TAIR           Protein Sequences   fasta     TAIR 10             Arabidopsis thaliana   :cite:`lamesch_2012`
    TAIR           GO Annotations      gaf 2.0   TAIR 10 (20170410)  Arabidopsis thaliana   :cite:`lamesch_2012`
    Gramene 49     Gene Annotations    gff3      5b+                 Zea mays               :cite:`telloruiz_2016` 
    Gramene 49     GO Annotations      gaf 2.0   5b+                 Zea mays               :cite:`telloruiz_2016`
    Phytozome 11   GO Annotations      tsv       5b+                 Zea mays               :cite:`goodstein_2012`
    Uniprot        Protein sequences   fasta     20170410            All species            :cite:`uniprotconsortium_2015`
    Uniprot        Protein sequences   fasta     20170410            All plants             :cite:`uniprotconsortium_2015`
    Uniprot        GO Annotations      gaf 2.0   20170410            All plants             :cite:`huntley_2015,binns_2009`
    Pfam           HMMs                hmm       27.0                All species            :cite:`finn_2014`
    PANTHER        HMMs                hmm       10.0                All species            :cite:`mi_2017`
    ============== =================== ========= =================== ====================== ===============================

Software tools used in GOMAP
++++++++++++++++++++++++++++

    =============== ===================== ============== ==========================
    Software        Type                  Version        Citation
    =============== ===================== ============== ==========================
    NCBI-BLAST      Sequence similarity   2.6.0          :cite:`altschul_1990`
    HMMER           HMM scanning          3.1b1          :cite:`finn_2011`
    InterProScan5   GO Annotation         5.15-55.0      :cite:`jones_2014`
    PANNZER         GO Annotation         1.1            :cite:`koskinen_2015`
    Argot2          GO Annotation         2.5 (Server)   :cite:`falda_2012`
    FANN-GO         GO Annotation         1 version      :cite:`clark_2011`
    AIGO            GO Evaluations        0.1.0          :cite:`defoinplatel_2011`
    =============== ===================== ============== ==========================
  

.. bibliography:: _static/main.bib
    :cited:
    :style: unsrt