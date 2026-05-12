atlas-interpolation
###################

:breadcrumb: {filename}/tools.rst Tools

The command-line tool ``atlas-interpolation`` provides information on interpolations supported by Atlas.

.. contents::
  :class: m-block m-default

Specific usage
==================

List all available interpolations

.. code :: bash

    $ atlas-interpolation --list

Generate interpolation weights for a pair of source and target meshes:

.. code :: bash

    $ OMP_NUM_THREADS=1 mpirun -np 4 atlas-interpolation --s.grid <sgrid> --t.grid <tgrid> --interpolation <interpolation> \
        [--output-matrix|--read-matrix|--test-matrix] [--format scrip|eckit] [--output-gmsh]

and optionally, apply the interpolation to a test field on the source mesh and write the interpolated field on the target mesh.

If ``--output-matrix`` (or ``--read-matrix``) is given, the interpolation weights get written-out (or read-in) to/from the file 
```
remap_<sgrid>_<tgrid>_<interpolation>.nc
```
in the SCRIP format (only if ``--format scrip`` is given) or 
```
remap_<sgrid>_<tgrid>_<interpolation>.eckit
```
in the eckit-binary format.

If ``--output-gmsh`` is given, a test source field gets remapped and written-out to the file ``tgt_field.msh`` in the Gmsh format, 
and the target mesh gets written-out to the file ``tgt_mesh.msh`` in the Gmsh format along with the source mesh in the file ``src_mesh.msh`` in the Gmsh format.

A few other useful options are available. Please use the help message to learn about them:

.. code :: bash

    $ atlas-interpolation --help

It is worth noting that some other interpolation methods available in Atlas can be
better suited (see `ECMWF documentation <https://confluence.ecmwf.int/x/ITsbHg>`_).

Comparison of interpolation methods available on arbitrary meshes
=================================================================

Most useful interpolation methods are available on every kind of mesh. Atlas has a few of these methods readily available.
Whilst the conservative remapping method still require that mesh cells form a convex polygon, this is a minimal requirement met for almost every imaginable mesh these days.

The figure below shows the convergence of interpolation errors for different interpolation methods available in Atlas. Apart from the ``grid-box-average`` method,
which requires a semi-structured grid of Atlas type ``StructuredGrid``, the other methods are available on any kind of unstructured grids.

.. figure:: {static}/tools/img/atlas_interpolators_convergence.png
    :target: {static}/tools/img/atlas_interpolators_convergence.png
    :height: 400 px

The figure below shows the experimental order of convergence of different interpolators. The Atlas implementations confirms the formal order of convergence 
from these interpolation methods.

.. figure:: {static}/tools/img/atlas_interpolators_eoc.png
    :target: {static}/tools/img/atlas_interpolators_eoc.png
    :height: 400 px
