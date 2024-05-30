---
aspectratio: 169
---

# TARGETS

## WHAT IS A TARGET

\centering

**GNU Make** 

A target is essentially a recipe that a buildsystem uses to compile a list of files into another file. It can be a `.cpp` implementation file compiled into an `.o` object file, a group of `.o` files packaged into an `.a` static library, and many other combinations.

**CMake**

A target is a logical unit that encapsulates the properties and dependencies required to build a component of your software project.

It works on a higher level of abstraction. It understands how to build an executable directly from source files. So, you don't need to write an explicit recipe to compile any object files. All that's required is an `add_executable()` or `add_library` command with the name of the executable target and a list of the files that are to be its elements:

All that's required is to tell CMake about the structure of your project, and it will help you build it. 
We use target to tell CMake about the structure of our project and `target_link_libraries()` to express the dependencies between them.


## OVERVIEW 

<!-- 
    Targets are fundamental concept in CMake

    Next, we'll explain in detail all the steps that the toolchain takes to build a binary artifact from a target. That's the part many books about C++ are missing: how to configure and use preprocessors, compilers, and linkers properly, as well as how to optimize their behavior.

    Lastly, this section will cover all the different ways in which CMake offers to manage dependencies, and will explain how to pick the best one for your specific use case.

    
    Real-world projects require more than compiling a few source files into executables and/or libraries. In the vast majority of cases, you will be faced with projects comprising dozens to hundreds of source files sprawling in a complex source tree. Using modern CMake helps you keep the complexity of the build system in check.

-->

<!-- 
    A CMake target has dependencies and properties.
        1. Executable are targets: add executable
        2.  Libraries are targets: add library
        3. There exist some builtin targets: install, clean, package, . . .
        4.  You may create custom targets: add custom target

In CMake, a target is a core concept that represents a buildable entity within a project. Targets are used to define the final products that CMake generates, such as executables, libraries, or custom commands. Understanding and effectively using targets is crucial for managing complex build systems, especially in larger projects. Here’s a detailed description of the concept of targets in CMake:

1. Definition of a Target
A target in CMake is essentially a logical unit that encapsulates the settings and dependencies required to build a component of your software project. It can be an executable, a library, or even a custom command.
-->

- With the advent of CMake 3.0, also known as Modern CMake, there has been a significant shift in the way the CMake domain-specific language (DSL) is structured. Rather than relying on variables to convey information in a project, we should shift to using **targets** and **properties**.

- Your application is built as a collection of targets depending on each other.

- A target is something that CMake should build (i.e. generate something enabling the building of the target).

- A target is declared by either `add_executable()` or `add_library()` commands

- A target maps to a build artifact in the project (think back to the targets encountered in Make)

## TARGETS ARE OBJECTS WITH PROPERTIES 

- Targets have properties that work in a similar way to fields of C++ objects. We can modify some of these properties and others are read-only.  

- These collection of properties define **how** the build "artifact" should be produced and how it should be used by other dependent targets in the project (usage requirements)


## DEFINITION OF A TARGET - WHAT IS A TARGET

A target in CMake is essentially a logical unit that encapsulates the settings and dependencies required to build a component of your software project. It can be an executable, a library, or even a custom command.


xecutable Targets: Represent a binary that can be run. Defined using add_executable().
Library Targets: Represent shared or static libraries. Defined using add_library().
Custom Targets: Represent custom build steps or commands. Defined using add_custom_target().

## DECLARING TARGETS 

To declare a target in CMake, specific commands are used:

add_executable():

add_executable(myApp main.cpp)
This command creates an executable target named myApp from the source file main.cpp.

add_library():

add_library(myLib STATIC lib.cpp)
This command creates a static library target named myLib from the source file lib.cpp.

## PROPERTIES OF TARGETS 

Targets in CMake have properties that define their behavior. These properties control various aspects of the build process, such as compiler options, include directories, and dependencies. Properties can be set and queried using specific commands


## DEPENDENCIES BETWEEN TARGETS 

Targets can depend on one another. For example, an executable might depend on a library. Dependencies are specified using the target_link_libraries() command, which also allows defining how properties should propagate between targets.

## USAGE REQUIREMENT AND VISIBILITY

When specifying dependencies, it’s important to define how properties should propagate. CMake uses visibility levels to control this:

PRIVATE: Properties are applied only to the target itself.

PUBLIC: Properties are applied to the target and propagated to dependents.

