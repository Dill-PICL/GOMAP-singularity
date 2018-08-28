#!/usr/bin/env bash

if [ $# -ne 3 ]
then
    echo "Please check the number of input arguments"
    echo "run-SINGLE.sh config_file step number_of_nodes"
    echo "run-SINGLE.sh test/config.yml seqsim 1"
    exit
fi

config=$1
step=$2
nodes=$3
name=`cat $config | grep -v "#" | fgrep basename | cut -f 2 -d ":" | tr -d ' '`
echo $name
echo -e "#!/bin/bash
#SBATCH -N $nodes
#SBATCH --ntasks-per-node 28
#SBATCH -p RM
#SBATCH -t 48:00:00
#SBATCH --job-name=GOMAP-$name-$step
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
    $GOMAP_LOC --step=$step --config=$config" > "GOMAP-$name-$step.job"
