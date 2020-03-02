
Downloading and building
########################

:breadcrumb: {filename}/getting_started.rst Getting started

.. role:: warn
    :class: m-text m-warning

.. role:: info
    :class: m-text m-info

.. role:: yellow
    :class: m-text m-warning

.. role:: green
    :class: m-text m-success

.. role:: red
    :class: m-text m-danger

.. |br| raw:: html

  <br/>

.. contents::
  :class: m-block m-default

.. container:: m-row

  .. container:: m-col-l-6 m-center-l
    
        .. block-warning:: Quick start!
        
            Atlas provides a quick installation script to get started as quickly as possible
        
            .. button-warning:: {filename}/getting_started/quick_start.rst
                :class: m-fullwidth
        
                Get started


Basic system requirements
=========================

Operating sytem
---------------

Atlas requires a POSIX compliant operating system. This includes:

- Linux
- MacOSX (Darwin)

Compilers
---------

Atlas requires a C++ compiler that supports the :yellow:`C++11` standard.
The optional Atlas Fortran API requires a Fortran compiler that supports the :yellow:`Fortran 2008` standard.

Tested compilers include:

- GNU 6.3, 7.3, 8.3
- Intel 18, 19
- PGI 17.7, 19.10
- Cray 8.7
- Clang C++ 7, 9 :yellow:`+` GNU Fortran

`CMake <http://www.cmake.org/.>`_
---------------------------------

- Minimum required version: 3.6 or greater
- :yellow:`Recommended version: 3.14 or greater`

`CMake <http://www.cmake.org/.>`_ is often already available on your system.
If version requirements are incompatible, prebuilt CMake :green:`binary distribution` may be downloaded
`here <https://cmake.org/download/#latest>`_


Dependencies
============

Atlas is distributed as Git repository and is officially maintained at the `ECMWF github space <https://github.com/ecmwf/atlas>`_.
It however relies on several dependencies to be pre-installed. Following figure illustrates how the dependencies interconnect.
Below are links to each of them, with installation instructions.

.. figure:: {static}/img/dependency_graph.png
    :alt: Image alt text
    :target: {static}/img/dependency_graph.pdf

    Dependency graph of Atlas
    
    - Solid lines: required dependency
    - Dotted lines: optional dependency, enabling features detailed in green
    - Yellow boxes are required (fckit is required for Fortran interface)
    - The package *transi* (cyan colored) is currently not open-source
    - The packages on the right (white) are third party (non-ECMWF) open-sourced

Atlas aims to stay compatible with latest versions of dependencies (as of Atlas release date),
and hence latest versions of dependencies are recommended.
Please `contact <{filename}/contact.rst>`_ us if in doubt.

`Required dependencies`_
------------------------

For C++ API of Atlas:

- `C++ <http://www.cplusplus.com/>`_ compiler: :yellow:`C++11 standard support required`

- `CMake <http://www.cmake.org/.>`_: Build system (meta-build system) used to compile Atlas

- `ecbuild <https://github.com/ecmwf/ecbuild>`_: It implements some CMake macros that 
  are used within the Atlas build system. For more brief information and to install,
  check the `ecbuild installation instructions <{filename}/getting_started/install_ecbuild.rst>`_

- `eckit <https://github.com/ecmwf/eckit>`_: It implements some useful C++
  functionalities useful for Atlas. For more brief information and to install, 
  check the `eckit installation instructions <{filename}/getting_started/install_eckit.rst>`_

:green:`For Fortran API of Atlas, additional required dependencies:`

- `Fortran <https://en.wikipedia.org/wiki/Fortran>`_ compiler: :yellow:`Fortran 2008 standard support required`.

- `fckit <https://github.com/ecmwf/fckit>`_ : It implements some useful 
  Fortran functionalities. This is only needed when Fortran bindings are required.
  For more brief information and to install,
  check the `fckit installation instructions <{filename}/getting_started/install_fckit.rst>`_

- `Python <https://www.python.org/>`_ : Required to generate Fortran interfaces

Optional dependencies
---------------------

- `MPI <https://www.open-mpi.org/>`_: Required for distributed memory parallelisation.

- `OpenMP <http://openmp.org/wp/>`_: Required for shared memory 
  parallelisation. For use see.
  As OpenMP is implemented within compilers, it is not
  possible to install it yourself.

- `CGAL <https://www.cgal.org/>`_: Required for enabling tesselation using
  Delaunay triangulation of unstructured grids.

- `Eigen3 <http://eigen.tuxfamily.org/>`_ : Linear algebra library that
  should not impact any Atlas internal performance.