INTERFACE: Properties are not used by the target itself but are propagated to dependents.

This command makes the include/ directory available to any target that links to myLib.

## TRANSITIVE PROPERTIES 

Properties set on a target can be transitive, meaning they propagate through the dependency graph. This helps manage complex dependencies and ensures that all required settings are consistently applied.

## SUMMARY  

In summary, targets in CMake are the building blocks of the build system, representing the various components of a software project. They encapsulate source files, build settings, and dependencies, providing a structured and maintainable way to manage the build process. By understanding and effectively using targets, developers can create robust and flexible build systems for their projects

put a graph here ...

## TARGET PROPERTIES - EXAMPLE

\vspace{1.5cm}

Targets in CMake have properties that define their behavior. These properties control various aspects of the build process, such as compiler options, include directories, and dependencies. 

```{.cmake style=cmakestyle}
add_library(greetings STATIC greeting.hpp greetings.cpp)

get_target_property(_greetings_type greetings TYPE)
get_target_property(_greetings_sources greetings SOURCES)

message(STATUS "greetings.TYPE : ${_greetings_type}") 
message(STATUS "greeting.SOURCES : ${_greetings_sources}")
```

```{.bash style=bashstyle}
$ cmake -B <build-tree> -S <source-tree>
...
-- greetings.TYPE : STATIC_LIBRARY
-- greeting.SOURCES : greetings.cpp;greetings.hpp 
```

## TARGET PROPERTIES - EXAMPLE (Cont.)

\vspace{1.5cm}

```{.cmake style=cmakestyle}
add_executable(hello hello.cpp)
target_link_libraries(hello greetings)

get_target_property(_hello_type hello TYPE)
get_target_property(_hello_sources hello SOURCES)
get_target_property(_hello_link_lib hello LINK_LIBRARIES)

message(STATUS "greetings.TYPE : ${_hello_type}") 
message(STATUS "greeting.SOURCES : ${_hello_sources}")
message(STATUS "greeting.LINK_LIBRARIES : ${_hello_link_lib}")
```

```{.bash style=bashstyle}
$ cmake -B <build-tree> -S <source-tree>
...
-- hello.TYPE : EXECUTABLE
-- hello.SOURCES : hello.cpp 
-- hello.LINK_LIBRARIES : greetings
```

## TARGET PROPERTIES - COMPILER FLAGS

<!-- 
    To print a target property on screen, we first need to store it in the `<var>` variable and then message() it to the user; we have to read them one by one. 
-->

\vspace{1cm}

The most fundamental target properties for controlling compiler flags are the following

:::::::::::::: {.columns}
::: {.column width="50%"}

```plantuml
object TARGET{
    INCLUDE_DIRECTORIES
    COMPILE_DEFINITIONS
    <LANG>_STANDARD
    COMPILE_OPTIONS
    . . .
}
```

::: 
::: {.column width="50%"}


::: 
::::::::::::::


## TARGET PROPERTIES - LINK FLAGS 

The target properties associated with linker flags

**Put a link to the full list of properties**

**Footnote: CMake defines a large list of "known properties" (see the Further reading section) that are available depending on the type of the target (executable, library, or custom).**

## TARGETS ARE OBJECTS WITH PROPERTIES 

- Any target has a collection of **properties** which specify how the build artifact should be produced and how it should be used (inherited) by other **dependent** targets in the project

- Each target has properties, which can be read with get_target_property and modified with set_target_properties. Compile options, definitions, include directories, source files, link libraries, and link options are properties of targets.

- Target properties directly influence how targets are built (compile options, definitions, dependencies, ...). Properties provide information about everything from the flags used to compile source files, through to the type and location of the built binaries, affect the tools used when compiling or linking. 

- In short, target properties are where most of the details about how to actually turn source files into binaries are collected and applied.

arget properties are a powerful feature of CMake that allow you to control how a target is built. You can set properties such as the include directories, compile options, and link flags for a target.

target_include_directories(), target_compile_options(), and target_link_libraries() are some of the functions used to set target properties.

By setting these properties, you can customize the build process for each target, giving you fine-grained control over how your project is built.

## PROPERTIES ARE NOT VARIABLES 

- Rather than holding a standalone value like a variable does, a property provides information specific to the entity (like a target) it is attached to.

- Do not confuse properties with variables

- It is very common for projects to define and use their own variables. Properties are well defined and documented by CMake and always apply to a specific entity. A likely contributor to the confusion between the two is that a property's default value is sometimes provided by a variable.

