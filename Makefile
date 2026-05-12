SHELL := /bin/bash

help:
	@echo 'Makefile for the Atlas documentation                                        '
	@echo '                                                                            '
	@echo 'Usage:                                                                      '
	@echo '                                                                            '
	@echo '   make html                           (re)generate the web site            '
	@echo '   make regenerate                     regenerate the website               '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000  '
	@echo '   make devserver [PORT=8000]          serve and regenerate together        '
	@echo '   make clean                          remove build                         '
	@echo '   make clean-venv                     remove venv                          '
	@echo '   make clean-downloads                remove downloads                     '
	@echo '   make distclean                      remove downloads, venv, build        '
	@echo '                                                                            '
	@echo 'Global options:                                                             '
	@echo '                                                                            '
	@echo 'Set ATLAS_SOURCE_DIR to an existing path to avoid git download              '
	@echo 'Set ECKIT_SOURCE_DIR to an existing path to avoid git download              '
	@echo '                                                                            '
	@echo 'CMake options:                                                              '
	@echo '                                                                            '
	@echo 'Set WITH_DOXYGEN to 1/0 to skip Doxygen C++ API                             '
	@echo 'Set WITH_ECKIT to 1/0 to add/avoid eckit within Doxygen C++ API             '
	@echo 'Set WITH_LATEX to 1/0 to add/avoid LaTeX within Doxygen C++ API             '
	@echo '                                                                            '

WITH_ECKIT ?= 0
WITH_DOXYGEN ?= 1
WITH_LATEX ?= 1

# Source directories for eckit and atlas
ATLAS_SOURCE_DIR ?= false
ECKIT_SOURCE_DIR ?= false


PUBLIC ?= 0
DEBUG ?= 0
VERSION ?= 0

PY?=python3
PELICAN?=source venv/bin/activate && WITH_DOXYGEN=$(WITH_DOXYGEN) WITH_LATEX=$(WITH_LATEX) pelican
GENERATE_DOXYFILE?=source venv/bin/activate && python scripts/generate_doxyfile.py
DOXYGEN?=source venv/bin/activate && doxygen.py
DOXYGEN_API=c++

INPUTDIR=$(CURDIR)/content
OUTPUTDIR=$(CURDIR)/build/html
CONFFILE=$(CURDIR)/scripts/pelican/pelicanconf.py
PORT ?= 8000

CONTENT_FILES := $(shell find $(INPUTDIR) -type f)
PELICAN_CONFIG_FILES := $(shell find $(CURDIR)/scripts/pelican -type f)

PELICANOPTS=
GENERATEDOXYOPTS=
SETUPOPTS=

ifeq ($(PUBLIC), 1)
	GENERATEDOXYOPTS += --public
	CONFFILE=$(CURDIR)/scripts/pelican/publishconf.py
endif
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif
ifeq ($(WITH_DOXYGEN),1)
    SETUPOPTS += --doxygen
endif
ifeq ($(WITH_ECKIT),1)
    GENERATEDOXYOPTS += --with-eckit
endif
ifneq ($(VERSION),0)
    GENERATEDOXYOPTS += --version=$(VERSION)
endif

html: build/html/index.html
	@echo "[atlas-docs] Generated html at $(CURDIR)/build/html"
	@echo "[atlas-docs] To visualise, execute \"make serve\" and open browser at \"http://localhost:8000\""

build/html/index.html: content/generated/atlas_release_version.rst build/html/$(DOXYGEN_API)/index.html $(CONTENT_FILES) $(PELICAN_CONFIG_FILES)
	@echo "[atlas-docs] Building Pelican documentation"
	@$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

build/html/$(DOXYGEN_API)/index.html: build/doxygen/html/index.html
	@echo "[atlas-docs] Copy doxygen generated C++ api to build/html/$(DOXYGEN_API)"
	@mkdir -p build/html
	@cp -r build/doxygen/html build/html/$(DOXYGEN_API)

build/doxygen/html/index.html: build/doxygen/Doxyfile
ifeq ($(WITH_DOXYGEN),1)
	@echo [atlas-docs] Building Doxygen C++ api generated at build/doxygen/html
	@$(DOXYGEN) build/doxygen/Doxyfile
else
	@echo "[atlas-docs] Building dummy Doxygen file (WITH_DOXYGEN=0)"
	@mkdir -p build/doxygen/html
	@touch build/doxygen/html/index.html
	@touch build/doxygen/atlas.tag
endif

build/doxygen/Doxyfile: venv/bin/activate
	@echo "[atlas-docs] Generating Doxyfile \"build/doxygen/Doxyfile\""
	@$(GENERATE_DOXYFILE) $(GENERATEDOXYOPTS)

content/generated/atlas_release_version.rst:
	@mkdir -p content/generated
	@version=$$(curl -fsSL https://api.github.com/repos/ecmwf/atlas/releases/latest | sed -n 's/.*"tag_name":[[:space:]]*"\([^"]*\)".*/\1/p' | head -1); \
	if [[ -z "$$version" ]]; then \
		echo "[atlas-docs] ERROR: could not fetch latest Atlas release version from GitHub"; \
		exit 1; \
	fi; \
	printf ".. |atlas-release-version| replace:: %s\n" "$$version" > content/generated/atlas_release_version.rst; \
	echo "[atlas-docs] Latest Atlas release: $$version"

venv/bin/activate:
	@echo "[atlas-docs] Pre-installing required software in virtual environment"
	@scripts/setup.sh --atlas $(ATLAS_SOURCE_DIR) --eckit $(ECKIT_SOURCE_DIR) $(SETUPOPTS)

clean:
	[ ! -d build ] || rm -rf build m.math.cache
	@echo "[atlas-docs] Wiped build"

clean-venv:
	[ ! -d venv ] || rm -rf venv
	@echo "[atlas-docs] Wiped venv"
       
clean-downloads:
	[ ! -d downloads ] || rm -rf downloads
	@echo "[atlas-docs] Wiped downloads"

distclean: clean clean-venv clean-downloads
	@echo "[atlas-docs] All clean now"

regenerate: content/generated/atlas_release_version.rst
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

serve: html
	@echo "[atlas-docs] Open browser at http://localhost:$(PORT) (CTRL+C to end)"
	@$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT) 

devserver: content/generated/atlas_release_version.rst
	@echo "[atlas-docs] Open browser at http://localhost:$(PORT) (CTRL+C to end)"
	$(PELICAN) -lr $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT)

doxygen: build/doxygen/html/index.html
	@echo "[atlas-docs] Doxygen generated C++ API is created here:"
	@echo "[atlas-docs]     $(CURDIR)/build/doxygen/html/index.html"

doxyfile: build/doxygen/Doxyfile
	@echo "[atlas-docs] Doxyfile generated: $(CURDIR)/build/doxygen/Doxyfile"

setup: venv/bin/activate
	@echo "[atlas-docs] Setup finished: Created virtual environment at venv"

.PHONY: help regenerate serve devserver html doxygen setup doxyfile

