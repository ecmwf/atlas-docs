Introduction
============

Atlas is an ECMWF software library for parallel flexible 
data-structures supporting structured/unstructured grids, 
structured/unstructured meshes, various function spaces 
and utilities.  
The main aim of Atlas is to investigate and develop more 
scalable dynamical core options for numerical weather prediction 
(NWP). Atlas is also intended to create modern interpolation 
and product generation software.

Atlas is predominantly written in C++, with the main features 
available to Fortran through an F2003 interface. To be used 
effectively, it requires some knowledge of Unix (such as Linux). 
It is known to run on a number of systems, some of which are 
directly supported by ECMWF.

Atlas includes the following macro data objects.
  - Grid: a list of coordinates (i.e. points) without connectivity rules;
  - Mesh: a collection of elements linked by precise connectivity rules;
  - Field: a physical quantity such as wind velocity or pressure;
  - FieldSet: a collection of Fields;
  - FunctionSpace: a given spatial discretization space (e.g. spectral, finite element, etc.).

.. _my-reference-label:

From these objects it is possible to construct new algorithms 
to be tested within the context of numerical weather prediction 
(NWP), to generate and manipulate grids for production 
cases, etc. The overall structure of the library is depicted 
here:

.. figure:: {static}/img/schematics.png
    :alt: Image alt text
    :target: {static}/img/schematics.pdf

    Schematics of the Atlas library

From this figure, we note that there is the additional object 
called Metadata and related to the Field object. Metadata 
contains a description of a given Field (e.g. units, etc.).
We also note that the Mesh object is formed by the Nodes 
and HybridElements objects, with the last being composed 
by Elements. These additional items represents the bricks 
to ultimately build the mesh object.
 
The structure in this figure will be 
further explained in chapter \ref{chap:structure}.
