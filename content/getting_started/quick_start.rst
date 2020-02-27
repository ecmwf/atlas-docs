Quick start
###########

.. role:: yellow
    :class: m-text m-warning

.. role:: green
    :class: m-text m-success

Atlas has a convenience script ``install.sh`` that may work for you, or may be an inspiration on how to adapt installation to your needs.
This script is also capable to install required and certain optional dependencies.

.. note-info::

    For an in depth installation manual see the `Downloading and building <{filename}/getting_started/installation.rst>`_ page.

Basic system requirements
=========================

`CMake <http://www.cmake.org/.>`_
---------------------------------

- Minimum required version: 3.6 or greater
- :yellow:`Recommended version: 3.14 or greater`

CMake is often already available on your system.
If version requirements are incompatible, prebuilt CMake :green:`binary distribution` may be downloaded
`here <https://cmake.org/download/#latest>`_

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

Quick install
=============

The Atlas build system is based on `CMake` which tries to automatically detect compilers and project dependencies.
To avoid suprises make sure that the following environment variables
are pointing to the correct compiler.

- ``CC``   -- Path to C compiler
- ``CXX``  -- Path to C++ compiler
- ``FC``   -- Path to Fortran compiler

Download atlas and invoke the ``install.sh`` script:

.. code:: shell

    mkdir sources
    git clone https://github.com/ecmwf/atlas sources/atlas
    sources/atlas/tools/install.sh --with-deps

This installs ``atlas``, and downloads/installs its required dependencies ``eckit`` and ``fckit`` in a subdirectory ``install``.
The install prefix, and other build options can be modified with extra arguments to the ``install.sh`` script.

Please check options, e.g. by calling

.. code:: shell

    sources/atlas/tools/install.sh --help

Optional third party dependencies are automatically detected by CMake.
If these dependencies are not installed in standard locations,
or there is a version mismatch, these optional features will be disabled.
For a more detailed guide on finding the correct dependencies,
check the `Downloading and building <{filename}/getting_started/installation.rst>`_ page.

In particular, if optional dependencies FFTW, CGAL or GridTools are not already installed,
they can be installed in the same ``install`` directory with additional arguments:

.. code:: shell

    source/atlas/tools/install.sh --with-deps --enable-fftw --enable-cgal --enable-gridtools


.. container:: m-row

  .. container:: m-col-l-4 m-center-l
    
        .. block-warning:: Create your own project!
        
            Now that Atlas is installed, it is time to create your own project!
        
            .. button-warning:: {filename}/getting_started/linking.rst
                :class: m-fullwidth
        
                Continue

