cmake_minimum_required( VERSION 3.12 )

find_package( ecbuild 3.0 ) # Required before project()

project( myproject VERSION 1.0.0 LANGUAGES CXX )

find_package( atlas REQUIRED )

ecbuild_add_library( TARGET mylib
    SOURCES
         src/mylib/myclass1.h
         src/mylib/myclass1.cc 
         src/mylib/myclass2.h
         src/mylib/myclass12.cc
    PUBLIC_INCLUDES
         $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src>
         $<INSTALL_INTERFACE:include>
    PUBLIC_LIBS        atlas
    INSTALL_HEADERS    ALL
    HEADER_DESTINATION include/mylib )

ecbuild_add_executable( TARGET myexe
    SOURCES src/programs/myexe.cc
    LIBS    mylib )

ecbuild_print_summary()
ecbuild_install_project( NAME myproject )