## 5 MOST COMMON COMMANDS TO HANDLE TARGETS

The five most used commands used to handle targets are:

- target_sources

- target_compile_options

- target_compile_definitions

- target_include_directories

- target_link_libraries

## TARGETS HAVE PROPERTIES 

Target properties and variables

Targets have properties attached that control their behavior. 

Properties are a form of variable that is attached to a target; you can use [get_property][] and [set_property][], or [get_target_properties][] and [set_target_properties][] (stylistic preference) to access and set these. You can see a list of all properties by CMake version; there is no way to get this programmatically. Many of these properties, such as [CXX_EXTENSIONS][], have a matching variable that starts with CMAKE_, such as [CMAKE_CXX_EXTENSIONS][], that will be used to initialize them. So you can using set property on each target by setting a variable before making the targets.


##  WHAT ARE TRANSITIVE USAGE REQUIREMENTS

- Usage: As we previously discussed, one target may depend on another. CMake documentation sometimes refers to such dependency as usage, as in one target uses another.

- Requirements: There will be cases when such a used target has specific requirements that a using target has to meet: link some libraries, include a directory, or require specific compile features

- transitive. This one I believe is correct (maybe a bit too smart). CMake appends some properties/requirements of used targets to properties of targets using them. You can say that some properties can transition (or simply propagate) across targets implicitly, so it's easier to express dependencies.

Simplifying this whole concept, I see it as propagated properties between the source target (targets that gets used) and destination targets (targets that use other targets).


## target_compile_definitions() 

This target command will populate the COMPILE_DEFINITIONS property of a <source> target. Compile definitions are simply -Dname=definition flags passed to the compiler that configure the C++ preprocessor definitions 

The interesting part here is the second argument. We need to specify one of three values, INTERFACE, PUBLIC, or PRIVATE, to control which targets the property should be passed to.

PRIVATE sets the property of the source target.
INTERFACE sets the property of the destination targets.
PUBLIC sets the property of the source and destination targets.

When a property is not to be transitioned to any destination targets, set it to PRIVATE. When such a transition is needed, go with PUBLIC. If you're in a situation where the source target doesn't use the property in its implementation (.cpp files) and only in headers, and these are passed to the consumer targets, INTERFACE is the answer.

## HOW DOES IT WORK 

How does this work under the hood? To manage those properties, CMake provides a few commands such as the aforementioned target_compile_definitions(). When you specify a PRIVATE or PUBLIC keyword, CMake will store provided values in the property of the target matching the command – in this case, COMPILE_DEFINITIONS. Additionally, if a keyword was INTERFACE or PUBLIC, it will store the value in property with an INTERFACE_ prefix – INTERFACE_COMPILE_DEFINITIONS. During the configuration stage, CMake will read the interface properties of source targets and append their contents to destination targets. There you have it – propagated properties, or transitive usage requirements – as CMake calls them.

In CMake 3.20, there are 12 such properties managed with appropriate commands such as target_link_options() or directly with the set_target_properties() command:


## HOW FAR DOES PROPAGATION REACH 

he next question that comes to mind is how far this propagation goes. Are the properties set just on the first destination target, or are they sent to the very top of the dependency graph? Actually, you get to decide.

To create a dependency between targets, we use the target_link_libraries() command. The full signature of this command requires a propagation keyword

```{.cmake style=cmakestyle}
target_link_libraries(<target>
                     <PRIVATE|PUBLIC|INTERFACE> <item>...
                    [<PRIVATE|PUBLIC|INTERFACE> <item>...]...)
```

As you can see, this signature also specifies a propagation keyword, but this one controls where properties from the source target get stored in the destination target. Figure 4.3 shows what happens to a propagated property during the generation stage (after the configuration stage is completed):

PRIVATE appends the source value to the private property of the destination.
INTERFACE appends the source value to the interface property of the destination.
PUBLIC appends to both properties of the destination.

## TARGET DEPENDENCIES AND PROPERTIES 

Target dependencies and properties I
A CMake target has dependencies and properties.
Dependencies
Most of the time, source dependencies are computed from target
specifications using CMake builtin dependency scanner (C,
C++, Fortran) whereas library dependencies are inferred via
target link libraries specification.

## EVEN MORE GRANULAR CONTROL ON SOURCE FILES

