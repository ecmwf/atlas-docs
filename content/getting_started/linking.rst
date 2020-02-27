
Linking Atlas into your project
###############################

:breadcrumb: {filename}/getting_started.rst Getting started

.. role:: green
    :class: m-text m-success

.. role:: warn
    :class: m-text m-warning

.. contents::
  :class: m-block m-default

Guide on how to find and link Atlas into your project

Using CMake
===========

As Atlas is itself built with the CMake build system, it is very convenient to include Atlas
in your own CMake project.

Finding Atlas
-------------

There are two approaches available, with tradeoffs for each.

- Using a pre-installed Atlas
- Bundling Atlas as a subproject

Using a pre-installed Atlas
`````````````````````````````
This is the recommended option if Atlas is not part of your developments,
and rather used as a stable third-party library. You then don't need to
add the overhead of Atlas compilation to each new build of your project.
On the other hand, it is less convenient to try out different build types,
compilers or other build options.

To aid `CMake` in finding Atlas, you can export ``atlas_ROOT`` in the environment

.. code :: bash

  export atlas_ROOT=<path-to-atlas-install-prefix>

Within your own CMake project, then simply add

.. code:: cmake

    find_package( atlas REQUIRED COMPONENS FORTRAN )

The ``REQUIRED`` keyword is optional and causes CMake to exit with error if `atlas` was not found.

When atlas is found, the available atlas CMake :green:`targets` will be defined:

- ``atlas``  -- The core C++ library
- ``atlas_f`` -- The Fortran interface library :warn:`(only available if the atlas FORTRAN feature was enabled)`

Additionally also following CMake :green:`variables` will be defined:

- ``atlas_FOUND`` -- `True` if atlas was found correctly
- ``atlas_HAVE_FORTRAN`` -- `True` if the atlas FORTRAN feature was enabled
- ``atlas_HAVE_MPI`` -- `True` if atlas is capable to run in a MPI parallel context
- ``atlas_HAVE_TESSELATION`` -- `True` if the atlas TESSELATION feature was enabled
- ``atlas_HAVE_TRANS`` -- `True` if the atlas TRANS feature was enabled

.. block-info:: Tip

    To ensure that atlas was compiled with the FORTRAN feature enabled during the ``find_package()`` call, instead it is possible to call

    .. code:: cmake
    
        find_package( atlas REQUIRED COMPONENTS FORTRAN )

.. block-danger:: Troubleshooting

    Detection of packages using ``<package>_ROOT`` variables within ``find_package()`` is only available since CMake 3.12,
    but has become the recommended (standard) behaviour.
    
    However, even when using CMake 3.12 or greater, this behaviour is only enabled by default when the CMake project is declared with
    
    .. code:: cmake
    
        cmake_minimimum_required( VERSION 3.12 )

    When using CMake 3.12 but the minimum required version is lower than 3.12,
    you can enable the desired behaviour within your project, e.g. by
    
    .. code:: cmake

        cmake_minimum_required( VERSION 3.6 )
        if( POLICY CMP0074 )
          cmake_policy( SET CMP0074 NEW )
          # This policy allows to search for packages with <package>_ROOT variables
          #                        (only supported with CMake 3.12 and above)
          # This policy can be removed once cmake_minimum_required( VERSION 3.12 ) is used
        endif()

    When using older CMake versions (prior to version 3.12) you may have to export ``atlas_DIR``
    in the environment to the directory where a file called ``atlas-config.cmake`` resides.
    
    .. code :: bash
    
      export atlas_DIR=$atlas_ROOT/lib/cmake/atlas
    
    For forward compatibility you can alternatively not define ``atlas_DIR`` but add
    ``HINTS`` to ``find_package()`` instead:
    
    .. code:: cmake
    
        find_package( atlas REQUIRED 
                      HINTS ${atlas_ROOT}
                            ${atlas_ROOT}/lib/cmake/atlas
                            $ENV{atlas_ROOT}
                            $ENV{atlas_ROOT}/lib/cmake/atlas )
    
    For the full documentation of ``find_package()`` see the
    `CMake documentation <https://cmake.org/cmake/help/latest/command/find_package.html>`_.

Bundling Atlas as a subproject
``````````````````````````````

