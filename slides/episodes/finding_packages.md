---
aspectratio: 169
---

# Finding Packages 

## Overview 

<!--
    In this chapter we will talk about how to detect external/third party 
    libraries in CMake. There comes a time where as your project grows 
    you want to make use of external libraries, programs, files...
-->

Projects often depend on other projects and libraries.

- How to detect/find third party libraries?
- How to link to these external libraries?


Project may be using external libraries, program, files...
In CMake 
Those can be found using the `find_package()` command.

Maybe have a code snippet motivating the example, questions and so on?
Maybe show a compilation line with manual linking

Should we maybe have an example with the math library?
maybe replace the above with the math library...!

Highlight that we are not talking about installing them, we assume these libraries 
ideally already installed on our system 

## Finding Packages in CMake

In CMake there are two ways for searching packages

- **Modules** 
- **CMake package configurations** 
- **PkgConfig**
- **Write your own Find<package>.cmake module**

but both of them use the same inferface `find_package()`

Mention that the way we will present the different approaches is in order of priority...


## MOTIVATING EXAMPLE - HELLO WORLD WITH MPI

\vspace{.5cm}

<!--
    An alternative and often complementary approach to OpenMP shared-memory parallelism
    is the Message Passing Interface (MPI), which has become the de facto standard for
    modeling a program executing in parallel on a distributed memory system. Although
    modern MPI implementations allow shared-memory parallelism as well, a typical approach
    in high-performance computing is to use OpenMP within a compute node combined with
    MPI across compute nodes. The implementation of the MPI standard consists of the
    following.
-->

:::::::::::::: {.columns}
::: {.column width="75%"}

```cpp
#include <iostream>
#include <mpi.h>

int main(int argc, char **argv) {

    MPI_Init(NULL, NULL); 

    // Get the rank of the process
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    // Print off a hello world message
    call to greetings library
    
    MPI_Finalize(); 
}
```

:::
::: {.column width="25%"}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [hello-world
      [greetings.hpp, file
      ]
      [greetings.cpp, file
      ]
      [main.cpp, file
      ]
      [hello-mpi.cpp, file
      ]
    ]
  ]
\end{forest}

:::
::::::::::::::

## OBJECTIVE / MANUAL COMPILATION 

## OBJECTIVE 

maybe show what would be our objective if doing so via manual compilation

```{.bash style=bashstyle}
mpic++ .. 
```

```{.bash style=bashstyle}
mpic++ --showme compiler wrapper
```


## SETTING THE GLOBAL CXX COMPILER TO THE MPI WRAPPER 

I would mention this later but not now as it would create confusion, 
you would be adding a lot of pecies Indeed also because we know the reasons

- The logic with respect to TPL should be handled by your CMake build configuration 
  - What if you want to apply -D HAVE_MPI flags to your executables 
  - What if you need to enable another TPL based on whether you enabled MPI or not

show the cmakelists.txt file as it was before 

and set the compiler from the command line globally

\alert{How to achieve this in CMake?}


## HOW TO DO IT (I) : DETECTING MPI

In this recipe, we set out to find the MPI implementation: library, header files, compiler
wrappers, and launcher. To do so, we will leverage the FindMPI.cmake standard CMake
module:

1. First, we define the minimum CMake version, project name, supported language,
and language standard:

```{.cmake style=cmakestyle}
cmake_minimum_required(VERSION 3.9 FATAL_ERROR)
project(hello-mpi LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
```

2. We then call find_package to locate the MPI implementation:
```{.cmake style=cmakestyle}
find_package(MPI REQUIRED)
```

## HOW TO DO IT (II) : LINKING AGAINST MPI

3. We define the executable name and, source, and similarly to the previous recipe,
link against the imported target:

```{.cmake style=cmakestyle}
add_executable(hello-mpi hello-mpi.cpp)
target_link_libraries(
    hello-mpi
    PUBLIC
        MPI::MPI_CXX
)
```

- You could also leave it as PRIVATE since we will not be linking against the executable anyhow

## HOW TO DO IT (III)

4. Let us configure and build the executable:


$ mkdir -p build
$ cd build
$ cmake -D CMAKE_CXX_COMPILER=mpicxx ..
-- ...
-- Found MPI_CXX: /usr/lib/openmpi/libmpi_cxx.so (found version
"3.1")

-- Found MPI: TRUE (found version "3.1")
-- ...
$ cmake --build .

