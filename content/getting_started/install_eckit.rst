eckit
#####

:breadcrumb: {filename}/getting_started.rst Getting started
             {filename}/getting_started/installation.rst Downloading and building

.. role:: red
    :class: m-text m-danger


What is eckit?
================

eckit contains C++ helper classes that provides most notably following functionality to Atlas:

- Configuration
    * YAML / JSON parser
- Logging
    * Streams: Info / Warning / Error / Debug
- Hashing (MD5)
- Exception handling
- MPI abstraction with both a Parallel (true MPI) and Serial implementation
- Dense matrix and sparse matrix linear algebra abstraction with following notable backends depending on availability
    * Generic (nested for loops)
    * BLAS/LAPACK
    * MKL
    * Eigen
- Testing framework

Downloading
===========

eckit is officially maintained and available from its `ECMWF github page <https://github.com/ecmwf/eckit>`_.

The ``master`` branch tracks the latest stable release, whereas the ``develop`` branch tracks the latest developments.

To download the project at the latest release
we can type on the terminal the commands reported below:

.. code:: shell

    git clone -b master https://github.com/ecmwf/eckit.git

Installing
==========

The eckit build system is based on `CMake` which tries to automatically detect compilers and project dependencies.
To avoid suprises make sure that the following environment variables
are pointing to the correct compiler.

- ``CC``   -- Path to C compiler
- ``CXX``  -- Path to C++ compiler

Other environment variables which may help CMake (version greater than 3.12) in finding useful dependencies for Atlas:

- ``ecbuild_ROOT``  -- Path to ecbuild install prefix
- ``MPI_ROOT``      -- Path to MPI install prefix
- ``MKLROOT``       -- Path to Intel MKL install prefix
- ``Eigen3_ROOT``   -- Path to Eigen install prefix

eckit can be configured and installed as follows, to a given ``path-to-install`` as shown below:

.. code :: shell

    cd eckit
    mkdir build && cd build
    cmake ../ -DCMAKE_INSTALL_PREFIX=<path-to-install>
    make install

.. note-danger:: 

    For Atlas to be able to use MPI, make sure that the MPI feature is enabled, either by
    inspecting the output or by adding ``-DENABLE_MPI=ON`` to the ``cmake`` configuration line above.

If Atlas is the only reason to install `eckit`, it is OK to have several (undocumented) eckit features disabled.
It is then  safe to add following to the arguments to the ``cmake`` configuration above:

.. code:: shell

    -DENABLE_TESTS=OFF        \
    -DENABLE_ECKIT_SQL=OFF    \
    -DENABLE_ECKIT_CMD=OFF    \
    -DENABLE_ARMADILLO=OFF    \
    -DENABLE_VIENNACL=OFF     \
    -DENABLE_CUDA=OFF         \
    -DENABLE_AEC=OFF          \
    -DENABLE_XXHASH=OFF       \
    -DENABLE_LZ4=OFF          \
    -DENABLE_JEMALLOC=OFF     \
    -DENABLE_BZIPS2=OFF       \
    -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON

.. note-warning:: 

    For other projects to find or use eckit add following to the environment:

    .. code:: shell
    
        export eckit_ROOT=<path-to-install>
        export PATH=$eckit_ROOT/bin:$PATH
