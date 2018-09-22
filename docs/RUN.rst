.. _YAML: https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html
.. _minimum config: _static/min-config.yml
.. _GOMAP-singularity: https://github.com/Dill-PICL/GOMAP-singularity

.. _RUN:

Run
===

.. attention::
    Please make sure you have installed the necessary :ref:`REQUIREMENTS` and run the :ref:`INSTALL` steps to get GOMAP-singularity and the necessary data 

Inputs for GOMAP
----------------

Config file
```````````
A cofiguration file in `YAML`_ format is required to run GOMAP-singularity. The configuration file can be run with minimum information from the user such as the `minimum config`_ shown below

.. literalinclude:: ../test/config.yml
        :language: yaml
        :emphasize-lines: 4,6,8,10,12,14 
        :linenos:
        :lines: 1-18

.. caution::
    Please make sure that you have entered a valid email address for Argot2.5 jobs to be submitted. The pipeline won't run without an email address. If you don't enter a valid email address you won't be able to retreive argot2.5 job status updates.

You can optimize the GOMAP pipeline with addional paramters that are explained in :ref:`CONFIG` section.

Plant Proteins
``````````````

The plant protein seeuences should be given as a fasta file. The sequences should have unique headers within a given fasta file. 


.. literalinclude:: _static/test.fa
        :emphasize-lines: 1,3,5,7
        :linenos:

Running GOMAP
-------------

GOMAP can be run using the ``run-GOMAP-SINGLE.sh`` script that is available from the `GOMAP-singularity`_ git repository. GOMAP can also be run directly via the container, but certain locations will need to be bound to container so that the code and software are found in the right locations. Please refer to the ``run-GOMAP-SINGLE.sh`` script for the locations that need to be bound.

There are 6 discrete steps that need to be run to complete a single GOMAP run. The steps are listed below.

1. `seqsim`_
2. `domain`_
3. `mixmeth-blast`_
4. mixmeth-preproc
5. mixmeth
6. aggregate

seqsim
``````

**seqsim** step completes the sequence-similarity based annotations component method of GOMAP.There are two sequence-Similarity component methods used in GOMAP, and both are listed below.

    i.   Reciprocal-best hit BLAST search between input and TAIR
    ii.  Reciprocal-best hit BLAST search between input and UniProt Plants    

    .. code-block:: bash

        ./run-GOMAP-SINGLE.sh --step=seqsim --config=test/config.yml


domain
``````
**domain** step completed the Domain-presence Component method of GOMAP, and this runs `InterProScan <https://github.com/ebi-pf-team/interproscan/wiki>`_ for the given protein sequenes and annotates GO terms based on the domains present.

    .. code-block:: bash    

        ./run-GOMAP-SINGLE.sh --step=domain --config=test/config.yml

mixmeth-blast
`````````````

**mixmeth-blast** step runs a BLAST search against the UniProt protein database, for the given input sequences and generates outputs in XML format. This is required as input features for both Argot2 and PANNZER which are the two mixed-method pipelines used.

    .. code-block:: bash    

        ./run-GOMAP-SINGLE.sh --step=mixmeth-blast --config=test/config.yml

.. attention::
    This step takes the longest time, and can take about 10-12 days. 

If you have installed the MPI version of the container then this step can be split across using multiple nodes and completed quickly. 



3. Mixed-method Component Methods
    i.   Run the Preprocessing step for mixed-methods
        a. split input sequences by every 10000
        b. Run BLASTP against UniProt database
        c. Run HMMER against UniProt database
        d. Convert BLASTP and HMMER to Argot2.5 submission format
    ii.  Submit Argot2.5 jobs
    iii. Run PANNZER on UniProt BLAST outputs

Preprocessing step can be run using the following command

.. code-block:: bash

    ./run-GOMAP-SINGLE.sh --step=preprocess --config=path/to/config.yml

At the end of preprocess step batch jobs are submitted to the Argot2.5 Webserver. The server will send you emails when these jobs are completed.

.. attention::
    Please wait for the Argot2.5 job completion emails befor running the next step.

Aggregating
```````````
Aggregating runs the following steps of GOMAP

1. Convert output from Sequence-Similarity Component Methods to GAF format
2. Covert output from Domain-presence Component method  to GAF format
3. Convert output from Mixed-method Component Methods to GAF format
4. Clean the GAF files by removing duplication and redundancy
5. Aggregate the annotations from all the clean datasets
6. Clean the aggregate dataset by removing duplication and redundancy



Aggregating step can be run using the following command

.. code-block:: bash

    ./run-GOMAP-SINGLE.sh --step=aggregate --config=test/config.yml

This step will take all the preprocessed data and create GAF 2.0 files. The GAF files will be cleaned and aggregated and the aggregate dataset will be generated in the agg directory.