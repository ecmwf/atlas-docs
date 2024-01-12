
Plugin architecture
###################

:breadcrumb: {filename}/design.rst Design

.. role:: cpp(code)
    :language: cpp

.. role:: info
    :class: m-text m-info

.. role:: yellow
    :class: m-text m-warning

Atlas' concepts can be easily extended with custom implementations. Think e.g. custom Grids, Partitioners, MeshGenerators, FunctionSpaces, and many other abstract Atlas concepts. Rather than adding implementations in the Atlas library itself, the
implementations may reside in Atlas "plugins".

.. contents::
  :class: m-block m-default

What?
-----

An Atlas plugin is essentially a shared library constructed and installed in a specific manner that gets dynamically
loaded at runtime of executables that make use of Atlas.

When the plugin library is loaded, it registers "ObjectBuilders" of concrete "Objects" implemented in the plugin in the Atlas "ObjectFactory", as explained in `Object oriented design <{filename}/design/object_oriented.rst>`_.

.. block-warning:: Example: `atlas-orca`

    One example plugin is the `atlas-orca` plugin. This plugin provides a custom ``OrcaGrid`` class which accesses from file the coordinates of known ORCA tri-polar grids. A custom ``OrcaMeshGenerator`` can quickly and in parallel generate a mesh from this OrcaGrid.

    Upon loading of the `atlas-orca` plugin, the ``OrcaGrid`` is automatically registered in the ``GridFactory`` and the ``OrcaMeshGenerator`` in the ``MeshGeneratorFactory``. This now allows for general Atlas tools like `atlas-grids <{filename}/tools/atlas-grids.rst>`_ and `atlas-meshgen <{filename}/tools/atlas-meshgen.rst>`_ to list ORCA grid information, and generate a mesh.

Using a plugin
--------------

When Atlas is initialized at runtime, the environment variable ``ATLAS_PLUGINS`` is evaluated as a comma-separated
lists of plugin names. The shared library corresponding to each plugin name will then be dynamically loaded.

Each plugin shared library will be found without further hints if it is installed in the same install prefix as Atlas itself. Otherwise further comma-separated hints can be supplied with the environment variable ``ATLAS_PLUGIN_SEARCH_PATHS``


.. note-info ::

    The plugin library may also be linked to your application during its compilation process, providing all the features of the plugin directly. This can however not be done with some existing applications or the atlas provided `Tools <{filename}/tools.rst>`_. The plugin mechanism via the ``ATLAS_PLUGINS`` environment variable is then the only way to extend the tool's functionality.


Creating a plugin
-----------------

Assume the plugin we want to create has name "my-plugin-name".
The plugin's `CMakeLists.txt` should then contain following:

.. code:: cmake

    find_package(atlas REQUIRED)

    atlas_create_plugin( my-plugin-name )

The CMake macro ``atlas_create_plugin`` is exported from Atlas upon ``find_package( atlas ... )``, and guarantees that the plugin
will be recognized by Atlas.

Within the plugin source code, it is mandatory to create a class which inherits from :dox:`Plugin`

.. code:: cpp

    // file: MyPlugin.h

    #include "atlas/library/Plugin.h"

    namespace my_plugin {

    class MyPlugin : public atlas::Plugin {
    private:
        MyPlugin();
    public:
        static const MyPlugin& instance();
        std::string version() const override;
        std::string gitsha1( unsigned int count ) const override;
    };

    } // namespace my_plugin

.. code:: cpp

    // file: MyPlugin.cc

    #include "MyPlugin.h"

    namespace my_plugin {

    REGISTER_LIBRARY( MyPlugin ); // Self-registration

    MyPlugin::MyPlugin() : atlas::Plugin( "my-plugin-name" ) {} // Name of the plugin

    const MyPlugin& MyPlugin::instance() {
        static MyPlugin plugin;
        return plugin;
    }

    std::string MyPlugin::version() const {
        return "0.0.0"; // or replace with real version
    }

    std::string MyPlugin::gitsha1( unsigned int count ) const override {
        return "not available"; // or replace with real git sha1
    }

    } // namespace my_plugin
 
It is now possible to add classes to the plugin that extend Atlas classes, just as if this plugin was part of the Atlas main library.