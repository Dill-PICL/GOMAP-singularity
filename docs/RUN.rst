.. _RUN:

Run
===

.. code-block:: bash

    instance_name="GOMAP"
    img_loc="/mnt/raid/lab_data/go_annotation/GOMAP-singularity/$instance_name.simg"
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

1. setup [optional]
2. preprocess 
3. annotate 
4. test    

setup
-----

The GOMAP-Singularity **container**
-----------------------------------

The GOMAP-Singularity **container**
-----------------------------------