- `FFTW <http://www.fftw.org/>`_ -- FFT library that improves efficiency of inverse spherical harmonics transforms (TransLocal).
  (Version 3.3.4 minimum required)

- `BLAS <http://www.netlib.org/blas/>`_ / `LAPACK <http://www.netlib.org/lapack/>`_ -- Linear Algebra libraries that improve efficiency of inverse spherical harmonics transforms (TransLocal).
  This library is typically available on the system, and preferred implementation is available within Intels MKL library.

- `transi <https://git.ecmwf.int/projects/ATLAS/repos/transi/>`_ -- For enabling IFS spherical harmonics transforms (TransIFS).
  This exposes an MPI parallel implementation for both direct and inverse
  spherical harmonics transforms.
  :warn:`Note that transi is currently not open-source and requires a license agreement with ECMWF!`
  For more brief information and to install,
  check the `transi installation instructions <{filename}/getting_started/install_transi.rst>`_
  
- `GridTools <https://github.com/GridTools/gridtools>`_ -- For enabling GPU capability using CUDA in C++ or OpenACC in Fortran (compiler permitting).
  
- `Proj <https://proj.org/>`_ -- For enabling Proj4 projections for grids. This is allows for projections that are not
  natively supported in Atlas.

Installation Instructions
=========================

Before building, make sure all `Required dependencies`_ are available, as well as the required `Optional dependencies`_
for the desired `Optional features`_ detailed below.

.. block-warning:: Installation instructions for several dependencies

    - `ecbuild » <{filename}/getting_started/install_ecbuild.rst>`_
    - `eckit » <{filename}/getting_started/install_eckit.rst>`_
    - `fckit » <{filename}/getting_started/install_fckit.rst>`_
    - `transi » <{filename}/getting_started/install_transi.rst>`_

Once we have downloaded, compiled and installed required dependencies,
we can now proceed to download and install.

Downloading Atlas
-----------------

atlas is officially maintained and available from its `ECMWF github page <https://github.com/ecmwf/atlas>`_.

The ``master`` branch tracks the latest stable release, whereas the ``develop`` branch tracks the latest developments.

To download the project at the latest release
we can type on the terminal the commands reported below:

.. code:: shell

    git clone -b master https://github.com/ecmwf/atlas.git

Building Atlas
--------------

The `atlas` build system is based on `CMake` which tries to automatically detect compilers and project dependencies.
To avoid suprises make sure that the following environment variables
are pointing to the correct compiler.

- ``CC``       -- Path to C compiler
- ``CXX``      -- Path to C++ compiler
- ``Fortran``  -- Path to Fortran compiler

Other environment variables which may help CMake :warn:`(version greater than 3.12)` in finding required and optional dependencies for Atlas:

- ``ecbuild_ROOT``   -- Path to ecbuild install prefix
- ``eckit_ROOT``     -- Path to eckit install prefix
- ``fckit_ROOT``     -- Path to fckit install prefix
- ``transi_ROOT``    -- Path to transi install prefix
- ``GridTools_ROOT`` -- Path to GridTools install prefix
- ``CGAL_ROOT``      -- Path to CGAL install prefix
- ``FFTW_ROOT``      -- Path to FFTW install prefix
- ``PROJ4_ROOT``     -- Path to Proj install prefix
- ``Eigen3_ROOT``    -- Path to Eigen install prefix

atlas can be configured and installed as follows, to a given ``path-to-install`` as shown below:

.. code :: shell

    cd atlas
    mkdir build && cd build
    cmake ../ -DCMAKE_INSTALL_PREFIX=<path-to-install>
    make -j8

The number ``8`` in the argument ``-j8`` to ``make`` speeds up compilation by using 8 threads.
This number can be tuned to maximise compilation speed.

