# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    = -H 0.0.0.0
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
	sphinx-autobuild $(SPHINXOPTS) . $(BUILDDIR)

clean: 
	$(RM) /var/www/gomap.blunderingbioinformatics.org/html/*

build:
	@$(SPHINXBUILD) "$(SOURCEDIR)" "$(BUILDDIR)" $(O)	
	rsync -rluv $(BUILDDIR)/ /var/www/gomap.blunderingbioinformatics.org/html/
