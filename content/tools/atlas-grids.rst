atlas-grids
###########

:breadcrumb: {filename}/tools.rst Tools

The command-line tool ``atlas-grids`` provides information on grids supported by Atlas.

.. contents::
  :class: m-block m-default

Usage
-----

.. code-block:: shell

    $ atlas-grids <grid> [OPTION]... [--help]

For a list of supported grids, use

.. code-block:: shell

    $ atlas-grids --list

Special grids FESOM and ORCA
============================

Different FESOM and ORCA meshes are available as Atlas plugins after adding them in ``atlas-bundle/bundle.yml``:

.. code-block:: yaml

    - atlas-orca :
        git     : ${GITHUB}/ecmwf/atlas-orca
        version : develop
        require : atlas

    - atlas-fesom :
        git     : ${GITHUB}/ecmwf/atlas-fesom
        version : develop
        require : atlas

Before using FESOM and ORCA grids, we need to set environment variables:

.. code-block:: bash

    export ATLAS_ORCA_CACHING=1
    export ATLAS_FESOM_CACHING=1