1. To execute this program in parallel, we use the mpirun launcher (in this case,
using two tasks):
$ mpirun -np 2 ./hello-mpi
Hello world from processor larry, rank 1 out of 2 processors
Hello world from processor larry, rank 0 out of 2 processors
##  Finding Packages - Predefined Modules 

CMake has a rather extensive set of prepackaged modules to detect the most commonly used libraries and programs, such as Python and Boost for example

Just pring the list to screen with the grep command to show a few

However, not all libraries and programs are covered and from time to time you will have to provide your own detection scripts

In this
chapter, we will discuss the necessary tools and discover the find family of CMake
commands:
find_file to find a full path to a named file
find_library to find a library
find_package to find and load settings from an external project
find_path to find a directory containing the named file
find_program to find a program

a list with all cmake modules for a particular version...

##  Finding Packages - Modules 

Find modules usually defines standard variables (for module XXX)
1 XXX FOUND: Set to false, or undefined, if we haven’t found, or don’t
want to use XXX.
2 XXX INCLUDE DIRS: The final set of include directories listed in one
variable for use by client code.
3 XXX LIBRARIES: The libraries to link against to use XXX. These
should include full paths.
4 XXX DEFINITIONS: Definitions to use when compiling code that uses
XXX.
5 XXX EXECUTABLE: Where to find the XXX tool.
6 XXX LIBRARY DIRS: Optionally, the final set of library directories
listed in one variable for use by client code.
See doc cmake --help-module FindLibXml2
Many modules are provided by CMake (130 as of CMake 2.8.7)
CMake

## How does find_package() command works?

find_package is a wrapper command for CMake modules written for discovering and
setting up packages. These modules contain CMake commands to identify packages in
standard locations on the system. The files for the CMake modules are called
Find<name>.cmake and the commands they contain will be run internally when a call to
find_package(<name>) is issued.

## how does findMPI.cmake works 

also set up a handful of useful variables, reflecting what was actually found, which you can
use in your own CMakeLists.txt. In the case of the Python interpreter, the relevant
module is FindPythonInterp.cmake, which is shipped with CMake, and sets the
following variables:

It is possible to force CMake to look for specific versions of a package. For example, use this
to request any version of the Python interpreter greater or equal to 2.7:
find_package(PythonInterp 2.7)
It is also possible to enforce that dependencies are satisfied:
find_package(PythonInterp REQUIRED)
In this case, CMake will abort configuration if no suitable executable for the Python
interpreter is found in the usual lookup locations

## FinMPI.cmake 

Use the same example as for the OpenMP with the how it works...
and then explain these aspects about imported targets...

## HOW IT WORKS 

[ 117 ]
How it works
Our simple example seems to work: the code compiled and linked, and we observe a
speed-up when running on multiple cores. The fact that the speed-up is not a perfect
multiple of OMP_NUM_THREADS is not our concern in this recipe, since we focus on the
CMake aspect of a project which requires OpenMP. We have found linking to OpenMP to
be extremely compact thanks to imported targets provided by a reasonably modern
FindOpenMP module:
target_link_libraries(example
PUBLIC
OpenMP::OpenMP_CXX
)
We did not have to worry about compile flags or about include directories - these settings
and dependencies are encoded in the definition of the library OpenMP::OpenMP_CXX which
is of the IMPORTED type. As we mentioned in Recipe 3, Building and linking static and shared
libraries, in Chapter 1, From a Simple Executable to Libraries, IMPORTED libraries are pseudotargets
that fully encode usage requirements for dependencies outside our own project. To
use OpenMP one needs to set compiler flags, include directories, and link libraries. All of
these are set as properties on the OpenMP::OpenMP_CXX target and transitively applied to
our example target simply by using the target_link_libraries command. This makes
using libraries within our CMake scripts exceedingly easy. We can print the properties of
interface with the cmake_print_properties command, offered by the
CMakePrintHelpers.cmake standard module:
include(CMakePrintHelpers)
cmake_print_properties(
TARGETS
OpenMP::OpenMP_CXX
PROPERTIES
INTERFACE_COMPILE_OPTIONS
INTERFACE_INCLUDE_DIRECTORIES
INTERFACE_LINK_LIBRARIES
)
Note that all properties of interest have the prefix INTERFACE_, because these properties
usage requirements for any target wanting to interface and use the OpenMP target.