Optional features
`````````````````

.. block-warning:: Controlling features

    Some features of Atlas become only available when optional dependencies are found, or when the feature is explicitely requested.
    To manually enable or disable a feature, you can use the CMake variables ``ENABLE_<FEATURE>=(ON|OFF)``, where ``<FEATURE>``
    needs to be replaced by the feature name as given in following section.

    To disable the compilation of Atlas Fortran interfaces e.g., add ``-DENABLE_FORTRAN=OFF`` to the `cmake` command line described above.

FORTRAN
"""""""
This feature enables the compilation of the Atlas Fortran interface and is ``ON`` by default.
It requires availability of the package :info:`fckit` and a :info:`python` executable. If not available,
this feature will be disabled automatically.

MPI
"""

This feature enables the capability of Atlas to have parallel distributed data structures and algorithms. It requires the availability
of :info:`MPI`.

.. note-danger ::

    This feature is in fact not an Atlas feature, but a eckit feature, and should be applied during the configuration of eckit! 
    By default eckit is compiled with this feature enabled.

OMP
"""
This feature enables the capability of OpenMP shared memory parallelism for algorithms within Atlas and is ``ON`` by default,
but depends on the :info:`OpenMP` implementation within the compilers.

TESSELATION
"""""""""""
This feature, ``ON`` by default, enables the `Delaunay` mesh generator,
which allows to generate a mesh by tesselating an unstructured grid using Delaunay triangulation.
It requires the availability of the :info:`CGAL` optional dependency.

GRIDTOOLS_STORAGE
"""""""""""""""""
With this feature enabled, the underlying data memory storage is handled by ``GridTools``. It therefore depends on the availability
of :info:`GridTools`.
When ``GridTools`` is compiled with CUDA available, then the Atlas arrays are allocated both on the host (CPU) and device (GPU).
It is then possible to use atlas fields within CUDA kernels, and OpenACC.

ACC
"""
This feature allows the use of OpenACC, provided that the feature ``GRIDTOOLS_STORAGE`` is also enabled.
It is ``ON`` by default, but depends on the :info:`OpenACC` implementation within the compilers.

TRANS
"""""
This feature, ``ON`` by default, enables the `TransIFS` spectral transforms capability.
It allows to perform direct and inverse spectral transforms in an MPI distributed parallel context.
:yellow:`The scope is limited only to global (Reduced) Gaussian grids!`
It requires the availability of the :info:`transi` optional dependency, which requires :red:`private access permissions` at ECMWF,
as it is not open-source.

PROJ
""""
This feature, ``OFF`` by default grid projections defined by `Proj`, and relies on the package :info:`Proj` to be available.

TESTS
"""""
This feature enables the compilation of Atlas unit tests.

Testing Atlas
-------------

The Atlas tests are managed by ``ctest`` which is bundled with the `CMake` software.
To launch the tests, navigate to the build directory and execute ::

    ctest --output-on-failure

To run only tests matching a certain regular expression, execute

.. code:: shell

    ctest --output-on-failure -R <regex>

To get output from tests that pass, execute

Installing Atlas
----------------

To install atlas, navigate to the build directory, and simply execute ::

    make install

.. note-warning:: 

    For other projects to find or use atlas add following to the environment:

    .. code:: shell
    
        export atlas_ROOT=<path-to-install>
        export PATH=$atlas_ROOT/bin:$PATH


Inspecting the Atlas installation
==================================

Once installation of atlas is complete, an executable called ``atlas``
can be found within the Atlas install directory. Executing 

::

    export PATH=$atlas_ROOT/bin:$PATH

.. code-figure::

    ::
    
        atlas --version
    
    ::
    
        0.20.0

.. code-figure::

    ::
    
        atlas --git

    ::

        c18afe1feba4

.. code-figure::

    ::
    
        atlas --info
    
    ::

        atlas version (0.20.0), git-sha1 c18afe1
     
          Build:
            build type      : RelWithDebInfo
            timestamp       : 20200226173051
            op. system      : Linux-4.4.140-62-default (linux.64)
            processor       : x86_64
            c compiler      : GNU 7.3.0
              flags         :  -pipe -O2 -g -DNDEBUG
            c++ compiler    : GNU 7.3.0
              flags         :  -pipe -O2 -g -DNDEBUG
            fortran compiler: GNU 7.3.0
              flags         :  -O2 -g -DNDEBUG
     
          Features:
            Fortran        : ON
            MPI            : ON
            OpenMP         : ON
            BoundsChecking : OFF
            Init_sNaN      : OFF
            Trans          : ON
            FFTW           : ON
            Eigen          : OFF
            MKL            : OFF
            Tesselation    : OFF
            ArrayDataStore : Native
            idx_t          : 32 bit integer
            gidx_t         : 64 bit integer
     
          Dependencies: 
            eckit version (1.4.7),  git-sha1 566091e
            fckit version (0.6.6),  git-sha1 592f58b
            transi version (0.7.0), git-sha1 588e46f
            trans version (transi/contrib - CY46R1), git-sha1 588e46f

returns information respectively on:

- the version,
- a more detailed git-version-controlled identifier
- a more complete view on all the features that Atlas has been compiled with,
  as well as compiler and compile flag information. |br|
  Also printed is the versions of used dependencies such as eckit and transi.

:warn:`Note that the output may vary in your case depending on features and versions.`
