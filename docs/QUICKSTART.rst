.. QUICKSTART:

Quick Start
===========

1. Clone the git repository

.. code-block:: bash

    mkdir -p /path/to/GOMAP-singularity/install/location
    git clone https://github.com/Dill-PICL/GOMAP-singularity.git /path/to/GOMAP-singularity/install/location
    cd /path/to/GOMAP-singularity/install/location
    

2. Run the setup script to make necesary directories and download data files from Cyverse

.. code-block:: bash
    
    ./setup-GOMAP.sh

3. [optional] Test whether the container and the data files are working as intended. 

.. code-block:: bash
    
    ./test-GOMAP.sh

.. attention::
    This has to be perfomed from the GOMAP-singularity install location because the test directory location is fixed.