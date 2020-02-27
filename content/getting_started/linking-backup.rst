
Using Atlas in your project
===========================

\label{s:using}
In this section, we provide a simple example on how to use Atlas.
The objective here is not to get familiar with the main 
functionalities of Atlas, but rather to show how to get started!
Specifically, we will show a simple `Hello world` program that
initialises and finalises the library, and uses the internal Atlas
logging facilities to print "Hello world!".
The steps necessary to compile and run the program will be detailed
in this section.

Note that the Atlas supports both C++ and Fortran, therefore, 
in the following, we will show both an example using C++ and 
an example using Fortran. Before starting, we create a folder 
called \inlsh{project1} in the \inlsh{sources} directory:

::

  mkdir -p $SRC/project1

Here, we will add both the C++ and Fortran files of this 
simple example. Note that there are (at least) two ways 
to compile the code we are going to write. The first involves 
just using a C compiler for the C++ version and a Fortran 
compiler for the Fortran version, without using any cmake 
files. The second involves using cmake files. In the following, 
we will detail both possibilities.

C++ version
-----------

\label{s:atlas-hello-world-C}

Program description
```````````````````

The C++ version of the Atlas initialization and finalization
calls is depicted in \lista{code1-C}.
%
\lstinputlisting[caption=Initialization and finalization 
of Atlas using C++, style=CStyle, label=code1-C]{hello-world.cc}
%
We can create a new file in the folder \inlsh{project1} just generated::

    touch $SRC/project1/hello-world.cc

and copy the content of the code in \lista{code1-C} into it.
We can now have a closer look at the code.
On line 1, we include the Atlas header file, we successively 
specify a simple main function, in which we call the initialization 
of the Atlas library on line 6.
Note that we passed the two arguments of the main function 
\inltc{argc} and \inltc{argv} to the ``atlas_init`` 
function.
We finally call the Atlas ``atlas_finalize()`` function 
at line 8 without passing any argument to it.

The function ``atlas_init()`` is responsible for 
setting up the logging facility and for the initialization
of MPI (Message Passage Interface), 
while the function ``atlas_finalize()`` 
is responsible for finalizing MPI and closing the program.
On line 7, we log "Hello world!2 to the ``info`` log
channel.

Atlas provides 4 different log channels which can be configured
separately: \inltc{debug}, \inltc{info}, \inltc{warning}, and
\inltc{error}. By default, the \inltc{debug} channel does not
get printed; the \inltc{info} and \inltc{warning} channel get 
printed to the std::cout stream, and the \inltc{error} channel
gets printed to std::cerr. For more information on the logging
facility, the reader is referred to section~\ref{s:utilities-logging}.

Code compilation
````````````````

We now need to compile the code. We first create a new directory
into the \inlsh{\$BUILDS} folder, where we will compile the code::

  mkdir -p $BUILDS/project1

As mentioned above, there are (at least) two ways for compiling 
the source code above. These are detailed below.
%
\begin{description}
%
\item \underline{Directly with C++ compiler}\\[0.5em]
%
The first possibility is to 
avoid using cmake and ecbuild and directly run a C++ compiler, 
such as g++. For doing so, especially when Atlas is linked statically,
we need to know all Atlas dependent libraries. This step can be easily
achieved by inspecting the file::

  cat $INSTALL/atlas/lib/pkgconfig/atlas.pc

Here, all the flags necessary for the correct compilation 
of the C++ code in \lista{code1-C} are reported. For 
compiling the code, we first go into the builds directory 
just created and we generate a new folder where the executables 
will be stored::

  cd $BUILDS/project1
  mkdir -p bin

Note that, when using the cmake compilation route, it is not 
necessary to generate the bin directory since it will automatically 
created during compilation.
After having generated the bin folder, we can run the following 
command::

  g++ $SRC/project1/hello-world.cc -o bin/atlas_c-hello-world \ 
  $(pkg-config $INSTALL/atlas/lib/pkgconfig/atlas.pc --libs --cflags)

This will compile our hello-world.cc file and it will automatically 
link all the static and dynamic libraries required by the program. 
The executable, as mentioned, is generated into the folder bin.

\item \underline{CMake/ecbuild}\\[0.5em]

The second possibility is to create an ecbuild project, which is 
especially beneficial for projects with multiple files, libraries,
and executables.
In particular, we need to create the following 
cmake file::

    # File: CMakeLists.txt
    cmake_minimum_required(VERSION 2.8.4 FATAL_ERROR)
    project(usage_example)
    
    include(ecbuild_system NO_POLICY_SCOPE)
    ecbuild_requires_macro_version(1.9)
    ecbuild_declare_project()
    ecbuild_use_package(PROJECT atlas REQUIRED)
    ecbuild_add_executable(TARGET   atlas_c-usage_example
                           SOURCES  hello-world.cc 
                           INCLUDES ${ATLAS_INCLUDE_DIRS}
                           LIBS     atlas)
    ecbuild_print_summary()

in the sources folder of our project \inlsh{\$SRC/project1}.
We can create the \inlsh{CMakeLists.txt} file in the correct 
directory following the two steps below::

    cd $SRC/project1
    touch CMakeLists.txt

and copy the CMake code above into it.
In the second line of the CMake file above, we declare the minimum 
cmake version required to compile the code, while in the second 
line we declare the name of our ecbuild project. 
From line 5 to line 7 we include some required ecbuild macros 
necessary for using ecbuild. On line 8 we specify that the 
Atlas library is required for this project. Finally, on line 
9 we add the instruction to compile the executable.
Line 13 prints just a compilation summary.
We can build this simple ecbuild project by going into our builds 
directory ::

    cd $BUILDS/project1

and by typing the following command::

    ecbuild -DATLAS_PATH=$INSTALL/atlas $SRC/project1/
    make

Note that in the above command we needed to provide the path 
to the Atlas library installation. Alternatively,
\inlsh{ATLAS\_PATH} may be defined as an environment variable.
This completes the compilation of our first example that
uses Atlas and generates an executable into the bin folder
(automatically generated by cmake) inside our builds directory
for project1.
\end{description}
%

Run the code
````````````

After the compilation of the source code is completed, 
we have an executable file into the folder \inlsh{\$BUILDS/project1/bin/}.
If we simply run the executable file as follows::

    ./atlas_c-hello-world

we obtain the output::

    [0] (2016-03-09 T 15:07:15) (I) -- Hello world!

However, by adding \inlsh{\ddash{debug}} to the command line,
also debug information is printed.
In particular, if we type::

    ./atlas_c-hello-world --debug

we should obtain something similar to the following output::

    [0] (2016-03-09 T 15:09:42) (D) -- Atlas program [atlas_c-hello-world]
    [0] (2016-03-09 T 15:09:42) (D) --   atlas version [0.6.0]
    [0] (2016-03-09 T 15:09:42) (D) --   atlas git     
      [dabb76e9b696c57fbe7e595b16f292f45547d628]
    [0] (2016-03-09 T 15:09:42) (D) --   eckit version [0.11.0]
    [0] (2016-03-09 T 15:09:42) (D) --   eckit git     
      [ac7f6a0b3cb4f60d9dc01c8d33ed8a44a4c6de27]
    [0] (2016-03-09 T 15:09:42) (D) --   Configuration read from scripts:
    [0] (2016-03-09 T 15:09:42) (D) --   rundir  : 
      /home/na/nagm/myproject/builds/project1
    [0] (2016-03-09 T 15:09:42) (I) -- Hello world!
    [0] (2016-03-09 T 15:09:42) (D) -- Atlas finalized

which gives us some information such as the version of Atlas we are 
running, the identifier of the commit and the path of the executable. 

Fortran version
---------------
\label{s:atlas-hello-world-F}

Program description
```````````````````

