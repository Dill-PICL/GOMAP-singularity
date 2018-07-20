.. _maize-GAMER: https://onlinelibrary.wiley.com/doi/abs/10.1002/pld3.52
.. _logging: https://docs.python.org/2/library/logging.html

.. _CONFIG:

Detailed Configuration
======================

This page gives you all the configuration options that are available for the GOMAP pipeline which can be changed. The config file has 5 section and nested subsection within each section.



Input
-----

Basic section that can be changed without affecting the results of GOMAP. 

.. literalinclude:: _static/pipeline.yml
        :language: yaml
        :linenos:
        :lines: 1-14

Data
----

This section has the necessary configuration settings for each component method used in GOMAP. The main settings are listed below

1. Locations to write temporary directories
2. Necessary data files for each step (e.g. UniProt data, TAIR data etc)

.. literalinclude:: _static/pipeline.yml
        :language: yaml
        :linenos:
        :lines: 16-21,35-36,39-40

Sequence Similarity
*******************

The configuration options for Sequence Similarity based Component methods. 

``species`` can be changed to change the GAF file output name

.. literalinclude:: _static/pipeline.yml
        :language: yaml
        :lines: 20-34
        :linenos:

Domain Presence
***************
Domain presence settings which is only contains data about InterProScan version. The option that can be changed is the name of the tool to enable renaming the output files from InterProScan5

.. literalinclude:: _static/pipeline.yml
        :language: yaml
        :lines: 35-38
        :linenos:

Mixed-Methods
*************

Two mixed-methods are used GOMAP 1) PANNZER and Argot2.5. Both require preprocessing to be able to annotate GO terms to proteins. 

.. caution::
        The set score thresholds are calculated based on the `maize-GAMER`_ publication. Change only if you know what you are doing.

.. literalinclude:: _static/pipeline.yml
        :language: yaml
        :lines: 40-57
        :linenos:

GAF
***
This section lets you configure the file locations for the intermediate and final output files

.. literalinclude:: _static/pipeline.yml
        :language: yaml
        :lines: 59-65
        :linenos:

GO
***
This section lets you configure the file locations for the obo file for gene ontology

.. literalinclude:: _static/pipeline.yml
        :language: yaml
        :lines: 66-77
        :linenos:


Software
--------
This section lets you configure the options for the software used by GOMAP. Optional arguments that can affect performance and accuracy can be adjusted

.. literalinclude:: _static/pipeline.yml
        :language: yaml
        :lines: 78-104
        :linenos:


Logging
-------
The settings for the information in the log files. Check Python `logging`_ for more information.

.. literalinclude:: _static/pipeline.yml
        :language: yaml
        :lines: 106-115
        :linenos: