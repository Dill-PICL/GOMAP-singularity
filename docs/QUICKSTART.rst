.. _QUICKSTART:

Quick Start
===========

1. Install (local) or load (HPC) `Singularity <http://singularity.lbl.gov>`_ container

    .. code-block:: bash
        
        #On HPC Systems
        module load singularity

2. Clone the git repository

    .. code-block:: bash

        mkdir -p /path/to/GOMAP-singularity/install/location
        git clone https://github.com/Dill-PICL/GOMAP-singularity.git /path/to/GOMAP-singularity/install/location
        cd /path/to/GOMAP-singularity/install/location
        

3. Run the setup script to make necesary directories and download data files from Cyverse

    .. code-block:: bash
        
        ./setup-GOMAP.sh

    .. attention::
        The pipeline download is huge and would require ~150GB free during the setup step.
    
    .. literalinclude:: ../setup-GOMAP.sh
        :language: bash
        :lines: 1-8
        :emphasize-lines: 8
        :linenos:

    .. attention::
        Line number 8 which is highlighted can be edited to change the tag after ':' symbol. This would allow images built for differnt HPC clusters and MPI version to be downloaded. The default tag used is single and MPI is disabled.

4. [optional] Test whether the container and the data files are working as intended.

    i) Add your **email** to the ``test/config.yml``. This is necessary to submit jobs to Argot2.5.
    
    ii) Run the test using following command.

    .. code-block:: bash
        
        ./test-GOMAP.sh

    .. attention::
        This has to be perfomed from the GOMAP-singularity install location because the test directory location is fixed.

4. Make Necessary Changes to run-GOMAP.sh. Especially change the ``$gomap_loc`` if necessary
    
    .. literalinclude:: ../run-GOMAP-SINGLE.sh
        :language: bash
        :emphasize-lines: 4,5 
        :linenos:
 
5. Copy the ``config.yml`` file from test directory and make necessary Changes

    .. literalinclude:: _static/min-config.yml
        :language: yaml
        :emphasize-lines: 4,6,8,10,12,14 
        :linenos:

6. Run the pipeline
    GOMAP has 6 distinct steps for running the pipeline after setup. The steps are as follows seqsim, domain, mixmeth-blast, mixmeth-preproc, mixmeth and aggregate.
    
    1. seqsim

    .. code-block:: bash

        ./run-GOMAP.sh --step=seqsim --config=test/config.yml
    
    2. domain

    .. code-block:: bash
    
        ./run-GOMAP.sh --step=domain --config=test/config.yml

    3. mixmeth-blast 

    .. code-block:: bash

        ./run-GOMAP.sh --step=mixmeth-blast --config=test/config.yml
    
    .. tip::
        Steps 1-3 can be run at the same time to each other, because they do not depend on each other. 

    4. mixmeth-preproc

    .. code-block:: bash
        
        ./run-GOMAP.sh --step=mixmeth-preproc --config=test/config.yml

    5. mixmeth

    .. code-block:: bash
        
        ./run-GOMAP.sh --step=mixmeth --config=test/config.yml

    6. aggregate

    .. code-block:: bash
        
        ./run-GOMAP.sh --step=aggregate --config=test/config.yml