The Fortran version of the Atlas initialization and finalization 
calls is depicted in \lista{code1-F}.

\lstinputlisting[caption=Initialization and finalization of 
Atlas using Fortran, style=FStyle, label=code1-F]{hello-world.F90}

We can create a new file in the folder \inlsh{project1} just generated::

    touch $SRC/project1/hello-world.F90

and copy the content of the code in \lista{code1-F} into it.
We can now have a closer look at the code.
On line 1, we define the program, called \inltf{usage\_example}.
On line 3, we include the required Atlas libraries
(note that we include only the three functions required 
for this example - i.e. \inltf{atlas\_init}, \inltf{atlas\_finalize}),
and \inltf{atlas\_log}.
The function \inltf{atlas\_init()} on line 8 is responsible for setting up the
logging and for the initialization of MPI (Message Passage Interface), 
while the function \inltf{atlas\_finalize()} on line 10 is responsible for
finalizing MPI and closing the program.
On line 9, we log `Hello world!` to the \inltf{info} log channel.\\

Atlas provides 4 different log channels which can be configured
separately: \inltc{debug}, \inltc{info}, \inltc{warning}, and
\inltc{error}. By default, the \inltc{debug} channel does not
get printed; the \inltc{info} and \inltc{warning} channel get 
printed to the std::cout stream, and the \inltc{error} channel
gets printed to std::cerr. For more information on the logging
facility, the reader is referred to section~\ref{s:utilities-logging}.


Code compilation
````````````````

We now need to compile the code. We first create a new directory
into the \inlsh{\$BUILDS} folder, where we will compile the code ::

    mkdir -p $BUILDS/project1

As mentioned above, there are (at least) two ways for compiling 
the source code above. These are detailed below.

\begin{description}
%
\item \underline{Directly with Fortran compiler}\\[0.5em]
%
The first possibility is to avoid using cmake and ecbuild and 
directly run a Fortran compiler, such as gfortran.
For doing so, especially when Atlas is linked statically,
we need to know all Atlas dependent libraries. This step can be easily
achieved by inspecting the file. This step can be easily achieved by inspecting 
the file. ::

    cat $INSTALL/atlas/lib/pkgconfig/atlas.pc

