Interpolation
#############

:breadcrumb: {filename}/design.rst Design

.. role:: cpp(code)
    :language: cpp

.. role:: verbatim(code)
    :language: verbatim

.. contents::
  :class: m-block m-default

Interpolation in Atlas is interpreted as a linear operation,
with the weights calculated geometrically such that they do not depend
on the values being interpolated. This can be represented as a matrix multiplication,
:math:`y = A x`, for (x, y) the (input, output) values vectors, and A,
the interpolation weights matrix, stored in compressed sparse rows (CSR) format.

There are several options for generating the weights,
these are set by the type of the interpolation.

Interpolation methods
=====================

Finite Element
--------------

Enabled when type is `finite-element`. The weights are set according to the barycentric
coordinates of the mesh element surrounding the output location.

K Nearest Neighbours
--------------------

Enabled when type is `k-nearest-neighbours` or `nearest-neighbour` (assumes `k==1`).
The weights are set such that only the nearest k points to the output location are nonzero.

Structured methods
------------------

The weights are calculated by a combination of 1-dimensional interpolations,
which relies on the structure of the grid, see `StructuredGrid <{filename}/design/grid.rst#structuredgrid>`_

Valid types are: `structured-linear2D`, `structured-cubic2D`, `structured-quasicubic2D`

- `structured-linear2D`: This method is commonly known as "bilinear". The stencil is

  .. code:: verbatim

    j0 :    i0----+--i1
                  |
                  *P
                  |
    j1 :      i0--+----i1


  Two 1D linear interpolations in West-East directions are
  followed by a 1D linear interpolation in North-South direction,
  resulting in 4 weights

- `structured-cubic2D`: The stencil is

  .. code:: verbatim

    j0 :    i0----i1--+-i2----i3
                      |
    j1 :      i0---i1-+-i2---i3
                      *P
    j2 :    i0----i1--+-i2----i3
                      |
    j3 :       i0---i1+--i2---i3     

  Fully cubic interpolation for point P would use the full 16 points stencil
  and hence have 16 weights.

  .. math::

    target(P) = \sum_{n=1}^{16} ( w(n)*source(n) )
 
  Though the interpolation itself is "cubic", the operator is linear as you can see.
  The weights are computed by doing 4 1D cubic interpolations (West-East), one for each j, 
  followed by a 1D cubic interpolation perpendicular (North-South).

- `structured-quasicubic2D`: 
  For quasi-cubic interpolation we don’t use all the points from the cubic stencil:

  .. code:: verbatim

    j0 :          i1--+-i2
                      |
    j1 :      i0---i1-+-i2---i3
                      *P
    j2 :    i0----i1--+-i2----i3
                      |
    j3 :            i1+--i2

  So we are having 2 1D linear interpolations at j0 and j3, and 2 cubic interpolations
  at j1 and j2, followed by a 1-D cubic interpolation in North-South direction.
  So instead of 16 weights we now have only 12 weights, making the method slightly cheaper.
  For a 3D interpolation quasi-cubic makes more difference compared to fully cubic, 
  going from 64 weights to 32. Then there are 4 horizontal levels, 
  and the bottom and top level would be only linear, using j1 and j2 only.
 
 

Non-linear interpolation 
========================

Additionally there is capacity for performing a non-linear operation during the interpolation, for example to correct the weights to account for missing data in the input values.
There are two parts to this. 

First, the interpolator must be configured to perform a nonlinear treatment by setting 'non_linear' to one of three values available at the moment:

- `missing-if-any-missing`: if an (output) point has contributions from (input) points where at least one is missing, the output is set to missing value;
- `missing-if-all-missing`: if an (output) point has contributions from (input) points where all points are missing values, the output is set to missing value (the missing input point weights are set to 0, the others are linearly rebalanced such that the sum of the weights is 1);
- `missing-if-heaviest-missing`: if an (output) point has contributions from (input) points where some are missing, the output is set to missing value only if the most significant weight also corresponds to a missing value (the weight rebalancing is the same as above).

A sensible choice for 'non_linear' is 'missing-if-heaviest-missing',
because it works well across large resolution changes in interpolations.
The other options are also suitable depending on your situation,
the choice would depend on your case.

The second requirement is to setup the missing values on the input field you wish
to interpolate. This means you must set the `missing_value_type`, `missing_value` and possibly `missing_value_epsilon` in the field metadata.
The `missing_value_type` value should be one of `equals`, `NaN` or `approximately-equals`.
With the `approximately-equals` value, the `missing_value_epsilon` field metadata must be set to define a tolerance, which is useful when handling lossy-compressed data. 