## MPI example 

the Message Passing Interface (MPI), which has become the de facto standard for
modeling a program executing in parallel on a distributed memory system. Although
modern MPI implementations allow shared-memory parallelism as well, a typical approach
in high-performance computing is to use OpenMP within a compute node combined with
MPI across compute nodes. The implementation of the MPI standard consists of the
following:
1. Runtime libraries.
2. Header files and Fortran 90 modules.
3. Compiler wrappers, which invoke the compiler that was used to build the MPI
library with additional command-line arguments to take care of include
directories and libraries. Usually, the available compiler wrappers are
mpic++/mpiCC/mpicxx for C++, mpicc for C, and mpifort for Fortran.
1. MPI launcher: This is the program you should call to launch a parallel execution
of your compiled code. Its name is implementation-dependent and it is usually
one of the following: mpirun, mpiexec, or orterun.

## Getting ready 

Getting ready
The example code (hello-mpi.cpp, downloaded from http:/ / www. mpitutorial. com),
which we will compile in this recipe, will initialize the MPI library, have every process
print its name, and eventually finalize the library:


<!-- 

## HOW TO DO IT 

In this recipe, we set out to find the MPI implementation: library, header files, compiler
wrappers, and launcher. To do so, we will leverage the FindMPI.cmake standard CMake
module:
1. First, we define the minimum CMake version, project name, supported language,
and language standard:
cmake_minimum_required(VERSION 3.9 FATAL_ERROR)
project(recipe-06 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
2. We then call find_package to locate the MPI implementation:
find_package(MPI REQUIRED)
3. We define the executable name and, source, and similarly to the previous recipe,
link against the imported target:
add_executable(hello-mpi hello-mpi.cpp)
target_link_libraries(hello-mpi
PUBLIC
MPI::MPI_CXX
)


## Configure 

4. Let us configure and build the executable:


$ mkdir -p build
$ cd build
$ cmake -D CMAKE_CXX_COMPILER=mpicxx ..
-- ...
-- Found MPI_CXX: /usr/lib/openmpi/libmpi_cxx.so (found version
"3.1")

-- Found MPI: TRUE (found version "3.1")
-- ...
$ cmake --build .

1. To execute this program in parallel, we use the mpirun launcher (in this case,
using two tasks):
$ mpirun -np 2 ./hello-mpi
Hello world from processor larry, rank 1 out of 2 processors
Hello world from processor larry, rank 0 out of 2 processors

## alternatives

CMake has modules for finding many widespread software packages. We
recommend to always search the CMake online documentation for
existing Find<package>.cmake modules and to read their
documentation before using them. The documentation for the
find_package command can be found at https:/ / cmake. org/ cmake/
help/ v3. 5/ command/ find_ package. html. A


## How it works

Remember that the compiler wrapper is a thin layer around the compiler used to build the
MPI library. Under the hood, it will call the same compiler and augment it with additional
arguments, such as include paths and libraries, needed to successfully build a parallel
program.
Which flags does the wrapper actually apply when compiling and linking a source file? We
can probe this using the --showme option to the compiler wrapper. To find out the
compiler flags we can use:
$ mpicxx --showme:compile
-pthread
Whereas to find out the linker flags we use the following:
$ mpicxx --showme:link
-pthread -Wl,-rpath -Wl,/usr/lib/openmpi -Wl,--enable-new-dtags -
L/usr/lib/openmpi -lmpi_cxx -lmpi
Similarly to the previous OpenMP recipe, we have found the linking to MPI to be extremely
compact thanks to the imported targets provided by a reasonably
modern FindMPI module:

target_link_libraries(hello-mpi
PUBLIC
MPI::MPI_CXX
)

We did not have to worry about compile flags or about include directories - these settings
and dependencies are already encoded as INTERFACE-type properties in the IMPORTED
target provided by CMake.
And as discussed in the previous recipe, for CMake versions below 3.9, we would have to
do a bit more work:
add_executable(hello-mpi hello-mpi.c)
target_compile_options(hello-mpi
PUBLIC
${MPI_CXX_COMPILE_FLAGS}
)
target_include_directories(hello-mpi
PUBLIC
${MPI_CXX_INCLUDE_PATH}
)
target_link_libraries(hello-mpi
PUBLIC
${MPI_CXX_LIBRARIES}
)
In this recipe, we have discussed C++, but the arguments and approach are equally valid for
a C or Fortran project.


## CONFIGURATION MODE

Eigen provides native CMake support, which makes it easy to set up a C++ project using it.
Starting from version 3.3, Eigen ships CMake modules that export the appropriate
target, Eigen3::Eigen, which we have used here.
You will have noticed the CONFIG option to the find_package command. This signals to
CMake that the package search will not proceed through a FindEigen3.cmake module,
but rather through the Eigen3Config.cmake, Eigen3ConfigVersion.cmake, and
Eigen3Targets.cmake files provided by the Eigen3 package in the standard
location, <installation-prefix>/share/eigen3/cmake. This package location mode
is called "Config" mode and is more versatile than the Find<package>.cmake approach
we have been using so far. For more information about "Module" mode versus "Config"
mode, please consult the official documentation at https:/ / cmake. org/ cmake/ help/ v3. 5/
command/ find_ package. html.


## There is more

I am just missing an example here...

CMake will look for config modules in a predefined hierarchy of locations. First off is
CMAKE_PREFIX_PATH, while <package>_DIR is the next search path. Thus, if Eigen3 was
installed in a non-standard location, we can use two alternatives to tell CMake where to
look for it:
1. By passing the installation prefix for Eigen3 as CMAKE_PREFIX_PATH:
$ cmake -D CMAKE_PREFIX_PATH=<installation-prefix> ..
2. By passing the location of the configuration files as Eigen3_DIR:
$ cmake -D Eigen3_DIR=<installation-prefix>/share/eigen3/cmake/

## adfai

You may write your own:
http://www.cmake.org/Wiki/CMake:Module_Maintainers
You may find/borrow modules from other projects which use CMake
KDE4:
http://websvn.kde.org/trunk/KDE/kdelibs/cmake/modules/
PlPlot: http://plplot.svn.sourceforge.net/viewvc/plplot/
trunk/cmake/modules/
http://cmake-modules.googlecode.com/svn/trunk/Modules/
probably many more. . .
A module may provide not only CMake variables but new CMake
macros (we will see that later with the MACRO, FUNCTION
CMake language commands

##  Finding Packages - Modules 

```{.cmake style=cmakestyle}
# CMakeLists.txt
find_package(<package_name> REQUIRED)
```

- Looks for a file named `find<package_name>.cmake` in the CMake cache variable `CMAKE_MODULE_PATH`
- The `REQUIRED` keyword causes a missing package to fail the configure step
- The CMake scripts define variables and imported targets


- Maybe add a link to where one can find the CMake modules


## Finding Packages - Package Configurations

The preferred approach is to have an installed package provide its own details to CMake, there are config files and come with many packages (CMake compatible version of `.pc` files). The advantage is that while CMake includes a FindBoost, it has to be updated with each new Boost release, whereas BoostConfig.cmake can be included with each Boost release

If a `Find<package_name>.cmake` is not found, then it will try and find a `<package_name>Config.cmake` in the following locations:

| Syntax      | Description |
| ----------- | ----------- |
| Header      | Title       |
| Paragraph   | Text        |

including `<package_name>_DIR` if that variable exists (you can set it in the `CMakeLists.txt` file)

## Finding Packages - Package Configurations: Environment Hints

- In CMake 3.12+, individual packages locations can be hinted by setting their installation root path in `<PackageName>_ROOT`
- The CMake cache variable `CMAKE_PREFIX_PATH` can be used to hint a list of installation root paths at once

## FindPackage.cmake

## PackageConfig


## {.standout}

If you are a package author, never supply a Find<package>.cmake, but instead always supply a <package>Config.cmake with all your builds. 

## {.standout}

Exercise

* Can you ...

## The last resort

Finding dependencies
CMake offers a family of commands to find artifacts installed on your system:

find_file to retrieve the full path to a file.

find_library to find a library, shared or static.

find_package to find and load settings from an external project.

find_path to find the directory containing a file.

find_program to find an executable.


## LAST RESORT 

What if no module, CMake configuration or ... is available? What to do in that situation ?

## The other find_xxxx commands I

find package is a high level module finding mechanism but
there are lower-level CMake commands which may be used to
write find modules or anything else inside CMakeLists.txt
to find an executable program: find program
to find a library: find library
to find any kind of file: find file
to find a path where a file reside: find path

# handle the QUIETLY and REQUIRED arguments and s e t PRELUDE FOUND t o TRUE i f
43 # a l l l i s t e d v a r i a b l e s are TRUE
44 inc lude ( FindPackageHandleStandardArgs )
45 FIND PACKAGE HANDLE STANDARD ARGS(PRELUDE
46 REQUIRED VARS PRELUDE COMPILER PRELUDE INCLUDE DIR)
CMake tutorial 62 / 118
N

## MORE

Installed External package
The previous examples suppose that you have the package you
are looking for on your host.
you did install the runtime libraries
you did install eventual developer libraries, headers and tools
What if the external packages:
are only

## The different CMake modes 

Normal mode: the mode used when processing CMakeLists.txt
Command mode: cmake -E <command>, command line mode which
offers basic command in a portable way:
works on all supported CMake platforms. I.e. you don’t want to
rely on shell or native command interpreter capabilities.
Process scripting mode: cmake -P <script>, used to execute a
CMake script which is not a CMakeLists.txt.
Wizard mode: cmake -i, interactive equivalent of the Normal
mode.
CMake

- not all CMake commands are scriptable

## CMake scripting

CMake is a declarative language which contains 90+
commands. It contains general purpose constructs: set , unset,
if , elseif , else , endif, foreach, while, break



## DETECING EXTERNAL LIBRARIES: PKG-CONFIG

see chapter-03/recipe-09; the example is in C


We have so far discussed two ways of detecting external dependencies:
Using find-modules shipped with CMake. This is generally reliable and well
tested. However, not all packages have a find-module in the official release of
CMake.
Using <package>Config.cmake, <package>ConfigVersion.cmake,
and <package>Targets.cmake files provided by the package vendor and
installed alongside the package itself in standard locations.

What if a certain dependency provides neither a find-module nor vendor-packaged CMake
files? In this case, we are left with two options:
Rely on the pkg-config utility to discover packages on the system. This relies
on the package vendors distributing metadata about their packages in .pc
configuration files.
Write our own find-package module for the dependency.

## Overview

In this recipe, we will show how to leverage pkg-config from within CMake to locate the
FFTW ìlibrary. The next recipe, Detecting external libraries: II. Writing a findmodule, will show how to write your own basic find-module for FFTW


## Step by step instructions 

dfd 

## How it works?

Once pkg-config is found, CMake will provide two functions to wrap the functionality
offered by this program:
pkg_check_modules, to find all modules (libraries and/or programs) in the
passed list
pkg_search_module, to find the first working module in the passed list
These functions accept the REQUIRED and QUIET arguments, as find_package does. In
more detail, our call to pkg_search_module is the following:
pkg_search_module(
ZeroMQ
REQUIRED
libzeromq libzmq lib0mq
IMPORTED_TARGET
)
Here, the first argument is the prefix that will be used to name the target that is storing the
result of the search for the ZeroMQ library: PkgConfig::ZeroMQ. Notice that we need to
pass different options for the names of the library on the system: libzeromq, libzmq,
and lib0mq. This is due to the fact that different operating systems and package managers
can choose different names for the same package.

## Writing a find module

This recipe complements the previous recipe, Detecting external libraries: I. Using pkg-config.
We will show how to write a basic find-module to locate the ZeroMQ messaging library on
your system so that the detection of the library can be made to work on non-Unix operating
systems. We will reuse the same server-client sample code.

## explanation 

The module documentation consists of:

An underlined heading specifying the module name.

A simple description of what the module finds. More description may be required for some packages. If there are caveats or other details users of the module should be aware of, specify them here.

A section listing imported targets provided by the module, if any.

A section listing result variables provided by the module.

Optionally a section listing cache variables used by the module, if any.

If the package provides any macros or functions, they should be listed in an additional section, but can be documented by additional .rst: comment blocks immediately above where those macros or functions are defined.

The find module implementation may begin below the documentation block. Now the actual libraries and so on have to be found. The code here will obviously vary from module to module (dealing with that, after all, is the point of find modules), but there tends to be a common pattern for libraries.


## common pattern for finding the library
steps 

## Step 1

First, we try to use pkg-config to find the library. Note that we cannot rely on this, as it may not be available, but it provides a good starting point.

find_package(PkgConfig)
pkg_check_modules(PC_Foo QUIET Foo)
This should define some variables starting PC_Foo_ that contain the information from the Foo.pc file

## Step 2


Just add a simple example with fftw

-->