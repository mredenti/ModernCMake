---
aspectratio: 169
---

# Targets

## Targets

CMake is all about targets and properties. An executable is a target, a library is a
target. Your application is built as a collection of targets depending on each other.

## Motivation 

- Real-world projects 

- The importance of targets in CMake

- Modern CMake (> 3.0) is all about relying on **targets** and **properties** rather than relying on global scope variables to convey information in a project

## Targets 

- A target is declared by either `add_executable` or `add_library` commands

- A target maps to a build artifact in the project (think back to the targets encountered in Make)


## TARGETS ARE OBJECTS WITH PROPERTIES 

```plantuml
object TARGET{
    SOURCES
    COMPILE_DEFINITIONS
    INCLUDE_DIRECTORIES
    <LANG>_STANDARD
    COMPILE_OPTIONS
    LINK_LIBRARIES
    ...
}
```

**Put a link to the full list of properties**

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