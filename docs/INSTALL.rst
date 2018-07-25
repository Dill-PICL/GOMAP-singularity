.. _INSTALL:

Install
=======

Installing via GOMAP-singularity scripts (Recommended)
``````````````````````````````````````````````````````

Obtaining and installing GOMAP-Singularity can be done with the set of scripts which can be obtained from `https://github.com/Dill-PICL/GOMAP-singularity <https://github.com/Dill-PICL/GOMAP-singularity>`_

1. Clone the git repository

.. code-block:: bash

    mkdir -p /path/to/GOMAP-singularity/install/location
    git clone https://github.com/Dill-PICL/GOMAP-singularity.git /path/to/GOMAP-singularity/install/location
    cd /path/to/GOMAP-singularity/install/location 
    

2. Run the setup script to make necesary directories and download data files from Cyverse

.. code-block:: bash
    
    ./setup-GOMAP.sh

3. Test whether the container and the data files are working as intended. This has to be perfomed from the GOMAP-singularity install location because the test directory location is fixed.

    3.1. Add a valid email address to the ``test/config.yml``
    
        .. literalinclude:: ../test/config.yml
            :language: yaml 
            :emphasize-lines: 12
            :linenos:

    3.2.Run the test using the ``test-GOMAP.sh`` script

        .. code-block:: bash
            
            ./test-GOMAP.sh

4. Make Necessary Changes to run-GOMAP.sh.
    
    Change the ``gmap_loc`` to ``/path/to/GOMAP-singularity/install/location``
    
    .. literalinclude:: _static/run-GOMAP.sh
        :language: bash
        :emphasize-lines: 4
        :linenos:

    .. tip::
        To make the GOMAP-singularity scripts available from any location add the ``/path/to/GOMAP-singularity/install/location`` to the ``$PATH`` variable

Manual Install
``````````````

**GOMAP-Singularity** comes in two parts

 1. The GOMAP Singularity container
 2. The data and tools needed to run GOMAP-Singularity

The GOMAP-Singularity **container**
-----------------------------------

The GOMAP-Singularity conainer can be obtained from multiple sources. `Singularity Hub`_ would be the easiest way obtain the container from.

Singularity Hub
***************

This options requires you to have singulaity-container tools installed if not check  :ref:`REQUIREMENTS` on steps about how to install singularity.

The GOMAP-singularity container is available at the following location. 
`https://www.singularity-hub.org/collections/1176 <https://www.singularity-hub.org/collections/1176>`_

.. code-block:: bash

    singularity pull --name GOMAP.simg shub://Dill-PICL/GOMAP-singularity



The **data and tools** needed to run GOMAP-Singularity
------------------------------------------------------

The compressed dataset and the associated tools are available at `CyVerse <http://www.cyverse.org>`_

.. attention::
    The data file download size is ~37GB and the extracted version is ~110GB. So please make sure the download location has at least ~160 GB free space to download and extract the data

The compressed tar file is available to download at the following location but it can only be downloaded via icommands
`http://datacommons.cyverse.org/browse/iplant/home/shared/dillpicl/GOMAP/GOMAP-data.tar.gz <http://datacommons.cyverse.org/browse/iplant/home/shared/dillpicl/GOMAP/GOMAP-data.tar.gz>`_

Download with icommands
***********************

.. code-block:: bash

    #you can use irsync tool to download the image
    irsync i:/iplant/home/shared/dillpicl/GOMAP/GOMAP-data.tar.gz /path/to/download

    #or you can use the iget tool to download the image
    iget /iplant/home/shared/dillpicl/GOMAP/GOMAP-data.tar.gz /path/to/download

Run the setup step from the container
*************************************

We have added a setup step within the GOMAP-singularity container to enable easy data download. This step will download and extract the data to the correct location. 

.. tip::
    Starting the instance to setup the data from allows you to download and extract the data to the correct subdirectory with the following commands

1. Make a tmp directory in the install location to store tmp files for the running instance

.. code-block:: bash

    mkdir -p $PWD/tmp

2. Start an instance and bind the correct locations to download and extract the data

.. code-block:: bash

    singularity instance.start \
        --bind /path/to/install/location/GOMAP-data:/opt/GOMAP/data \
        --bind $PWD:/workdir \
        -W $PWD/tmp \
        /path/to/image/GOMAP.simg GOMAP

3. Run the setup step with a temporary ``min-config.yml`` file that can be downloaded from `here <_static/min-config.yml>`_

.. code-block:: bash

    singularity run  \
            instance://$instance_name --step=setup --config=test/config.yml




4. [Optional] Run GOMAP-Singularity with the test data to see if the container and data work well together.

    4.1. Add a valid email address to the ``test/config.yml``
    
        .. literalinclude:: ../test/config.yml
            :language: yaml 
            :emphasize-lines: 12
            :linenos:

    3.2.Run the test using the following command

        .. code-block:: bash

            singularity run  \
                instance://GOMAP --step=setup --config=test/config.yml