Here, all the flags necessary for the correct compilation 
of the Fortran code in \lista{code1-F} are reported. For 
compiling the code, we first go into the builds directory 
just created and we generate a new folder where the executables 
will be stored::

    cd $BUILDS/project1
    mkdir -p bin

Note that, when using the cmake compilation route, it is not 
necessary to generate the bin directory since it will automatically 
created during compilation.
After having generated the bin folder, we can run the following 
command::

    gfortran $SRC/project1/hello-world.F90 -o bin/atlas_f-hello-world \ 
    $(pkg-config $INSTALL/atlas/lib/pkgconfig/atlas.pc --libs --cflags)

This will compile our hello-world.F90 file and it will automatically 
link all the static and dynamic libraries required by the program. 
The executable, as mentioned, is generated into the folder bin.

\item \underline{CMake/ecbuild}\\[0.5em]

The second possibility is to use a cmake file that uses some 
ecbuild macros. In particular, we need to create the following 
cmake file::

    # File: CMakeLists.txt
    cmake_minimum_required(VERSION 2.8.4 FATAL_ERROR)
    project(usage_example)
    
    include(ecbuild_system NO_POLICY_SCOPE)
    ecbuild_requires_macro_version(1.9)
    ecbuild_declare_project()
    ecbuild_enable_fortran(MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/module
                           REQUIRED)
    ecbuild_use_package(PROJECT atlas REQUIRED)
    ecbuild_add_executable(TARGET  atlas_f-usage_example
                           SOURCES hello-world.F90 
                           INCLUDES ${ATLAS_INCLUDE_DIRS}
                                    ${CMAKE_CURRENT_BINARY_DIR}
                           LIBS  atlas_f)
    ecbuild_print_summary()

in the sources folder of our project \inlsh{\$SRC/project1}.
We can create the \inlsh{CMakeLists.txt} file in the correct 
directory following the two steps below::

    cd $SRC/project1
    touch CMakeLists.txt

and copy the cmake code above into it.
In the second line of the cmake file, we declare the minimum cmake 
version required to compile the code, while in the second line 
we declare the name of our cmake project. 
From line 5 to line 7 we include some required ecbuild macros 
necessary for using ecbuild. On line 8 we enable Fortran compilation, 
while on line 10 we specify that the Atlas library is required for 
this project. Finally, on line 11 we add the instruction to 
compile the executable.
Line 15 prints just a compilation summary. We can now run this simple 
cmake file by going into our builds directory  ::

    cd $BUILDS/project1

and by typing the following command::

    $SRC/ecbuild/bin/ecbuild -DATLAS_PATH=$INSTALL/atlas $SRC/project1/
    make 

Note that in the above command we needed to provide the path 
to the Atlas library installation.  Alternatively,
\inlsh{ATLAS\_PATH} may be defined as an environment variable.
This completes the compilation of our first example that uses
Atlas and generates an executable file into the bin folder 
(automatically generated by CMake) inside our builds directory
for project1.
\end{description}
%

Run the code
````````````
After the compilation of the source code is completed, 
we have an executable file into the folder \inlsh{\$BUILDS/project1/bin/}.
If we simply run the executable file as follows::

    ./atlas_c-hello-world

we obtain the output ::

    [0] (2016-03-09 T 15:27:00) (I) -- Hello world!

However, by setting the environment variable `DEBUG=1`,
also debug information is printed.
In particular, if we type::

    export DEBUG=1
    ./atlas_c-hello-world

we should obtain something similar to the following output::

    [0] (2016-03-09 T 15:27:04) (D) -- Atlas program [atlas_f-hello-world]
    [0] (2016-03-09 T 15:27:04) (D) --   atlas version [0.6.0]
    [0] (2016-03-09 T 15:27:04) (D) --   atlas git     
      [dabb76e9b696c57fbe7e595b16f292f45547d628]
    [0] (2016-03-09 T 15:27:04) (D) --   eckit version [0.11.0]
    [0] (2016-03-09 T 15:27:04) (D) --   eckit git    
       [ac7f6a0b3cb4f60d9dc01c8d33ed8a44a4c6de27]
    [0] (2016-03-09 T 15:27:04) (D) --   Configuration read from scripts:
    [0] (2016-03-09 T 15:27:04) (D) --   rundir  :
      /home/na/nagm/myproject/builds/project1
    [0] (2016-03-09 T 15:27:04) (I) -- Hello world!
    [0] (2016-03-09 T 15:27:04) (D) -- Atlas finalized

which gives us some information such as the version of Atlas we are 
running, the identifier of the commit and the path of the executable. 
\begin{tipbox}
The outputs obtained for the Fortran and C++ versions should be identical
since they call exactly the same routines. 
\end{tipbox}

This completes your first project that uses the Atlas library.