Properties
Properties may be attached to either target or source file (or
even test). They may be used to tailor prefix or suffix to be
used for libraries, compile flags, link flags, linker language,
shared libraries version, . . .
see : set target properties or set source files properties
Sources vs Targets
Properties set to a target like COMPILE FLAGS are used for
all sources of the concerned target. Properties set to a source
are used for the source file itself (which may be involved in
several targets).


## Motivation 

- Modern CMake (> 3.0) is all about relying on **targets** and **properties** rather than relying on global scope variables to convey information in a project


## TARGETS ARE OBJECTS WITH PUBLIC AND PRIVATE PROPERTIES 

- Use the
``target_compile_options()`` command to append more options.

- The options will be added after after flags in the
``CMAKE_<LANG>_FLAGS`` and ``CMAKE_<LANG>_FLAGS_<CONFIG>``
variables, but before those propagated from dependencies by the
``INTERFACE_COMPILE_OPTIONS`` property.

- The final set of options used for a target is constructed by
accumulating options from the current target and the usage requirements of
its dependencies.  The set of options is de-duplicated to avoid repetition.

## VISIBILITY LEVELS / INHERITANCE

## TARGETS ARE OBJECTS WITH PROPERTIES 

```plantuml
object TARGET{
    SOURCES => DESCRIPTION
    COMPILE_DEFINITIONS
    COMPILE_OPTIONS
}
```

## TARGETS ARE OBJECTS WITH PROPERTIES 

- Any target has a collection of **properties** which specify how the build artifact should be produced and how it should be used (inherited) by other **dependent** targets in the project

A target is the basic element in the CMake DSL. Each target has properties, which can be read with get_target_property and modified with set_target_properties. Compile options, definitions, include directories, source files, link libraries, and link options are properties of targets.

The five most used commands used to handle targets are:

- target_sources

- target_compile_options

- target_compile_definitions

- target_include_directories

- target_link_libraries


## USAGE REQUIREMENTS 

Modern CMake: target-centric

```{.cmake style=cmakestyle}
target_include_directories(geometry PUBLIC "include")
```

geometry and anything that links to it gets `-Iinclude`

Modern CMake is layout indipendent

Classic CMake: directory-centric (don't do this)

```{.cmake style=cmakestyle}
include_directories("include")
```

Targets in this directory and subdirs get `-Iinclude`

## QUERYING PROPERTIES ON THE COMMAND LINE

```{.bash style=bashstyle}
$ cmake --help-property COMPILE_OPTIONS
```

## ADDITIONAL TARGETS 

There are additional commands in the `target_*` family:

```{.bash style=bashstyle}
$ cmake --help-command-list | grep "^target_"
```

target_compile_definitions
target_compile_features
target_compile_options
target_include_directories
target_link_directories
target_link_libraries
target_link_options
target_precompile_headers
target_sources


## VISIBILITY LEVELS 

- It is much more robust to use targets and properties than using variables and here we will discuss why.

- Visibility levels PRIVATE, PUBLIC, or INTERFACE are very powerful but not easy to describe and imagine in words. Maybe a better approach to demonstrate what visibility levels is to see it in action.

## exporting importing your project

Exporting/Import your project
Export/Import to/from others
CMake can help project using CMake as a build system to
export/import targets to/from other project using CMake as a
build system.
No more time for that today sorry, see:
http://www.cmake.org/Wiki/CMake/Tutorials/Exporting_
and_Importing_Targets

## SUMMARY 

Understanding targets is critical to writing clean, modern CMake projects. In this chapter, we not only discussed what constitutes a target and how targets depend on each other but also how to present that information in a diagram using the Graphviz module. With this general understanding, we were able to learn about the key feature of targets – properties (all kinds of properties). We not only went through a few commands to set regular properties on targets; we also solved the mystery of transitive usage requirements or propagated properties. This was a hard one to solve, as we not only needed to control which properties get propagated but also how to reliably propagate them to selected, further targets. Furthermore, we discovered how to guarantee that those propagated properties are compatible when they arrive from multiple sources.

We then briefly discussed pseudo targets – imported targets, alias targets, and interface libraries. All of them will come in...

## CONCLUSION 

The concept of properties isn't unique to targets; CMake supports setting properties of other scopes as well: GLOBAL, DIRECTORY, SOURCE, INSTALL, TEST, and CACHE. To manipulate all kinds of properties, there are general get_property() and set_property() commands. You can use these low-level commands to do exactly what the set_target_properties() command does, just with a bit more work:

```{.cmake style=cmakestyle}
set_property(TARGET <target> PROPERTY <name> <value>)
```