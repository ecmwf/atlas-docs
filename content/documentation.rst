Documentation
#############


Interpolation
=============

Interpolation in atlas is interpreted as a linear operation, with the weights calculated geometrically such that they do not depend on the values being interpolated. This can be represented as a matrix multiplication, :math:`y = A x`, for (x, y) the (input, output) values vectors, and A, the interpolation weights matrix. There are several options for generating the weights, these are set by the type of the interpolation.

Finite Element
--------------

Enabled when type is `finite-element`. The weights are set according to the barycentric coordinates of the mesh element surrounding the output location.

Nearest Neighbour
-----------------

Enabled when type is `k-nearest-neighbours`. The weights are set such that only the nearest k points to the output location are nonzero.

Structured linear 2D
--------------------

Enabled when type is `structured-linear2D`. The weights are calculated corresponding to a bilinear interpolation. This is only valid on a structured grid.


Non-linear interpolation 
------------------------

Additionally there is capacity for performing a non-linear operation during the interpolation, for example to correct the weights to account for missing data in the input values. There are two parts to this. First the interpolator must be configured to perform a nonlinear treatment by setting 'non_linear' to one of three values available at the moment:

    'missing-if-any-missing': if an (output) point has contributions from (input) points where at least one is missing, the output is set to missing value;
    'missing-if-all-missing': if an (output) point has contributions from (input) points where all points are missing values, the output is set to missing value (the missing input point weights are set to 0, the others are linearly rebalanced such that the sum of the weights is 1);
    'missing-if-heaviest-missing': if an (output) point has contributions from (input) points where some are missing, the output is set to missing value only if the most significant weight also corresponds to a missing value (the weight rebalancing is the same as above).

A sensible choice for 'non_linear' is 'missing-if-heaviest-missing', because it works well across large resolution changes in interpolations. The other options are also suitable depending on your situation, the choice would depend on your case.

The second requirement is to setup the missing values on the input field you wish to interpolate. This means you must set the `missing_value`, `missing_value_type` and any `missing_value_epsilon` in the field metadata. `missing_value_type` should be one of `equals`, `NaN` or `approximately-equals` this last option allows you to use the `missing_value_epsilon` to define a tolerance (for lossy-compressed data) 

