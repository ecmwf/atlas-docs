fckit
#####

:breadcrumb: {filename}/getting_started.rst Getting started
             {filename}/getting_started/installation.rst Downloading and building

.. role:: red
    :class: m-text m-danger


What is fckit?
================

fckit contains Fortran helper classes, many implemented by eckit in C++,
that provides most notably following functionality to the Atlas Fortran interfaces

- Configuration
    * YAML / JSON parser
- Logging
    * Streams: Info / Warning / Error / Debug
- Exceptions
- MPI abstraction with both a Parallel (true MPI) and Serial implementation
- Testing framework for Fortran (`fctest`)
- Powerful Fortran preprocessor based on `fypp <https://github.com/aradi/fypp>`_

Downloading
===========

fckit is officially maintained and available from its `ECMWF github page <https://github.com/ecmwf/fckit>`_.

The ``master`` branch tracks the latest stable release, whereas the ``develop`` branch tracks the latest developments.

To download the project at the latest release
we can type on the terminal the commands reported below:

.. code:: shell

    git clone -b master https://github.com/ecmwf/fckit.git

Installing
==========

The fckit build system is based on `CMake` which tries to automatically detect compilers and project dependencies.
To avoid suprises make sure that the following environment variables
are pointing to the correct compiler.

- ``CC``       -- Path to C compiler
- ``CXX``      -- Path to C++ compiler
- ``Fortran``  -- Path to Fortran compiler

Other environment variables which may help CMake (version greater than 3.12) in finding useful dependencies for Atlas:

- ``ecbuild_ROOT``  -- Path to ecbuild install prefix
- ``eckit_ROOT``    -- Path to eckit install prefix

fckit can be configured and installed as follows, to a given ``path-to-install`` as shown below:

.. code :: shell

    cd fckit
    mkdir build && cd build
    cmake ../ -DCMAKE_INSTALL_PREFIX=<path-to-install>
    make install

If Atlas is the only reason to install `fckit`, it is OK to have several (undocumented) features disabled.
It is then  safe to add following to the arguments to the ``cmake`` configuration above:

.. code:: shell

    -DENABLE_TESTS=OFF

.. note-warning:: 

    For other projects to find or use fckit add following to the environment:

    .. code:: shell
    
        export fckit_ROOT=<path-to-install>
        export PATH=$fckit_ROOT/bin:$PATH
