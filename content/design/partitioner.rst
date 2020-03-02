Partitioner
===========

Even though the \class{Grid} object itself is not distributed in memory as it does not have a large memory footprint, it is necessary for parallel algorithms to divide work over parallel MPI tasks.

There exist various strategies in how to partition a grid, where each strategy may
offer different advantages, depending on the grid and numerical algorithms to be used.

Atlas implements a grid \class{Partitioner} class, that given a grid, partitions the grid and creates a \class{Distribution} object that describes for each grid point which partition it belongs to.
\refFigure{grid-Partitioner} illustrates the UML class diagram for the \class{Partitioner} class. Following a similar design philosophy as before, the \class{Partitioner} class wraps an abstract polymorphic \class{PartitionerImplementation} object. \refFigure{grid-Distribution} illustrates the UML class diagram for the \class{Distribution} class.

.. TODO
    \begin{figure}[htb!]
    \centering
    \includegraphics[scale=0.5]{figures/grid/Partitioner.pdf}
    \caption{UML class diagram for the \class{Partitioner} class }
    \label{figure:grid-Partitioner}
    \end{figure}

.. TODO
    \begin{figure}[htb!]
    \centering
    \includegraphics[scale=0.5]{figures/grid/Distribution.pdf}
    \caption{UML class diagram for the \class{Distribution} class }
    \label{figure:grid-Distribution}
    \end{figure}

Currently there are 3 concrete implementations of the \class{PartitionerImplementation}:

- :dox:`Checkerboard` ( type: ``checkerboard`` ) -- Partitions a grid in regular zones
- :dox:`EqualRegions` ( type: ``equal_regions`` ) -- Partitions a grid in equal regions, reminiscent of a disco ball.
- :dox:`MatchingMesh` ( type: ``matching_mesh`` ) -- Partitions a grid such that grid points following the domain decomposition of an existing mesh which may be based on a different grid.
- :dox:`MatchingFunctionSpace` ( type: ``matching_functionspace`` ) -- Partitions a grid such that grid points following the domain decomposition of an existing functionspace which may be based on a different grid.

The \class{Checkerboard} and \class{EqualRegions} implementations can be created from a configuration object only. The \class{MatchingMesh} implementation requires a further mesh argument to its constructor. For this reason, a \class{MatchingMeshPartitioner} class exists whose only purpose is that it knows how to construct its related \class{MatchingMesh} implementation with the extra mesh argument.

Checkerboard Partitioner
------------------------

For regular grids, such as the one depicted
in \refFigure{regular-grid}, a logical domain decomposition would be a checkerboard. The grid is then divided as well as possible into approximate rectangular zones in Cartesian grid coordinates (``x``,``y``) with an equal number of grid points.
An example of this partitioning algorithm is shown in \refFigure{grid-Checkerboard-example}.

.. TODO
   \begin{figure}[htb!]
   \centering
   %                               left bottom right top
   \includegraphics[scale=0.8, trim=30pt 80pt 30pt 80pt, clip ]{figures/grid/checkerboard-S64x32-32parts.png}
   \caption{Example \class{Checkerboard} partitioning of a shifted regular longitude-latitude grid (\idx{S64x32}) in 32 partitions.}
   \label{figure:grid-Checkerboard-example}
   \end{figure}


EqualRegions Partitioner
------------------------

For reduced grids as the ones shown in \refFigure{structured-grid} and
\refFigure{structured-O16-grid} or for uniformly distributed unstructured grids, an ``equal regions`` domain decomposition is more advantageous
\cite{deconinck2016accelerating,leopardi2006partition,Mozdzynski2007}.
The ``equal regions`` partitioning algorithm divides a two-dimensional grid of the sphere
(i.e. representing a planet) into bands from the North pole to the South pole.
These bands are oriented in zonal directions and each band is then split further into
regions containing equal number of grid points. The only exceptions are the bands containing
the North or South Pole, that are not subdivided into regions but constitute North and
South polar caps.

An example of this partitioning algorithm is shown in \refFigure{grid-EqualRegions-example}

.. TODO
    \begin{figure}[htb!]
    \centering
    %                               left bottom right top
    \includegraphics[scale=0.8, trim=30pt 80pt 30pt 80pt, clip ]{figures/grid/equal-regions-32parts-N16.png}
    \caption{Example \class{EqualRegions} partitioning of a \idx{N16} classic reduced Gaussian grid in 32 partitions.}
    \label{figure:grid-EqualRegions-example}
    \end{figure}



MatchingMesh Partitioner
------------------------

The \class{MatchingMeshPartitioner} allows to create a \class{Distribution} for a grid such that the grid points follows the domain decomposition of an existing mesh (described in detail in \refSection{mesh}).
This partitioning strategy is particularly useful when grid points of a partition should be contained within a mesh partition present on the same MPI task to avoid parallel communication during coupling or interpolation algorithms. Note that there is no guarantee of any load-balance here for the partitioned grid. \refFigure{grid-MatchingMeshPartitioner-example} shows an example application of the \class{MatchingMeshPartitioner}.

.. TODO
    \begin{figure}[htb!]
    \centering
    %                               left bottom right top
    \includegraphics[scale=0.8, trim=30pt 80pt 30pt 80pt, clip ]{figures/grid/matching-mesh-partitioner_N24-F8.png}
    \caption{Example partitioning in 32 parts of a F8 rectangular Gaussian grid (solid dots) using the domain decomposition of an existing meshed N24 classic reduced Gaussian grid. Each domain is shaded and surrounded by a solid line. The jagged lines of the existing N24 mesh subdomains are contours of its elements. }
    \label{figure:grid-MatchingMeshPartitioner-example}
    \end{figure}

