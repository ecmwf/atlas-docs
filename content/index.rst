Atlas
#####

:save_as: index.html
:url:
:cover: {static}/img/cover.jpg
:description: Data structure library for NWP and Climate Modelling
:summary: Data structure library for NWP and Climate Modelling
:hide_navbar_brand: True
:landing:
    .. container:: m-row

        .. container:: m-col-l-6 m-push-l-1 m-col-m-7 m-nopadb

            .. raw:: html

                <h1><span class="m-thin">Atlas</span></h1>

    .. container:: m-row

        .. container:: m-col-l-6 m-push-l-1 m-col-m-7 m-nopadt

            *A library for Numerical Weather Prediction and Climate Modelling*

            Atlas is an open source library providing grids, mesh generation, and parallel
            data structures targetting Numerical Weather Prediction or Climate Model 
            developments.

        .. container:: m-col-l-3 m-push-l-2 m-col-m-4 m-push-m-1 m-col-s-6 m-push-s-3 m-col-t-8 m-push-t-2

            .. button-warning:: {filename}/getting_started/quick_start.rst
                :class: m-fullwidth

                Dive right in

                | quick guide to
                | get you started

            .. class:: m-text-center m-text m-warning m-noindent

            | Version |atlas-release-version| released

Overview
========

Atlas is an ECMWF library for parallel data structures supporting unstructured
grids and function spaces, with the aim to investigate alternative, more scalable
dynamical core options for Earth system models, and to support modern interpolation
and product generation software.

Atlas is predominantly C++ code, with main features available to Fortran codes
through a F2003 interface. It requires some flavour of Unix (such as Linux).
It is known to run on a number of systems, some of which are directly supported
by ECMWF.

What's New?
===========

Curious about what was added or improved recently?
Check out the `Changelog <https://github.com/ecmwf/atlas/blob/master/CHANGELOG.md>`_.

Contributing
============

Contributions to Atlas are welcome. Open an issue to discuss a feature request
or bug, then submit a pull request against the ``develop`` branch.

Citing Atlas
============

If Atlas was useful in your research, please cite:

.. code-block:: bibtex

    @article{DECONINCK2017188,
    title = "Atlas : A library for numerical weather prediction and climate modelling",
    journal = "Computer Physics Communications",
    volume = "220",
    pages = "188 - 204",
    year = "2017",
    issn = "0010-4655",
    doi = "https://doi.org/10.1016/j.cpc.2017.07.006",
    url = "http://www.sciencedirect.com/science/article/pii/S0010465517302138",
    author = "Willem Deconinck and Peter Bauer and Michail Diamantakis and Mats Hamrud and Christian Kuhnlein and Pedro Maciel and Gianmarco Mengaldo and Tiago Quintino and Baudouin Raoult and Piotr K. Smolarkiewicz and Nils P. Wedi",
    keywords = "Numerical weather prediction, Climate, Earth system, High performance computing, Meteorology, Flexible mesh data structure"
    }

.. include:: generated/atlas_release_version.rst

