Object oriented design in C++
#############################

.. role:: cpp(code)
    :language: cpp

.. role:: info
    :class: m-text m-info

.. role:: yellow
    :class: m-text m-warning

Atlas is primarily written in the C++ programming language. The C++ programming
language facilitates OO design, and is high performance computing capable.
The latter is due to the support C++ brings for hardware
specific instructions. In addition, the high compatibility of C++ with C allows
Atlas to make use of specific programming models such as 
CUDA to support GPU's, and facilitates the creation of C-Fortran
bindings to create generic Fortran interfaces.

.. contents::
  :class: m-block m-default

Abstract interface (ObjectBase)
-------------------------------

A commonly used feature in Atlas and in object-oriented programming is inheritance and polymorphism.
This is used to define a common abstract interface ``method()`` in a class ``ObjectBase``,
with implementations in concrete classes ``ObjectA`` and ``ObjectB``.

.. figure:: {static}/design/img/cpp_polymorphism.png
    :width: 500 px

An example construction to create a concrete ``ObjectA`` in `Modern C++` would be:

.. code:: cpp

    std::shared_ptr<ObjectBase> object{ new ObjectA( args... ) };

Now algorithms can be created accepting the abstract ``ObjectBase``

.. code:: cpp

    void use_object( const ObjectBase& object ) {
        object.method();
    }
    
    ...
    
    use_object( *object );

Factory with self-registration (ObjectFactory, ObjectBuilder)
-------------------------------------------------------------

In above example the abstract ``object`` is hard-coded to be of concrete type ``ObjectA``.
You may want to have this configurable depending on a user-defined string ``object_type``.
You could then do:

.. code:: cpp

    std::shared_ptr<ObjectBase> object;
    if( object_type == "A" ) {
        object = std::shared_ptr<ObjectBase>{ new ObjectA( args... ) };
    }
    if( object_type == "B" ) {
        object = std::shared_ptr<ObjectBase>{ new ObjectB( args... ) };
    }

In order to avoid repeating this code in every place this is required, in Atlas we employ a Factory mechanism.
with self-registration, so that the above code could be transformed to:

.. code:: cpp

    std::shared_ptr<ObjectBase> object = ObjectFactory::build( object_type, args... )

The method ``ObjectFactory::build()`` can in principle just wrap the above code, but for reasons of
maintainability and more importantly extensibility, Atlas implements this using self-registration and an
abstract ``ObjectBuilder`` as follows:

.. figure:: {static}/design/img/cpp_factory.png
    :alt: cpp_factory.png

All that is now needed to register a concrete ``ObjectBuilder`` is to place 

.. code:: cpp

    static ObjectBuilderT<ObjectA> builder_A{ "A" };
    static ObjectBuilderT<ObjectA> builder_B{ "B" };

anywhere in a global scope. A good place would be in the file where each concrete ``Object`` is defined.
When the code is compiled into a shared library, then these builders are automatically registered in
the ``ObjectFactory`` when the library is loaded at run-time.

.. block-warning:: Extending Atlas

    .. note-success::

        You can now also define your own ``ObjectC`` in your user-code, and register it with above
        mechanism so that you effectively extended Atlas unintrusively!
    
    .. code:: cpp

        // File ObjectC.cc

        class ObjectC : public ObjectBase {
            void method() override() { /* your own implementation */ }
        };

        ObjectBuilderT<ObjectC> builder_C{ "C" };

`Pointer to abstract implementation (Object)`_
----------------------------------------------

Another idiom which is adopted in Atlas is the `Pointer to implementation (PIMPL)` idiom.
This means that we create a class ``Object`` which contains as only data member a (shared)
pointer to the implementation ``ObjectBase``, but also mimics the public interface of
``ObjectBase`` but delegates execution to the encapsulated pointer:

.. figure:: {static}/design/img/cpp_pimpl.png
    :alt: cpp_pimpl.png

This certainly adds a maintainance cost to the Atlas core developers, as every public routine
in ``ObjectBase`` must be reproduced in ``Object``.
It however adds several advantages for the user, and user-code:

- :info:`Value semantics.` You do not have to handle the raw pointer :cpp:`ObjectBase*`, e.g. by creating a 
  :cpp:`shared_ptr<ObjectBase>`, and you do not need to use the :cpp:`->` operator.
  This also ensures that when the ``Object`` instance goes out of scope, the internal pointer gets deleted
  (if it is the only instance of the same shared pointer).

- :info:`Factory builder.` The creation of concrete types is embedded in the constructor of ``Object``!

- :info:`A compilation firewall.` This is achieved because it is not required to :cpp:`#include <ObjectBase.h>`
  inside :yellow:`Object.h` (only a forward declaration suffices as it is a pointer).

.. block-success:: Beautiful simple API

    The result of all of the above is a beautiful and simple API. It should be possible to simply write:
    
    .. code:: cpp
    
        Object object{"A"}; // --> Use implementation `ObjectA`
        object.method();
        
    .. code:: cpp
    
        void use_object( Object& obj ) {
            obj.method();
        }
    
    .. note-warning::
    
        Copying or assigning an ``Object`` instance is not a deep-copy, but rather only a copy of the internal
        (shared) pointer. Therefore the `pass-by-reference` (:cpp:`&`) in the last snippet is not strictly necessary,
        but however a very small performance optimization: no reference counting needs updating in the :cpp:`shared_ptr`.

Object oriented design in Fortran
#################################

With much of the NWP operational software
written in Fortran, significant effort
in the Atlas design has been devoted to having a Fortran OO
Application Programming Interface (API)
wrapping the C++ concepts as closely as possible.

The Fortran API mirrors the C++ classes with a Fortran
derived type, whose only data member is a raw pointer to an
instance of the matching C++ class. The Fortran derived type
also contains member functions or subroutines that delegate
its implementation to matching member functions of the C++ class instance.
Since Fortran does not directly interoperate with
C++, C interfaces to the C++ class member functions are created first, and
it is these interfaces that the Fortran derived type delegates to.
The whole interaction procedure is schematically shown:

.. figure:: {static}/design/img/Fortran-Cpp.png
    :width: 400 px
    :alt: Image alt text
    :target: {static}/design/img/Fortran-Cpp.pdf
    
.. note-info::

    When a method in the Fortran object is called,
    it will actually be executed by the instance of its matching
    C++ class, through a C interface. This very much so has resemblance
    to the `Pointer to abstract implementation (Object)`_ idiom

.. note-warning::

    The overhead created by delegating function calls from the Fortran API
    to a C++ implementation can be disregarded
    if performed outside of a computational loop. Atlas is primarily used
    to manage the data structure in a OO manner, and the actual field data should
    be accessed from the data structure before a computational loop starts.

