transi
######

:breadcrumb: {filename}/getting_started.rst Getting started
             {filename}/getting_started/installation.rst Downloading and building

.. role:: red
    :class: m-text m-danger


What is transi?
===============

transi contains a C interface and Fortran implementation of the IFS spectral transforms library `trans`.


Downloading
===========

transi is officially maintained and available from its `ECMWF git page <https://git.ecmwf.int/scm/atlas/transi>`_.

.. note-warning::

    Note that the IFS trans library is not open-source, and therefore this library is not available for download,
    unless specific access permissions have been granted.

The ``master`` branch tracks the latest stable release, whereas the ``develop`` branch tracks the latest developments.

To download the project at the latest release
we can type on the terminal the commands reported below:

.. code:: shell

    git clone -b master https://git.ecmwf.int/scm/atlas/transi

Installing
==========

The transi build system is based on `CMake` which tries to automatically detect compilers and project dependencies.
To avoid suprises make sure that the following environment variables
are pointing to the correct compiler.

- ``CC``       -- Path to C compiler
- ``CXX``      -- Path to C++ compiler
- ``Fortran``  -- Path to Fortran compiler

Other environment variables which may help CMake (version greater than 3.12) in finding useful dependencies for Atlas:

- ``ecbuild_ROOT``  -- Path to ecbuild install prefix
- ``MPI_ROOT``      -- Path to MPI install prefix
- ``MKL_ROOT``      -- Path to Intel MKL install prefix
- ``FFTW_ROOT``     -- Path to FFTW install prefix

transi can be configured and installed as follows, to a given ``path-to-install`` as shown below:

.. code :: shell

    cd transi
    mkdir build && cd build
    cmake ../ -DCMAKE_MODULE_PATH=$ecbuild_ROOT/share/cmake/ecbuild \
              -DCMAKE_INSTALL_PREFIX=<path-to-install>
    make install

If Atlas is the only reason to install `transi`, it is OK to have several (undocumented) features disabled.
It is then  safe to add following to the arguments to the ``cmake`` configuration above:

.. code:: shell

    -DENABLE_TESTS=OFF

.. note-warning:: 

    For other projects to find or use transi add following to the environment:

    .. code:: shell
    
        export transi_ROOT=<path-to-install>
        export PATH=$transi_ROOT/bin:$PATH
