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

    $ atlas-interpolation --s.grid <sgrid> --t.grid <tgrid> --interpolation <interpolation> \
        [--output-matrix|--read-matrix|--test-matrix] [--format scrip|eckit] [--output-gmsh]

and optionally, apply the interpolation to a test field on the source mesh and write the interpolated field on the target mesh.
For larger meshes, the interpolation weights can be written-out to a file and read-in later to save time when the same interpolation is applied repeatedly.
Both writting-out and reading-in can be done in parallel by pre-appending e.g. ``OMP_NUM_THREADS=1 mpirun -np 4`` to the command above.

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


Comparison of interpolation methods available on arbitrary meshes
=================================================================

Most useful interpolation methods are available on every kind of mesh. Atlas has a few of these methods readily available.
Whilst the conservative remapping method still require that mesh cells form a convex polygon, this is a minimal requirement met for almost every imaginable mesh these days.

Experimental order of converge of interpolation methods
-------------------------------------------------------

The figures below show the convergence of interpolation errors for different interpolation methods available in Atlas. Apart from the ``grid-box-average`` method,
which requires a semi-structured grid of Atlas type ``StructuredGrid``, the other methods are available on any kind of unstructured grids.

The figures below show the experimental order of convergence of different interpolators. The Atlas implementations confirms the formal order of convergence
from these interpolation methods.

.. container:: m-row

    .. container:: m-col-l-6

        .. figure:: {static}/tools/img/atlas_interpolators_convergence.png
            :target: {static}/tools/img/atlas_interpolators_convergence.png
            :height: 400 px

    .. container:: m-col-l-6

        .. figure:: {static}/tools/img/atlas_interpolators_eoc.png
            :target: {static}/tools/img/atlas_interpolators_eoc.png
            :height: 400 px



Timings of interpolation methods with and without caching
---------------------------------------------------------

The following table summarises the timing of different interpolation methods when the caching is used versus the recomputing of the interpolation weights.

.. figure:: {static}/tools/img/atlas_interpolators_timing.png
    :target: {static}/tools/img/atlas_interpolators_timing.png
    :height: 400 px

Diffusion of interpolators in a model coupler
---------------------------------------------

In a consequtive remapping (normally seen in model coupler) different interpolators can be used to retain extrema of fields.
In one such scenario, we remap consequtively from a source grid (here, O16) to a target grid (here, O32) and back, then repeated 200 times.
Ideally, a given initial data on the source grid would remain identical after 200 interpolations to the target grid 
and finally back onto the source.

The initial data is "the sinusoid" from Valcke et al (2022), modified to show only the one positive sinusoid as seen here for the initial data on O16.
For visualisation ease only, we scaled the hill height by 100x.

The top left is the initial data on the source grid. All other show the remapped field after 200 back-and-forth remappings.
The top right shows the result for ``grid-box-method`` which is the only non-parallel interpolator here.

The nearest neighbour and the conservative second order spherical polygon interpolators are the least diffusive methods.
The other methods, in particular, the more accurate, finite-elements and bilinear interpolators are noticeably more diffusive.
In the F16↔H32 grid setup, the 4-nearest-neighbour was much less diffusive than depicted here for the O16↔O32 setup, however,
the 4-nearest-neighbour was again more diffusive than the nearest-neighbour.

.. container:: m-row

    .. container:: m-col-l-6

        .. figure:: {static}/tools/img/diffusion_init.png
            :target: {static}/tools/img/diffusion_init.png
            :height: 150 px

        .. figure:: {static}/tools/img/diffusion_1of3.png
            :target: {static}/tools/img/diffusion_1of3.png
            :height: 450 px

    .. container:: m-col-l-6

        .. figure:: {static}/tools/img/diffusion_3of3.png
            :target: {static}/tools/img/diffusion_3of3.png
            :height: 150 px



        .. figure:: {static}/tools/img/diffusion_2of3.png
            :target: {static}/tools/img/diffusion_2of3.png
            :height: 450 px