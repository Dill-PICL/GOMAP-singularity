.. _RUNNING:

Running GOMAP
=============

1. Install (local) or load (HPC) `Singularity <https://www.sylabs.io/guides/2.6/user-guide/index.html>`_ container (version 2.6.0).

    .. code-block:: bash
        
        #On HPC Systems
        module load singularity

2. Clone the git repository

    .. code-block:: bash

        mkdir -p /path/to/GOMAP-singularity/install/location
        git clone https://github.com/Dill-PICL/GOMAP-singularity.git /path/to/GOMAP-singularity/install/location
        cd /path/to/GOMAP-singularity/install/location
        

3. Run the setup step to make necessary directories and download data files from CyVerse

    1. [Optional] Configure the irods environment
        The setup step requires the use of icommands and if you have used icommands then no configuration is necessary if not configured  
    
        .. code-block:: bash

            cd /path/to/GOMAP-singularity/install/location
            mkdir -p $HOME/.irods && cp irods_environment.json $HOME/.irods
    
    2. Run the setup step

        .. code-block:: bash
            
            ./run-GOMAP-SINGLE.sh --config=test/config.yml --step=setup

        .. attention::
            The pipeline download is large and would require ~150GB of free hard drive space during the **setup**.
        
        .. literalinclude:: ../run-GOMAP-SINGLE.sh
            :language: bash
            :lines: 1-8
            :emphasize-lines: 8
            :linenos:

        .. attention::
            Line number 8 which is highlighted can be edited to add a tag at the end of the line (e.g. :condo, :bridges, :comet). This would allow images built for different HPC clusters and MPI version to be downloaded. If no tag is used then the image downloaded will have MPI is disabled.

4. [optional] Test whether the container and the data files are working as intended.

    i) Add your **email** to the ``test/config.yml``. This is necessary to submit jobs to Argot2.5.
    
    ii) Run the test using following command.

    .. code-block:: bash
        
        ./test-GOMAP.sh

    .. attention::
        This has to be performed from the GOMAP-singularity install location because the test directory location is fixed.

4. Add the necessary variables for the installation

    a. Add ``/path/to/GOMAP-singularity/install/location`` to your ``$PATH`` variable.

        .. code-block:: bash

            # Add this to your ~/.bashrc
            export PATH="$PATH:/path/to/GOMAP-singularity/install/location

    b. Declare export ``GOMAP_LOC`` environment variable

        .. code-block:: bash

            # Add this to your ~/.bashrc or run the line in the terminal
            export GOMAP_LOC="/path/to/GOMAP-singularity/install/location"

    c. Declare export ``MATLAB_LOC`` environment variable

        .. code-block:: bash

            # Add this to your ~/.bashrc or run the line in the terminal
            export MATLAB_LOC="/path/to/MATLAB/R201xa/"
            # An example location is given below. This will change for each cluster
            export MATLAB_LOC="/usr/local/MATLAB/R2017a/"
        
        .. attention ::

            The matlab location is automatically bound by the run-GOMAP-SINGLE.sh script. This is only necessary for running the FANN-GO step. Please check with the cluster to identify if MATLAB is available for use and the exact location MATLAB is installed in.

5. Edit the config file

    Download the `config.yml <_static/min-config.yml>`_  file and make necessary changes. Change the highlighted lines to fit your input data


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
       3     fanngo*             Y           N           Y
       4     mixmeth-blast       Y           Y           Y
       5     mixmeth-preproc     Y           N           N
       6     mixmeth             Y           N           N
       7     aggregate           Y           N           N
    ======= ================== =========== =========== ============

    First four steps seqsim, domain, fanngo, and mixmeth-blast can be run concurrently. This will allow the pipeline to complete faster. Susequent steps mixmeth-preproc, mixmeth and aggregate steps depend on the output from the first three steps.


    **GOMAP-singularity helper scripts**

        GOMAP-singularity git repository has two helper scripts.

        1. run-GOMAP-SINGLE.sh
            
            This scipt can be used to run GOMAP steps 1-7 on a single machine or a single node on the cluster

        #. run-GOMAP-mpi.sh

            This scipt can be used to run GOMAP steps 2 and 4 on a multiple nodes on the SLURM cluster. This uses mpich for parallelization of the domain and mixmeth-blast steps
        
        .. tip :: 

            If you are familiar with singularity then you can directly run the GOMAP-singularity container with the necessary binds, but it will be easier to use the helper scripts
        
        .. attention ::
            
            Steps 1-4 can be run at the same time, because they do not depend on each other. Subsequent steps do depend on each other so they can be run only one step at a time.

            ***fanngo** step depends on matlab, and is optional if the step is not run then the annotations will not contain FANN-GO predictions
    
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

            Slurm job scheduler will be requires to use mpi to work with the scripts provided. This will also require the correct version of the container to be downloaded (condo, bridges, comet)
        
        .. attention ::

            The line 16 from the config file should be changed to true enable mpi. If this is set to false then the mpi will not be enabled

        .. literalinclude:: _static/min-config-mpi.yml
            :language: yaml
            :emphasize-lines: 16 
            :linenos: 

        **Slurm commands needed for successful sbatch submission**

        .. code-block:: bash

            # This can be 
            #SBATCH -N 10

            #SBATCH --ntasks-per-node=1
            #SBATCH --cpus-per-task=16

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
        
        The ``--nodes`` and ``--cpus-per-task`` can be optimized based on the cluster

    #. mixmeth-preproc

        .. code-block:: bash
            
            ./run-GOMAP-SINGLE.sh --step=mixmeth-preproc --config=test/config.yml
    
    #. mixmeth

        .. code-block:: bash
            
            ./run-GOMAP-SINGLE.sh --step=mixmeth --config=test/config.yml

         
        .. attention ::

            The mixmeth step sumbits annotation jobs to Argot2.5 webserver. Please wait till you have received the job completion emails before you run the next step

    #. aggregate


        .. code-block:: bash
            
            ./run-GOMAP-SINGLE.sh --step=aggregate --config=test/config.yml

6. Final dataset will be available at ``GOMAP-[basename]/gaf/agg/[basename].aggregate.gaf``. **[basename]** is be defined in the config.yml file that was used
