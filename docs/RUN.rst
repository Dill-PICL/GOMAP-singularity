.. _RUN:

Run
===

Running GOMAP
-------------

1. GOMAP can be run using the 

.. attention::
    Please make sure you have installed the necessary :ref:`REQUIREMENTS` and run the :ref:`INSTALL` steps to install GOMAP-singularity and the necessary data 

.. code-block:: bash

    instance_name="GOMAP"
    img_loc="/path/to/GOMAP-singularity/install/location/$instance_name.simg"
    mkdir -p $PWD/tmp

    singularity instance.start \
        --bind $PWD/GOMAP-data/mysql/lib:/var/lib/mysql \
        --bind $PWD/GOMAP-data/mysql/log:/var/log/mysql \
        --bind $PWD/GOMAP-container:/opt/GOMAP \
        --bind $PWD/GOMAP-data:/opt/GOMAP/data \
        --bind $PWD:/workdir \
        -W $PWD/tmp \
        $img_loc $instance_name && \
    singularity run  \
        instance://$instance_name $@