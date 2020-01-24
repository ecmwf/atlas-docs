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

            .. button-warning:: http://download.ecmwf.int/test-data/atlas/docs/latest/getting-started.html
                :class: m-fullwidth

                Dive right in

                | quick guide to
                | get you started

            .. class:: m-text-center m-text m-warning m-noindent

            | Version `2019.10 <{filename}/blog/announcements/2019.10.rst>`_ with
              Python
            | and Basis support now out!

.. role:: raw-html(raw)
    :format: html

.. container:: m-row m-container-inflate

    .. container:: m-col-m-4

        .. figure: : {static}/img/feature-6.png
            :figclass: m-fullwidth m-warning
            :alt: Core features

        .. block-warning:: Beauty of *simplicity*

            Among Magnum essentials is a UTF-8-aware OS, filesystem and console
            abstraction, a versatile vector math library and a slim C++11
            wrapper of Vulkan and OpenGL API families. Build on top of that or
            opt-in for more.

            .. button-warning:: {filename}/features.rst
                :class: m-fullwidth

                See all core features

    .. container:: m-col-m-4

        .. figure: : {static}/img/feature-9.png
            :figclass: m-fullwidth m-info
            :alt: Feature

        .. block-primary:: With batteries *included*

            Shaders and primitives for fast prototyping, algorithms, debugging
            and automatic testing, asset management, integration with popular
            windowing toolkits and a UI library. Everything fits together but
            you still have a choice.

            .. button-primary:: {filename}/features/extras.rst
                :class: m-fullwidth

                List the extra features

    .. container:: m-col-m-4

        .. figure: : {static}/img/feature-7.png
            :figclass: m-fullwidth m-success
            :alt: Feature

        .. block-success:: Screws are *not glued in*

            There's always more than one way to do things. Enjoy the freedom of
            choice and integrate your own asset loader, texture compressor,
            font format or math library, if you feel the need. Or use any of
            the various plugins.

            .. button-success:: {filename}/features/extensions.rst
                :class: m-fullwidth

                View extension points

Here is a doxygen link to :dox:`atlas::Grid` and :dox:`Mesh::footprint()`
Here is the filename {filename}