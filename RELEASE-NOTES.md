# Release v1.3.7

## Bug fixes

* Removed the exceedingly large `big_split` parameter that caused some issues with `Argot2.5`

## Enhancements

* Changes the hmmscan to hmmsearch for the mixed-method step
* Added a step to copy the uniprot database to the /tmpdir to make sure the blast CPU performance is increased


# Release v1.3.5
~~~~
## Bug fixes

* This update fixes some issues with running GNU Octave within singularity when the contain all parameter is used for running the container. This was brought up by @huh688 in the original repo.

# Release v1.3.4

## Bug fixes

* Downloading the GOMAP image from [CyVerse Data Commons](https://datacommons.cyverse.org/browse/iplant/home/shared/dillpicl/gomap/GOMAP)
* [#18](https://github.com/Dill-PICL/GOMAP-singularity/issues/18) that slows down FANN-GO annotation support when large number of input sequences are used
* Documentation has been updated to reflect the requirement changes in this release at [https://bioinformapping.com/gomap/](https://bioinformapping.com/gomap/)

