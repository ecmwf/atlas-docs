cmake_minimum_required( VERSION 3.12 )

project( hello_world VERSION 1.0.0 LANGUAGES CXX Fortran )

# Setup CMake behaviour
set( CMAKE_RUNTIME_OUTPUT_DIRECTORY    ${CMAKE_BINARY_DIR}/bin )
set( CMAKE_LIBRARY_OUTPUT_DIRECTORY    ${CMAKE_BINARY_DIR}/lib )
set( CMAKE_ARCHIVE_OUTPUT_DIRECTORY    ${CMAKE_BINARY_DIR}/lib )
set( CMAKE_INSTALL_RPATH               ${CMAKE_INSTALL_PREFIX}/lib )
set( CMAKE_INSTALL_RPATH_USE_LINK_PATH True )

#############################################
### Optionally add dependencies as subprojects

option( BUNDLE "Bundle dependencies as subprojects" OFF)
  # Can be enabled with `-DBUNDLE=ON`

if( BUNDLE )
    # Note that this case means that the source codes for 
    # each of the following dependencies is required to 
    # be available inside this directory, which may be
    # achieved via e.g. `copy`, `symbolic links`,
    #   `git submodule`, ...

    # Set features for Atlas and dependencies
    set( ENABLE_MPI   ON  CACHE BOOL "" FORCE )
    set( ENABLE_TESTS OFF CACHE BOOL "" FORCE )
    
    # Add Atlas and dependencies as subprojects
    add_subdirectory( ecbuild )
    add_subdirectory( eckit )
    add_subdirectory( fckit )
    add_subdirectory( atlas )

endif()

#############################################
### Main project build

# Find package atlas
find_package( atlas REQUIRED COMPONENTS FORTRAN )

# Define a C++ executable and link with atlas
add_executable( hello-atlas src/hello-atlas.cc )
target_link_libraries( hello-atlas PUBLIC atlas )

# Define a Fortran executable and link with atlas_f
add_executable( hello-atlas_f src/hello-atlas_f.F90 )
target_link_libraries( hello-atlas_f PUBLIC atlas_f )

#############################################
### Installation

install( TARGETS hello-atlas hello-atlas_f
     RUNTIME DESTINATION bin )

