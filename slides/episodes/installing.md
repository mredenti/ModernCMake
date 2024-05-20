---
aspectratio: 169
---

# Installing 

## Overview

In previous chapters, we have shown how to configure, build, and test our projects using
CMake. Installing projects is an equally important part of the developer's toolbox, and this
chapter will demonstrate how to achieve that

We will walk you through the various steps to be taken in refining the installation of a
simple C++ project: from making sure that important files built in your project are copied
over to the right directories, to ensuring that other projects depending on your work can
detect it using CMake. The four recipes in this chapter will build upon the simple example
given in Chapter 1, From a Simple Executable to Libraries, Recipe 3, Building and linking shared
and static libraries. There we tried to build a very simple library and link it into an
executable. We also showed how to build both a static and a shared library out of the same
source files. In this chapter, we will go a bit deeper and discuss and formalize what
happens at install time.

## Installing your project

In this very first recipe, we will introduce our small project and some of the basic concepts
that will be used also in the subsequent recipes. Installing files, libraries, and executables is
a very basic task, but it can present some pitfalls. We will walk you through these and show
you how to effectively avoid many of them with CMake.

## From docs

- Software is typically installed into a directory separate from the source and build trees. This allows it to be distributed in a clean form and isolates users from the details of the build process. 
- CMake provides the install command to specify how a project is to be installed. This command is invoked by a project in the CMakeLists file and tells CMake how to generate installation scripts. 
- The scripts are executed at install time to perform the actual installation of files.

## Motivation 

Following the development of the source code, making the build robust and implementing automated tests,  the final step of making the software available for distribution is critical. It has a direct effect on the end user's first impressions of the project. 

- How should a project be made available?
  - A pre-built binary package that they can install and use on their machine, preferably available via some already familiar package management system
- Given the variety of package managers and delivery formats
involved, this can present a daunting challenge for project maintainers. Nevertheless, there are
enough common elements between most of them that with some judicious planning, it is possible to
support most of the popular ones and cover all major platforms.

Does the project provide anything that other CMake projects may want to use in their own
builds (libraries, executables, headers, resources, etc.)?

## Packaging

various package formats that CMake and CPack can produce. The implementation of
that support uses the install functionality described here to install to a clean staging area and then
produce the final packages from those contents.

## How to structure a package for distribution 

For projects intending to support being included as part of a Linux distribution, there will
almost certainly be very specific guidelines on where each type of file should be installed. The
Filesystem Hierarchy Standard forms the basis of most distributions’ layout, and many other
Unix-based systems follow a similar structure. Even if not aiming for inclusion in a distribution
directly, the FHS still serves as a good guide for how to structure a package to achieve a smooth
and robust installation on many Unix-based systems.

## Relative layout 

- A common arrangement sees executables
(and for Windows, also DLLs) installed to a bin directory, libraries to lib or some variant thereof,
and headers under an include directory. Other file types have somewhat more variability in where
they are typically installed, but these three already cover some of the most important file types a
project will install.

## GNU Install Layout 

In the absence of any other requirements, CMake’s GNUInstallDirs module provides a very
convenient way to use a standard directory layout. It is consistent with the common cases
mentioned above, and it also provides various other standard locations that conform to both GNU
coding standards and the FHS.

```{.cmake style=cmakestyle}
# Minimal inclusion, but see caveat further below
include(GNUInstallDirs)
```

## Base Install Location 

The choice of base install location is closely tied to the target platform, with each one having its
own common practices and guidelines. On Windows, the base install location is usually a
subdirectory of `C:\Program Files`, whereas on most other systems, it is /usr/local or a subdirectory
of /opt. CMake provides a number of controls for managing the base install location to mostly
abstract away these platform differences. Perhaps the most important is the CMAKE_INSTALL_PREFIX
variable, which controls the base install location when the user builds the install target (the target
may be called INSTALL with some generator types). The default value of `CMAKE_INSTALL_PREFIX is C:\Program Files\${PROJECT_NAME} on Windows and /usr/local on Unix-based platforms`


## Installing project targets 

Projects use the install() command to define what to install, where those things should be located,
and so on. This command has a number of different forms, each focused on a particular type of
entity which is specified by the first argument to the command.

One of the key forms is for
installing one or more targets provided by the project (as opposed to imported targets provided by
something external to the project):

## Making your project consumable by providing config package support 