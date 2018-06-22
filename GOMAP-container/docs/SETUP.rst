Setting up GO-MAP
=================

What are the steps needed to setup the pipeline?
------------------------------------------------

#. Install dependencies

#. Install required packages for R and Python

-  A shell script is provided to make the installation of the packages
   easy.

-  Run ``bash install/install_packages.sh`` from GAMER-pipeline
   directory

-  Users with a python2 virtual environment please activate before
   running the script

#. Setup MySQL database for Pannzer

-  Create a database named pannzer

-  Create a user names pannzer and grant all privileges on the database
   pannzer

-  The password should be ``pannzer``

-  If you decide to change any of this, please update the config.json
   [mix-meth.PANNZER.database] file accordingly.
