Mesh
####

.. note-danger:: Under construction!!!

For a wide variety of numerical algorithms, a \class{Grid} (i.e. a mere ordering of points and
their location) is not sufficient and a \class{Mesh} might be required. This is usually obtained
by connecting grid points using polygonal elements (also referred to as cells),
such as triangles or quadrilaterals. A mesh, denoted by $\mathcal{M}$, can then be
defined as a collection of such elements $\Omega_i$:
%
\begin{equation}
\displaystyle \mathcal{M} \coloneqq  \cup_{\idx{i}=1}^{N}\ \Omega_\idx{i}\;.
\end{equation}
%
\indent For regular grids, the mesh elements can be inferred, as a
blocked arrangement of quadrilaterals. For unstructured grids or reduced grids (\refSection{grid}),
these elements can
no longer be inferred, and explicit connectivity rules are required.
The \class{Mesh} class combines the knowledge of classes \class{Nodes},
\class{Cells}, \class{Edges}, and provides a means to access connectivities
or adjacency relations between these classes).
%
\begin{figure}[htb!]
\centering
\includegraphics[width=0.7\textwidth]{figures/mesh-composition.pdf}
\caption{Mesh composition}
\label{figure:mesh-composition}
\end{figure}
%
\class{Nodes} describes the nodes of the mesh, \class{Cells} describes the elements
such as triangles and quadrilaterals, and \class{Edges} describes the lines connecting
the nodes of the mesh. \refFigure{mesh-composition} sketches the composition of the
\class{Mesh} class with common access methods for its components. Differently from the
\class{Grid}, the \class{Mesh} may be distributed in memory. The physical domain $S$ is
decomposed in sub-domains $S_p$ and a corresponding mesh partition $\mathcal{M}_\idx{p}$
is defined as:
%
\begin{equation}
\mathcal{M}_{\idx{p}} \coloneqq \{ \cup\ \Omega\ , \hspace{10pt} \forall \hspace{5pt} \Omega\  \in\
\mathcal{S}_\idx{p} \}.
\end{equation}
%
More details regarding this aspect are given in \refSection{parallelisation}.

A \class{Mesh} may simply be read from file by a \class{MeshReader},
or generated from \class{Grid} by a \class{MeshGenerator}. The latter option is illustrated
in \refFigure{conceptual_technical}, where the grid points will become the nodes
of the mesh elements. Listing~\ref{code:mesh} shows how this can be achieved in practice,
and \refFigure{mesh-O16} visualises the resulting mesh for grids \idx{N16} and \idx{O16}.


\begin{minipage}{\textwidth} \vspace{1em}
\begin{lstlisting}[caption=\Cpp Mesh generation from a \class{StructuredGrid}, label=code:mesh,
style=CStyleNoLine]
Grid           grid( "O16" );
MeshGenerator  generator( "structured" );
Mesh           mesh = generator.generate( grid );
\end{lstlisting}
\end{minipage}

\begin{notebox}
For \class{UnstructuredGrid}s, another \class{Meshgenerator} needs to be used based on e.g. Delaunay triangulation (type=``delaunay``). Whereas the \class{StructuredMeshGenerator} is able to 
generate a parallel distributed mesh in one step, the \class{DelaunayMeshGenerator} currently only supports generating a non-distributed mesh using one MPI task. In the future it is envisioned that this implementation will be parallel enabled as well.
\end{notebox}

\begin{figure}[htb!]
\centering

\begin{minipage}[b]{0.38\linewidth}
\centering
\includegraphics[width=\linewidth]{figures/structured-N16-mesh.\ext}\\[10pt]
\subcaption{classic Gaussian, \idx{N16}}
\end{minipage}%
\hspace{0.05\linewidth}
\begin{minipage}[b]{0.38\linewidth}
\centering
\includegraphics[width=\linewidth]{figures/structured-O16-mesh.\ext}\\[10pt]
\subcaption{octahedral Gaussian, \idx{O16} \label{figure:mesh-O16}}
\end{minipage}
\caption{\class{Mesh} generated for two types of reduced grids
(\refFigure{grid-examples})}
\label{figure:mesh-examples}
\end{figure}
%

Because several element types can coexist as cells, the class \class{Cells}
is composing a more complex interplay of classes, such as \class{Elements},
\class{ElementType}, \class{BlockConnectivity}, and \class{MultiBlockConnectivity}.
This composition is detailed in \refFigure{mesh-cells}.
%
\begin{figure}[htb!]
\centering
\includegraphics[width=0.55\textwidth]{figures/mesh-cells.pdf}
\caption{Mesh \class{Cells} diagram.}
\label{figure:mesh-cells}
\end{figure}
%
Atlas provide various type of connectivity tables: BlockConnectivity, IrregularConnectivity and MultiBlockConnectivity. BlockConnectivity is used when all elements of the mesh are of the same type, while IrregularConnectivity is more flexible and used when the elements in the mesh can be of any type. The BlockConnectivity implementation has a regular structure of the lookup tables and therefore provides better computational performance compared to the IrregularConnectivity. 
Finally the MultiBlockConnectivity supports those cases where the mesh contains various types of elements but they can still be grouped into collections of elements of the same type so that numerical algorithms can still benefit from performing operations using elements
of one element type at a time.
The \class{Elements} class provides the view of elements of one type with node and edge connectivities as a \class{BlockConnectivity}. The interpretation
of the elements of this one type is delegated to the \class{ElementType} class.
The \class{Cells} class is composed of multiple \class{Element}s and provides a unified view of all elements regardless of their shape.
The \class{MultiBlockConnectivity} provides a matching unified connectivity table. Each block in the MultiBlockConnectivity shares its memory with the BlockConnectivity present in the \class{Element}s to avoid memory duplication (see \refFigure{mesh-connectivity}).

\begin{figure}[htb!]
\centering
\includegraphics[width=0.43\textwidth]{figures/mesh-connectivity.pdf}
\caption{\class{BlockConnectivity} points to blocks of \class{MultiBlockConnectivity}.
Zig-zag lines denote how the data is laid out contiguously in memory.}
\label{figure:mesh-connectivity}
\end{figure}

Although currently the mesh is composed of two-dimensional elements such as quadrilaterals and triangles,
three-dimensional mesh elements such as
hexahedra, tetrahedra, etc.\ are envisioned in the design and can be naturally embedded
within the presented data structure.
However, at least for the foreseeable future in NWP and climate applications,
the vertical discretisation may be considered orthogonal to the horizontal discretisation
due to the large anisotropy of physical scales in horizontal and vertical directions.
Given a number of vertical levels, 
polygonal elements in the horizontal are then extruded to prismatic
elements oriented in the vertical direction (e.g.\ \cite{macdonald2011modelingirregulargrids}).
