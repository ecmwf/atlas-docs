atlas-grids
###########

:breadcrumb: {filename}/tools.rst Tools

The command-line tool ``atlas-grids`` provides information on grids supported by Atlas.

.. contents::
  :class: m-block m-default

Usage
-----

.. code :: shell

    $ atlas-grids <grid> [OPTION]... [--help]

For a list of supported grids, use

.. code :: shell

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
        git     : ${BITBUCKET}/~nawd/atlas-fesom
        version : main
        require : atlas