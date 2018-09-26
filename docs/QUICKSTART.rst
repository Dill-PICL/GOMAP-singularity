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
        Line number 8 which is highlighted can be edited to add a tag at the end of the line (e.g. :condo, :bridges, :comet). This would allow images built for differnt HPC clusters and MPI version to be downloaded. If no tag is used then the image downloaded will have MPI is disabled.

4. [optional] Test whether the container and the data files are working as intended.

    i) Add your **email** to the ``test/config.yml``. This is necessary to submit jobs to Argot2.5.
    
    ii) Run the test using following command.

    .. code-block:: bash
        
        ./test-GOMAP.sh

    .. attention::
        This has to be perfomed from the GOMAP-singularity install location because the test directory location is fixed.

4. Make Necessary Changes to run-GOMAP-SINGLE.sh. Especially change the ``$gomap_loc`` if necessary
    
    .. literalinclude:: ../run-GOMAP-SINGLE.sh
        :language: bash
        :emphasize-lines: 3,4 
        :linenos:

5. Copy the ``config.yml`` file from test directory and make necessary Changes

    .. literalinclude:: _static/min-config.yml
        :language: yaml
        :emphasize-lines: 4,6,8,10,12,14 
        :linenos:

6. Run the pipeline
    GOMAP has 6 distinct steps for running the pipeline after setup. The steps are as follows seqsim, domain, mixmeth-blast, mixmeth-preproc, mixmeth and aggregate.
    
    1) seqsim

        .. code-block:: bash

            ./run-GOMAP-SINGLE.sh --step=seqsim --config=test/config.yml
        
    #) domain

        .. code-block:: bash
        
            ./run-GOMAP-SINGLE.sh --step=domain --config=test/config.yml

    #) mixmeth-blast 

        .. attention ::
        
            Depending on the tag used when downloading the image, this step can be spedup using MPI. MPI version should match the version installed on the HPC cluster.

        .. code-block:: bash

            ./run-GOMAP-SINGLE.sh --step=mixmeth-blast --config=test/config.yml
        
        .. tip::
            Steps 1-3 can be run at the same time, because they do not depend on each other. Subsequent steps do depend on each other so they can be run only one step at a time.

    #) mixmeth-preproc

        .. code-block:: bash
            
            ./run-GOMAP-SINGLE.sh --step=mixmeth-preproc --config=test/config.yml
    
    #) mixmeth

        .. code-block:: bash
            
            ./run-GOMAP-SINGLE.sh --step=mixmeth --config=test/config.yml

    #) aggregate

        .. code-block:: bash
            
            ./run-GOMAP-SINGLE.sh --step=aggregate --config=test/config.yml

6. Final dataset will be available in the ``GOMAP-[basename]/gaf/aggregate/basename-aggregate.gaf``. **[basename]** will be defined in the config.yml file that was used as the input