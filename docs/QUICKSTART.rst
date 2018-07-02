.. QUICKSTART:

Quick Start
===========

1. Clone the git repository

.. code-block:: bash

    mkdir -p /path/to/GOMAP-singularity/install/location
    git clone --recursive https://github.com/Dill-PICL/GOMAP-singularity.git /path/to/GOMAP-singularity/install/location
    cd /path/to/GOMAP-singularity/install/location
    

2. Run the setup script to make necesary directories and download data files from Cyverse

.. code-block:: bash
    
    ./setup-GOMAP.sh

.. attention::
    The pipeline download is huge and would require ~150GB free during the setup step.

3. [optional] Test whether the container and the data files are working as intended. 

.. code-block:: bash
    
    ./test-GOMAP.sh

.. attention::
    This has to be perfomed from the GOMAP-singularity install location because the test directory location is fixed.

4. Make Necessary Changes to run-GOMAP.sh. Especially change the ``$gomap_loc`` if necessary
    
    .. literalinclude:: ../run-GOMAP.sh
        :language: bash
        :emphasize-lines: 4 
        :linenos:
 
5. Copy the ``config.yml`` file from test directory and make necessary Changes
    Change the 

    .. literalinclude:: ../test/config.yml
        :language: yaml
        :emphasize-lines: 4,6,8,12,14 
        :linenos:

6. Run the pipeline
    i). Run the preprocess step

        .. code-block:: bash
        
            ./run-GOMAP.sh --step=preprocess --config=test/config.yml

        At the end of preprocess step batch jobs are submitted to the Argot2.5 Webserver. The server will send you emails when these jobs are completed. Please wait for the job completion emails befor running the next step.

    ii). Run the aggregate step

        .. code-block:: bash
        
            ./run-GOMAP.sh --step=aggregate --config=test/config.yml

        This step will take all the preprocessed data and create GAF 2.0 files. The GAF files will be cleaned and aggregated and the aggregate dataset will be generated in the agg directory.
