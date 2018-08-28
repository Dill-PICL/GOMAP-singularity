#!/usr/bin/env bash

step=$1
config=$2
nodes=$3
echo -e "#!/bin/bash
#SBATCH -N $nodes
#SBATCH --ntasks-per-node 28
#SBATCH -p RM
#SBATCH -t 48:00:00
#SBATCH --job-name=GOMAP-$step
#SBATCH --mail-type=ALL
#SBATCH --mail-user=kokul@iastate.edu
#SBATCH -o %j.out
#SBATCH -e %j.err
#SBATCH -C EGRESS

module load mpi/gcc_mvapich  singularity/2.6.0

singularity run  \n \
    --bind $GOMAP_DATA_LOC/GOMAP-data/mysql/lib:/var/lib/mysql \n\
    --bind $GOMAP_DATA_LOC/GOMAP-data/mysql/log:/var/log/mysql \n\
    --bind $GOMAP_DATA_LOC/GOMAP-data:/opt/GOMAP/data \n\
    --bind $PWD:/workdir \n\
    --bind $tmpdir:/tmpdir \n\
    -W $PWD/tmp \n\
    $GOMAP_LOC --step=$step --config=$config" > "GOMAP-$step.job"
