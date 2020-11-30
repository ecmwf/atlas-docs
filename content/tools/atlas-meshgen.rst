atlas-meshgen
#############

:breadcrumb: {filename}/tools.rst Tools

The command-line tool ``atlas-meshgen`` generates a mesh in the `Gmsh 
<https://gmsh.info>`_ `format <https://gmsh.info/doc/texinfo/gmsh.html#MSH-file-format-version-2-_0028Legacy_0029>`_ given a grid and options.

.. note-warning::

    Gmsh is great to visualize low resolution meshes but becomes sluggish to unresponsive for high resolution meshes.
    This tool is however invaluable for development and for understanding of how low resolution grids and meshes are constructed.

.. contents::
  :class: m-block m-default

Usage
-----

.. code :: shell

    $ atlas-meshgen GRID [OUTPUT] [OPTION]... [--help]

The `GRID` argument can be either the name of a named grid, orthe path to a YAML configuration file that describes the grid.
Example values for grid names are: N80, F40, O24, L64x33. See the program 'atlas-grids' for a list of named grids.
`Example grid YAML files <https://github.com/ecmwf/atlas/tree/develop/doc/example-grids>`_ can be found in the Atlas sources
(the `check` section in these files can be omitted).

The optional `OUTPUT` argument contains the path to the output file. If not given, a default value `mesh.msh` is employed.
For a list of supported grids, use




Options
-------

Coordinate visualization
````````````````````````
The ``atlas-meshgen`` tool has 3 coordinate visualization options.

Projected (`x, y`) coordinates (2D)
"""""""""""""""""""""""""""""""""""
By default the nodes written in the projected `x, y` coordinates in a horizontal plane.
For example if the grid is defined with a Lambert Conic Conformal projection, then the `x, y` coordinates are the
values in `metres`, and the grid will look nicely Cartesian.

Geospherical (`lon, lat`) coordinates (2D)
""""""""""""""""""""""""""""""""""""""""""
The ``--lonlat`` option makes the ``atlas-meshgen`` tool output the mesh with nodes in geospherical `lon, lat` coordinates.

Earth Centred Earth Fixed (`x, y, z`) coordinates (3D)
""""""""""""""""""""""""""""""""""""""""""""""""""""""
The ``--3d`` option makes the ``atlas-meshgen`` tool output the mesh with nodes in Earth Centred Earth Fixed `x, y, z` coordinates.
This makes the mesh visualized on the sphere.


Pole visualization (in 3D)
``````````````````````````
Some grids defined in a geospherical coordinate system don't have points at the pole. This is the case for Gaussian grids and Shifted grids.
Most mesh generators will then not create elements that include or cover the Pole.
Visualization of these grids in 3D would result in seeming holes at the North Pole and South Pole, as shown below:

.. figure:: {static}/tools/img/mesh3d_hole.png
    :target: {static}/tools/img/mesh3d_hole.png
    :width: 500 px

The ``atlas-meshgen`` tool has two options that can be used to "fill" the holes.

Patching the poles
""""""""""""""""""
The ``--patch-pole`` option will make the mesh generator connect the points closest to the Pole with triangles that cover the pole as shown below:

.. figure:: {static}/tools/img/mesh3d_patch.png
    :target: {static}/tools/img/mesh3d_patch.png
    :width: 500 px

Including 1 point at the poles
""""""""""""""""""""""""""""""
The ``--include-pole`` option will make the mesh generator add one extra point at the Pole if needed and create triangle elements with the Pole point as vertex as shown below:

.. figure:: {static}/tools/img/mesh3d_point.png
    :target: {static}/tools/img/mesh3d_point.png
    :width: 500 px
