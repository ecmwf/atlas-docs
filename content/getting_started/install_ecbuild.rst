ecbuild
#######

:breadcrumb: {filename}/getting_started.rst Getting started
             {filename}/getting_started/installation.rst Downloading and building

.. role:: red
    :class: m-text m-danger


What is ecbuild?
================

ecbuild is project that contains a collection of CMake macros

Downloading
===========

ecbuild is officially maintained and available from its `ECMWF github page <https://github.com/ecmwf/ecbuild>`_.

The ``master`` branch tracks the latest stable release, whereas the ``develop`` branch tracks the latest developments.

To download the project at the latest release
we can type on the terminal the commands reported below:

.. code:: shell

    git clone -b master https://github.com/ecmwf/ecbuild.git

Installing
==========

As ecbuild only consists of CMake scripts, it does not need any compiler.

.. code :: shell

    cd ecbuild
    mkdir build && cd build
    cmake ../ -DCMAKE_INSTALL_PREFIX=<path-to-install>
    make install

.. note-warning::

    For other projects to find or use ecbuild add following to the environment:

    .. code:: shell
    
        export ecbuild_ROOT=<path-to-install>
        export PATH=$ecbuild_ROOT/bin:$PATH