A self-contained alternative to a shared instance of the libraries,
is to add atlas and its required depenencies directly into your project (as Git submodules,
bundling downloaded archives etc.), and then to use CMake's ``add_subdirectory()``
command to compile them on demand.
With this approach, :green:`you don't need to
care about manually installing atlas`, fckit, eckit, and ecbuild;
however the usual tradeoffs when bundling code apply — slower full rebuilds,
IDEs having more to parse etc. 
Conveniently, in this case, build-time options can be set
before calling add_subdirectory(). Note that it's necessary to use
the ``CACHE ... FORCE`` arguments in order to have the options set properly.

.. code:: cmake

    # Set features required for Atlas
    set( ENABLE_MPI         ON CACHE BOOL "" FORCE )
    set( ENABLE_TESSELATION ON CACHE BOOL "" FORCE )

    # Add Atlas and its dependencies as subprojects
    add_subdirectory( ecbuild )
    add_subdirectory( eckit )
    add_subdirectory( fckit )
    add_subdirectory( atlas )

    find_package( atlas REQUIRED )

.. note-warning::

    Projects that are built like this with subprojects should be treated as standalone
    bundles. In other words, if they are deployed, only its executables should be used,
    whereas its libraries should not be linked to, unless you are absolutely sure what you're
    doing.

Linking your CMake library or executable with Atlas
---------------------------------------------------

To use the C++ API of Atlas all you need to do to link
the ``atlas`` target to your target is using the ``target_link_libraries()``:

.. code:: cmake

    add_library( library_using_atlas
        source_using_atlas_1.cc
        source_using_atlas_2.cc )
    
    target_link_libraries( library_using_atlas PUBLIC atlas )

Atlas include directories, compile definitions, and required C++ language
flags (e.g. ``-std=c++11``) are automatically added to your target.

Complete CMake example
----------------------

We now show a full example of a mixed C++ / Fortran project, describing the
two approaches in finding Atlas. The project contains two executables that simply
print "Hello from atlas" implemented respectively in C++ and Fortran.

In the case of pre-installed Atlas the project's directory structure should be::

    project/
      ├── CMakeLists.txt
      └── src/
            ├── hello_atlas.cc
            └── hello_atlas_f.F90

In the case of bundling Atlas dependencies as subprojects, the project's directory structure should instead be::

    project/
      ├── CMakeLists.txt
      ├── src/
      │     ├── hello_atlas.cc
      │     └── hello_atlas_f.F90
      ├── ecbuild/
      ├── eckit/
      ├── fckit/
      └── atlas/

The bundled dependencies can be e.g. added as git submodules, symbolic links,
or downloaded/added manually/automatically.

The content of the ``CMakeLists.txt`` at the project root contains

.. include:: ../project_bundle_atlas/CMakeLists.txt
  :code: cmake

Inspection of this ``CMakeLists.txt`` file shows that for this project we created
a ``BUNDLE`` option to toggle the behaviour of either bundling the dependencies or not.
To enable the bundling, the argument ``-DBUNDLE=ON`` needs to be passed
on the cmake configuration command line.

- The content of ``hello_atlas.cc`` is:

.. include:: ../project_bundle_atlas/src/hello-atlas.cc
  :code: c++

- The content of ``hello_atlas_f.cc`` is:

.. include:: ../project_bundle_atlas/src/hello-atlas_f.F90
  :code: fortran

Using pkgconfig
===============

The ecbuild CMake scripts provide the Atlas installation with :green:`pkgconfig` files
that contain the instructions for the required include directories, link directories
and link libraries.

Given that the variable ``atlas_ROOT`` is present, we can compile the same
``hello_atlas.cc`` file above, using

.. code:: shell

  ATLAS_INCLUDES=$(pkg-config $atlas_ROOT/lib/pkgconfig/atlas.pc --cflags)
  ATLAS_LIBS=$(pkg-config $atlas_ROOT/lib/pkgconfig/atlas.pc --libs)

  $CXX hello-atlas.cc -o hello-atlas $ATLAS_INCLUDES $ATLAS_LIBS

.. note-danger ::

  Due to the complex nature of how atlas dependencies are defined, and linked, 
  the pkg-config files may not always be generated correctly.
  We don't officially support this method.
