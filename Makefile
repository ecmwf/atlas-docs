
SHELL := /bin/bash

PY?=python3

PELICAN?=source venv/bin/activate && pelican
GENERATE_DOXYFILE?=source venv/bin/activate && python scripts/generate_doxyfile.py
DOXYGEN?=source venv/bin/activate && doxygen.py
DOXYGEN_API=c++
INPUTDIR=$(CURDIR)/content
OUTPUTDIR=$(CURDIR)/build/html
CONFFILE=$(CURDIR)/pelican/pelicanconf.py

# Public hosting configuration
SSH_USER?=deploy
SSH_HOST?=download-int
SSH_PATH?=/download/data/test-data/atlas/docs/site

# Source directories for eckit and atlas
ATLAS_SOURCE_DIR ?= false
ECKIT_SOURCE_DIR ?= false

WITH_ECKIT ?= 0

PUBLIC ?= 0
DEBUG ?= 0
VERSION ?= 0

PELICANOPTS=
GENERATEDOXYOPTS=
ifeq ($(PUBLIC), 1)
	GENERATEDOXYOPTS += --public
	CONFFILE=$(CURDIR)/pelican/publishconf.py
endif
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif
ifeq ($(WITH_ECKIT),1)
    GENERATEDOXYOPTS += --with-eckit
endif
ifneq ($(VERSION),0)
    GENERATEDOXYOPTS += --version=$(VERSION)
endif

help:
	@echo 'Makefile for atlas documentation                                          '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make devserver [PORT=8000]          serve and regenerate together      '
	@echo '   make rsync-upload                   upload the web site via rsync+ssh  '
	@echo '   make clean                          remove the generated files         '
	@echo '   make clean-venv                     remove the venv                    '
	@echo '   make clean-downloads                remove the downloads               '
	@echo '   make distclean                      remove downloads, venv, build      '
	@echo '                                                                          '
	@echo 'Set the ATLAS_SOURCE_DIR variable to existing path to avoid git download  '
	@echo 'Set the ECKIT_SOURCE_DIR variable to existing path to avoid git download  '
	@echo 'Set the WITH_ECKIT variable to 1/0 to add/avoid eckit within C++ API      '
	@echo '                                                                          '
	@echo 'Set the PUBLIC variable to 1 before uploading, e.g. make PUBLIC=1 clean html    '
	@echo '                                                                          '

html: build/html/index.html
	@echo "[atlas-docs] Generated html at $(CURDIR)/build/html"
	@echo "[atlas-docs] To visualise, execute \"make serve\" and open browser at \"http://localhost:8000\""

build/html/index.html: build/html/$(DOXYGEN_API)/index.html
	@echo [atlas-docs] Building Pelican documentation
	@$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

build/html/$(DOXYGEN_API)/index.html: build/doxygen/html/index.html
	@echo [atlas-docs] Copy doxygen generated C++ api to build/html/$(DOXYGEN_API)
	@mkdir -p build/html
	@cp -r build/doxygen/html build/html/$(DOXYGEN_API)

build/doxygen/html/index.html: build/doxygen/Doxyfile
	@echo [atlas-docs] Building Doxygen C++ api generated at build/doxygen/html
	@$(DOXYGEN) build/doxygen/Doxyfile

build/doxygen/Doxyfile: venv/bin/activate
	@echo [atlas-docs] Generating Doxyfile \"build/doxygen/Doxyfile\"
	@$(GENERATE_DOXYFILE) $(GENERATEDOXYOPTS)

venv/bin/activate:
	@echo [atlas-docs] Pre-installing required software in virtual environment
	@scripts/setup.sh --atlas $(ATLAS_SOURCE_DIR) --eckit $(ECKIT_SOURCE_DIR)

clean:
	[ ! -d build ] || rm -rf build
	@echo "[atlas-docs] Wiped build"

clean-venv:
	[ ! -d venv ] || rm -rf venv
	@echo "[atlas-docs] Wiped venv"
       
clean-downloads:
	[ ! -d downloads ] || rm -rf downloads
	@echo "[atlas-docs] Wiped downloads"

distclean: clean clean-venv clean-downloads
	@echo "[atlas-docs] All clean now"

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

serve:
ifdef PORT
	@echo "[atlas-docs] Open browser at http://localhost:$(PORT)"
	@$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT) 
else
	@echo "[atlas-docs] Open browser at http://localhost:8000   (CTRL+C to end)"
	@$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
endif

devserver:
ifdef PORT
	$(PELICAN) -lr $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT)
else
	$(PELICAN) -lr $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
endif

doxygen: build/doxygen/html/index.html
	@echo "[atlas-docs] Doxygen generated C++ API is created here:"
	@echo "[atlas-docs]     $(CURDIR)/build/doxygen/html/index.html"

doxyfile: build/doxygen/Doxyfile
	@echo "[atlas-docs] Doxyfile generated: $(CURDIR)/build/doxygen/Doxyfile"

rsync-upload:
	rsync -avz build/html/ $(SSH_USER)@$(SSH_HOST):$(SSH_PATH)/

setup: venv/bin/activate
	@echo "[atlas-docs] Setup finished: Created virtual environment at venv"

.PHONY: help regenerate serve serve-global devserver html doxygen setup doxyfile

