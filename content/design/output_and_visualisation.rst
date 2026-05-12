Output and visualisation
########################

:breadcrumb: {filename}/design.rst Design

.. role:: cpp(code)
    :language: cpp

.. role:: verbatim(code)
    :language: verbatim

.. contents::
  :class: m-block m-default

Atlas provides a way to visualise parallel meshes and fields from its output. The Atlas output is supported in ``Gmsh`` and ``SCRIP/netcdf`` format.

Gmsh visualisation
==================

Installing Gmsh
---------------

Please `download and install the 4.6 version of Gmsh <https://gmsh.info/bin/>`_ to visualize Atlas output.

.. note-warning::

    Atlas is tested with Gmsh **4.6**. Please make sure to install this version of Gmsh to visualize Atlas output.


Example of visualising meshes and fields with Gmsh
--------------------------------------------------

Atlas can output meshes and fields in the `Gmsh <https://gmsh.info>`_ `format <https://gmsh.info/doc/texinfo/gmsh.html#MSH-file-format-version-2-_0028Legacy_0029>`_.
This is a great format to visualise low resolution meshes and fields with the interactive Gmsh viewer.
However, it becomes sluggish to unresponsive for high resolution meshes and fields.

Using ``atlas-meshgen`` and ``atlas-interpolation`` tools, one can generate meshes and interpolation weights in Gmsh format, and visualise them with the interactive Gmsh viewer.
Here is an example of visualising a mesh with the Gmsh viewer:

.. code-block:: bash

    ./bin/atlas-meshgen --3d --include-pole O4
    gmsh mesh.msh

It is also possible to visualise fields with the Gmsh viewer. Here is an example of outputting and visualising an interpolated field with the Gmsh viewer:

.. code-block:: bash

    ./bin/atlas-interpolation --s.grid O4 --t.grid O4 --interpolation nearest --output-gmsh
    gmsh tgt_mesh.msh tgt_field.msh
