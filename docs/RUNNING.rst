.. _RUNNING:

Running GOMAP
=============

1. Install (local) or load (HPC) `Singularity <https://www.sylabs.io/guides/3.1/user-guide/index.html>`_ container (version 3.5.2).

    .. code-block:: bash
        
        #On HPC Systems
        module load singularity
        # Sometimes specific version has to be loaded as 
        module load singularity/3.5.2

2. Clone the git repository

    .. code-block:: bash

        mkdir -p /path/to/GOMAP-singularity/install/location
        git clone https://github.com/Dill-PICL/GOMAP-singularity.git /path/to/GOMAP-singularity/install/location 
        git checkout v1.3.5
        cd /path/to/GOMAP-singularity/install/location        

3. Run the setup step to make necessary directories and download data files from CyVerse
    
    1. Run setup

        .. code-block:: bash
            
            ./setup.sh

        .. attention::
            The pipeline download is large and would require ~40GB of free hard drive space during the **setup** step.


        .. important::
            Default image downloaded will be built for mpich-3.2.1 for parallelization. Please submit a issue request on `GitHub <https://github.com/Dill-PICL/GOMAP-singularity/issues>`_ if you want the image for a different mpi version or you can download the Singularity files and build the image yourself.

4. [optional] Test whether the container and the data files are working as intended.

    i) Add your **email** to the ``test/config.yml``. This is necessary to submit jobs to Argot2.5.
    
    ii) Run the test using following command.

    .. code-block:: bash
        
        ./test.sh

    .. attention::
        This has to be performed from the GOMAP-singularity install location because the test directory location is fixed.

5. Edit the config file

    a. Declare export ``GOMAP_LOC`` environment variable

        .. code-block:: bash

            # Add this to your ~/.bashrc or run the line in the terminal
            export GOMAP_LOC="/path/to/GOMAP-singularity/install/location"    

    b. Download the `config.yml <_static/min-config.yml>`_  file and make necessary changes. Change the highlighted lines to fit your input data
    
        .. attention:: 

            A boilerplate for running GOMAP-singularity on SLURM environment has been made available on Github at `GOMAP-boilerplate <https://github.com/Dill-PICL/GOMAP-boilerplate>`_. You can follow instructions there to get to annotating faster.


    .. literalinclude:: _static/min-config.yml
        :language: yaml
        :emphasize-lines: 4,6,8,10,12,14 
        :linenos:            

6. Run the pipeline

    GOMAP has 7 distinct steps for running the pipeline after setup. The steps are listed in the table below.

    ======= ================== =========== =========== ============
    Number     Step            Single       Parallel   Concurrent
    ------- ------------------ ----------- ----------- ------------
       1     seqsim              Y           N           Y
       2     domain              Y           Y           Y
       3     fanngo             Y           N           Y
       4     mixmeth-blast       Y           Y           Y
       5     mixmeth-preproc     Y           N           N
       6     mixmeth             Y           N           N
       7     aggregate           Y           N           N
    ======= ================== =========== =========== ============

    First four steps seqsim, domain, fanngo, and mixmeth-blast can be run concurrently. This will allow the pipeline to complete faster. Subsequent steps mixmeth-preproc, mixmeth and aggregate steps depend on the output of the first four steps.


    **GOMAP-singularity helper scripts**

        GOMAP-singularity git repository has two helper scripts.

        1. run-GOMAP-SINGLE.sh
            
            This scipt can be used to run GOMAP steps 1-7 on a single machine or a single node on the cluster

        #. run-GOMAP-mpi.sh

            This scipt can be used to run GOMAP steps 2 (domain) and 4 (mixmeth-preproc) on a multiple nodes on the SLURM cluster. This step is parallelized using mpich for parallelization.
        
        .. tip :: 

            If you are familiar with singularity then you can directly run the GOMAP-singularity container with the necessary binds, but it will be easier to use the helper scripts
        
        .. attention ::
            
            Steps 1-4 can be run concurrently, because they do not depend on each other. Subsequent steps do depend on previous output so they can be run only one at a time and after the first four are finished.
    
    **The details of how to run the GOMAP steps are below**  

    i. seqsim

        .. code-block:: bash

            ./run-GOMAP-SINGLE.sh --step=seqsim --config=test/config.yml 
        
    #. domain

        **Running on a Single node**

        .. code-block:: bash
        
            ./run-GOMAP-SINGLE.sh --step=domain --config=test/config.yml

        **Running on a multiple nodes (MPI)**

        .. warning ::

            Slurm job scheduler will be required to use mpi to work with the scripts provided. This will also require the correct version of MPI for the container
        
        .. attention ::

            The line 16 from the config file should be changed to true enable mpi. If this is set to false then the mpi will not be enabled

        .. literalinclude:: _static/min-config-mpi.yml
            :language: yaml
            :emphasize-lines: 16 
            :linenos: 

        **Slurm commands needed for successful sbatch submission**

        .. code-block:: bash

            # This can be any number of nodes, but 10-20 has been optimal
            #SBATCH -N 10

            #SBATCH --ntasks-per-node=1
            #SBATCH --cpus-per-task=16 #or the CPU for each node
            
        You may also need to load the mpich module on HPC systems.
        
        .. code-block:: bash
        
                #On HPC Systems
                module load mpich

                #Or it might be packaged as part of MVAPICH
                module load mvapich

        .. code-block:: bash

            ./run-GOMAP-mpi.sh --step=domain --config=test/config.yml

    #. fanngo

        .. code-block:: bash

            ./run-GOMAP-SINGLE.sh --step=fanngo --config=test/config.yml 

    #. mixmeth-blast

        **Running on a Single node**

        .. code-block:: bash

            ./run-GOMAP-SINGLE.sh --step=mixmeth-blast --config=test/config.yml
    
        **Running on a multiple nodes (MPI)**

        .. code-block:: bash

            ./run-GOMAP-mpi.sh --step=mixmeth-blast --config=test/config.yml
        
        The ``--nodes`` and ``--cpus-per-task`` can be optimized based on the cluster for slurm schedulers

    #. mixmeth-preproc

        .. code-block:: bash
            
            ./run-GOMAP-SINGLE.sh --step=mixmeth-preproc --config=test/config.yml
    
    #. mixmeth

        .. code-block:: bash
            
            ./run-GOMAP-SINGLE.sh --step=mixmeth --config=test/config.yml

         
        .. attention ::

            The mixmeth step sumbits annotation jobs to Argot2.5 webserver. Please wait till you have received the job completion emails before you run the next step

    #. aggregate
    
        .. attention ::

            Please wait for all your Argot2.5 jobs to finish before running this step. You will get emails from Argot2.5 when your jobs are submitted and when they are finished. You can also check the status of all current jobs from all users `here <http://www.medcomp.medicina.unipd.it/Argot2-5/viewSGE.php>`_.


        .. code-block:: bash
            
            ./run-GOMAP-SINGLE.sh --step=aggregate --config=test/config.yml

6. Final dataset will be available at ``GOMAP-[basename]/gaf/e.agg/[basename].aggregate.gaf``. **[basename]** is defined in the config.yml file that was used
