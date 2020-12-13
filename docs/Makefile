# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    = 
SPHINXBUILD   = sphinx-build
SPHINXPROJ    = GOMAP-Singularity
SOURCEDIR     = .
BUILDDIR      = _build
RM            = rm -rf

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

livehtml:
	sphinx-autobuild $(SPHINXOPTS) --host 0.0.0.0 . $(BUILDDIR) -D version=$(version) -D release=$(release)

clean:
	$(RM) /var/www/bioinformapping.com/html/gomap/*

buildmult:
	sphinx-multiversion $(O) "$(SOURCEDIR)" "$(BUILDDIR)" 

build:
	@$(SPHINXBUILD) "$(SOURCEDIR)" "$(BUILDDIR)" $(O) -D version=$(version) -D release=$(release)

syncDocs:
	rsync -rluv $(BUILDDIR)/ /var/www/bioinformapping.com/html/gomap/
	
