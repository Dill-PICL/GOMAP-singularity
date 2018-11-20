.. GOMAP-singularity documentation master file, created by
   sphinx-quickstart on Wed Jun 27 10:33:50 2018.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

.. _index:

.. image:: _static/gomap.png

Welcome to GOMAP-singularity's documentation!
=============================================

**GOMAP-singularity** is the containerized version of the Gene Ontology Meta Annotator for Plants (**GOMAP**) pipeline. **GOMAP** is a high-throughput pipeline to annotate GO terms to plant protein sequences. The pipeline uses three different approaches to annotate GO terms to plant protein sequences, and compile the annotations together to generate an aggregated dataset. GOMAP uses Python code to run the component tools to generate the GO annotations, and R code to clean and aggregate the GO annotations from the component tools.

The GOMAP-singularity container is designed with two uses in mind, namely reproducability and portability. The pipeline development is still ongoing, and while the major bugs fixed, it is in a stable condition to be used. We have prioritized the quality of the dataset over other features, as of now. Some anotations tools are which produce good annotations are not available in a containerized format, so the pipeline cannot be converted into a self-contained container. As new members are added to the team, and more tools are evaluated we may update the pipeline to be self-contained in future. 

How to use GOMAP-singularity
----------------------------

.. toctree:: 
   :maxdepth: 1
   :numbered:
   
   QUICKSTART
   REQUIREMENTS
   INSTALL
   RUN
   CONFIG
