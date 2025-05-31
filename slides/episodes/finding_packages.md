---
aspectratio: 169
---

# FINDING DEPENDENCIES

## Motivation

<!--
    In this chapter we will talk about how to detect external/third party 
    libraries in CMake. There comes a time where as your project grows 
    you want to make use of external libraries, programs, files...

  \centering Projects often depend on other projects and libraries. 
-->

\vspace{.5cm}

\centering

As your project grows, you often need to make use of **external libraries** to add functionality or improve the performance of your code.


\vspace{.5cm}

. . . 

- How can we detect and find third-party libraries in CMake?
  
- How do we link these external libraries to our project?

<!--
    In this chapter we will talk about how to detect external/third party 
    libraries in CMake. There comes a time where as your project grows 
    you want to make use of external libraries, programs, files...
-->

## HELLO WORLD WITH MPI

\vspace{.2cm}

<!--
    An alternative and often complementary approach to OpenMP shared-memory parallelism
    is the Message Passing Interface (MPI), which has become the de facto standard for
    modeling a program executing in parallel on a distributed memory system. Although
    modern MPI implementations allow shared-memory parallelism as well, a typical approach
    in high-performance computing is to use OpenMP within a compute node combined with
    MPI across compute nodes. The implementation of the MPI standard consists of the
    following.

    The message passing interface (MPI) is a standardized means of exchanging data 
    between multiple processors running a parallel program across distributed memory.
-->

:::::::::::::: {.columns}
::: {.column width="70%"}

```cpp
#include <iostream>
#ifdef HAVE_MPI
#include <mpi.h>
#endif

int main(int argc, char **argv) {
#ifdef HAVE_MPI
    MPI_Init(&argc, &argv);
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    std::cout << "Hello World \
            from rank " << rank << std::endl;
    MPI_Finalize();
#else
    std::cout << "Hello World" << std::endl;
#endif
    return 0;
}
```

:::
::: {.column width="30%"}

\vspace{2cm}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [helloWorldMPI
      [\colorbox{pink}{hello.cpp}, file
      ]
    ]
  ]
\end{forest}

:::
::::::::::::::

## COMPILING MANUALLY WITH MPI 

The implementation of the MPI standard consists of the following:

\vspace{.2cm}

:::::::::::::: {.columns}
::: {.column width="50%"}

1. Runtime libraries.

2. Header files and Fortran 90 modules.

:::
::: {.column width="50%"}

3. Compiler wrappers (`mpicxx`, `mpifort`, ...)

<!--
  which invoke the compiler that was used to build the MPI
  library with additional command-line arguments to take care of include
  directories and libraries. Usually, the available compiler wrappers are
  mpic++/mpiCC/mpicxx for C++, mpicc for C, and mpifort for Fortran.
-->

4. MPI launcher (`mpirun`, `mpiexec`, ...)

<!-- 
  This is the program you should call to launch a parallel execution
  of your compiled code. Its name is implementation-dependent and it is usually
  one of the following: mpirun, mpiexec, or orterun.
-->

:::
::::::::::::::

\vspace{.5cm}

. . . 

- To manually compile the hello world program, you would use the following command:

    ```{.bash style=bashstyle}
    $ mpic++ -DHAVE_MPI hello.cpp -o hello_world
    ```

- To run the compiled MPI program
    
    ```{.bash style=bashstyle}
    $ mpirun -np 2 ./hello_world
    Hello World from rank 1
    Hello World from rank 0
    ```
<!--
  Augments the real compiler with additional arguments.
Automatically includes necessary paths and libraries.
-->

## UNDERSTANDING THE MPI COMPILER WRAPPER  

<!--

  Remember that the compiler wrapper is a thin layer around the compiler used to build the
MPI library. Under the hood, it will call the same compiler and augment it with additional
arguments, such as include paths and libraries, needed to successfully build a parallel
program.


the Message Passing Interface (MPI), which has become the de facto standard for
modeling a program executing in parallel on a distributed memory system. 
The implementation of the MPI standard consists of the following:
1. Runtime libraries.
2. Header files and Fortran 90 modules.
3. Compiler wrappers, which invoke the compiler that was used to build the MPI
library with additional command-line arguments to take care of include
directories and libraries. Usually, the available compiler wrappers are
mpic++/mpiCC/mpicxx for C++, mpicc for C, and mpifort for Fortran.
1. MPI launcher: This is the program you should call to launch a parallel execution
of your compiled code. Its name is implementation-dependent and it is usually
one of the following: mpirun, mpiexec, or orterun.

-->

\vspace{.5cm}

- The compiler wrapper is just a thin layer over the underlying compiler that automatically adds necessary arguments, such as include paths and libraries, for building parallel MPI programs.
    
    ```{.bash style=bashstyle}
    $ mpic++ --showme
    g++ -I<...>/openmpi/4.1.6/gcc--12.2.0/include -pthread 
    -L<...>/openmpi/4.1.6/gcc--12.2.0/lib -Wl,-rpath -Wl, -lmpi
    ```
\vspace{1cm}

. . . 

\begin{curiositybox}
Although one could simply pass the MPI compiler wrapper (e.g., \texttt{mpic++}) directly as the \texttt{CMAKE\_CXX\_COMPILER}, it's often more robust to handle MPI logic explicitly within the \texttt{CMakeLists.txt}...
\end{curiositybox}

## HOW TO DO IT - DETECTING MPI IN CMAKE

\vspace{.3cm}

:::::::::::::: {.columns}
::: {.column width="70%"}

1. First, we define the minimum CMake version, project name, supported language,
and language standard and optionally enable MPI:

    ```{.cmake style=cmakestyle}
    cmake_minimum_required(VERSION 3.21)
    project(HelloWorldMPI LANGUAGES CXX)

    option(TPL_ENABLE_MPI "Enable MPI" OFF)
    ```


2. We then conditionally call `find_package()` to locate the MPI implementation:
  
    ```{.cmake style=cmakestyle}
    if(TPL_ENABLE_MPI)
      find_package(MPI REQUIRED)
    endif()
    ```
<!--
  The REQUIRED keyword enforce dependencies dependencies to be satisfied:
  CMake will abort configuration if no MPI implementation has been found
  on the host system. If absent and the package is not found it will silently 
  skip
-->

:::
::: {.column width="30%"}


\vspace{2cm}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [helloWorldMPI
      [\colorbox{pink}{CMakeLists.txt}, file]
      [hello.cpp, file
      ]
    ]
  ]
\end{forest}

:::
::::::::::::::


## HOW TO DO IT - LINKING AGAINST MPI

\vspace{.5cm}

3. We define the executable name, source and then conditionally **link against the imported target** and **pass the compile definition**:

:::::::::::::: {.columns}
::: {.column width="70%"}

  ```{.cmake style=cmakestyle}
  add_executable(hello hello.cpp)

  if(MPI_FOUND)
    target_link_libraries(
        hello
        PRIVATE
            MPI::MPI_CXX)
    target_compile_definitions(
        hello
        PRIVATE
            HAVE_MPI)
  endif()
  ```
<!--
    **Note**: You could also leave it as PRIVATE since we will not be linking against the executable anyhow
-->

:::
::: {.column width="30%"}


\vspace{1cm}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [helloWorldMPI
      [\colorbox{pink}{CMakeLists.txt}, file]
      [hello.cpp, file
      ]
    ]
  ]
\end{forest}

:::
::::::::::::::


## HOW TO DO IT - GENERATE

4. (G100) Let us configure and generate the project files:

  ```{.bash style=bashstyle}
  $ module load openmpi/4.1.1--gcc--10.2.0-cuda-11.5.0
  
  $ cmake -B ./build -S <>/helloWorldMPI @-DTPL_ENABLE_MPI=ON@
  -- The CXX compiler identification is GNU 8.4.1
  ...
  -- Detecting CXX compile features - done
  -- @Found MPI_CXX: <>/openmpi-4.1.1-<>/lib/libmpi.so@  
  -- @Found MPI: TRUE (found version "3.1")@  
  -- Configuring done (1.6s)
  -- Generating done (0.0s)
  -- Build files have been written to: <>/build
  ```

## HOW TO DO IT - BUILD AND RUN

5. Let us invoke the build
```{.bash style=bashstyle}
$ cmake --build ./build -v 
...
[ 50%] Building CXX object CMakeFiles/hello.dir/hello.cpp.o
/usr/bin/c++ @-DHAVE_MPI@ @-isystem <>/openmpi-<>/include@ -std=c++11 
  ... -o CMakeFiles/hello.dir/hello.cpp.o -c <>/hello.cpp
[100%] Linking CXX executable hello
...
/usr/bin/c++ CMakeFiles/hello.dir/hello.cpp.o -o hello
  ... @<>/openmpi-4.1.1-<>/lib/libmpi.so@ 
```

6. To execute this program in parallel, we use the mpirun launcher 

```{.bash style=bashstyle}
$ mpirun -np 2 ./build/hello
Hello World from rank 1
Hello World from rank 0
```


## HOW IT WORKS (I)

\vspace{.3cm}

:::::::::::::: {.columns}
::: {.column width="50%"}

We have found linking to MPI to be extremely compact. We did not have to worry about compile flags, include directories, ...
```{.cmake style=cmakestyle}
target_link_libraries(
    hello_world
    PRIVATE
        MPI::MPI_CXX)
```

. . . 

:::
::: {.column width="50%"}


... these settings and dependencies are encoded in the definition of the `IMPORTED` target `MPI::MPI_CXX`.


```{.cmake style=cmakestyle}
include(CMakePrintHelpers)
cmake_print_properties(
    TARGETS
        MPI::MPI_CXX
    PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES
        INTERFACE_LINK_LIBRARIES)
```


<!--
  Note that all properties of interest have the prefix INTERFACE_, because these properties
  usage requirements for any target wanting to interface and use the OpenMP target.
-->

:::
::::::::::::::

. . . 

```{.bash style=bashstyle}
$ cmake -B ./build -S helloWorldMPI
MPI::MPI_CXX.INTERFACE_INCLUDE_DIRECTORIES = "<>/openmpi/include"
MPI::MPI_CXX.INTERFACE_LINK_LIBRARIES = "<>/openmpi/lib/libmpi.so"
```

. . . 

\centering But where was this target `MPI::MPI_CXX` defined?


## HOW IT WORKS (II)

\vspace{.3cm}

- CMake has a rather extensive set of **Modules** to detect commonly used libraries and programs

  ```{.bash style=bashstyle}
  $ ls $CMAKE_PREFIX_PATH/share/cmake-3.21/Modules/ | grep "Find"
  @FindMPI.cmake@
  FindOpenMP.cmake
  FindPythonInterp.cmake
  FindCUDAToolkit.cmake
  ...
  ```

- `find_package(<package_name>)` is a wrapper command that looks for a file named `Find<package_name>.cmake` in the CMake cache variable `CMAKE_MODULE_PATH`
- These CMake scripts identify packages in standard locations on the system, define variables and **imported targets** that will be run internally when a call to `find_package()` is issued


## FindMPI.cmake

\vspace{.5cm}

:::::::::::::: {.columns}
::: {.column width="65%"}

```{.cmake style=cmakestyle}
#FindMPI.cmake
# . . . Documentation . . .
# CMake code to locate mpi_exec ...
# CMake code to find compiler wrappers ...
# . . . 
# For C/C++ look for mpi.h.
if(LANG MATCHES "^(C|CXX)$")
    find_path(MPI_${LANG}_HEADER_DIR "mpi.h"
      HINTS
        ${MPI_${LANG}_COMPILER_INCLUDE_DIRS}
        ${MPI_${LANG}_ADDITIONAL_INCLUDE_DIRS})
# . . . 
add_library(MPI::MPI_${LANG} INTERFACE IMPORTED)
set_property(TARGET MPI::MPI_${LANG} 
  PROPERTY 
    INTERFACE_INCLUDE_DIRECTORIES 
      "${MPI_${LANG}_INCLUDE_DIRS}")
# seting other properties: link libraries, ...
```

:::
::: {.column width="35%"}

\vspace{.5cm}

`FindMPI.cmake` defines imported targets for MPI components to facilitate their usage in other projects.

\vspace{1cm}

**IMPORTED** libraries are pseudotargets that fully encode usage requirements for dependencies outside our own project. 

<!--
  When you create an imported target, you're telling CMake: I have this { static library | shared library | module library | executable } already built in this location on disk. I want to be able to treat it just like a target built by my own buildsystem, so take note that when I say ImportedTargetName, it should refer to that binary on disk (with the associated import lib if applicable, and so on).

  When you create an interface library, you're telling CMake: I have this set of properties (include directories etc.) which clients can use, so if they "link" to my interface library, please propagate these properties to them.

  The fundamental difference is that interface libraries are not backed by anything on disk, they're just a set of requirements/properties. You can set the INTERFACE_LINK_LIBRARIES property on an interface library if you really want to, but that's not really what they were designed for. They're to encapsulate client-consumable properties, and make sense primarily for things like header-only libraries in C++.

  To use MPI one needs to set compiler flags, include directories, and link libraries. 
  All of these are set as properties on the MPI::MPI_CXX pseudotarget and transitively 
  applied to our example target simply by using the target_link_libraries command. 
  This makes using libraries within our CMake scripts exceedingly easy.
-->

<!-- 

  Benefits of imported targets

  Modularity: Allows MPI settings to be encapsulated in pseudo targets that can be easily consumed by other projects.
  Simplified Integration: Projects can link against MPI::MPI_<lang> to automatically use the correct MPI settings.
  Consistency: Ensures that all necessary compile options, definitions, include directories, 
  and link libraries are correctly applied.
-->

:::
::::::::::::::


## Using find_package

<!-- 
  When attempting dependency detection with `find_package()`, you should make sure that:

  A `Find<PackageName>.cmake` module exists, which components, if any, it provides, and what imported targets it will set up.

  A complete list of Find<PackageName>.cmake can be found from the command-line interface:
-->

\vspace{.3cm}

1. Ensure a `Find<PackageName>.cmake` module exists.

  ```{.bash style=bashstyle}
  $ cmake --help-module-list | grep Find<PackageName>
  ```

2. Consult builtin documentation to identify provided imported targets, useful variables... <!-- that you can use in your CMakeLists.txt  -->

  ```{.bash style=bashstyle}
  $ cmake --help-module FindMPI
  FindMPI
  -------
  Find a Message Passing Interface (MPI) implementation.

  Variables for using MPI
  ^^^^^^^^^^^^^^^^^^^^^^^
  The module exposes components ``C``, ``CXX``, ``Fortran`` ...

  ``MPI_FOUND``
  . . . <some other output>
  ```

## {.standout}

No CMake Module? No Problem!

## CONFIG MODE

\vspace{.3cm}

- When a `Find<PackageName>.cmake` module doesn't exist, the `find_package()` command will automatically try to locate a `<PackageName>Config.cmake`, `<PackageName>ConfigVersion.cmake` provided by the package itself.


<!-- 

  Searches for configuration files in the standard package installation directory.
  More versatile than the Find<PackageName>.cmake approach.
  Supports packages with native CMake support.
  Advantages of Config Mode
  Directly uses the package's configuration files.
  Ensures compatibility with the package's installation.
  Avoids the need for custom Find<PackageName>.cmake modules.
-->

. . . 

\vspace{.3cm}

**Example. Recent FFTW releases ship with CMake configuration files:**

:::::::::::::: {.columns}
::: {.column width="50%"}

```{.bash style=bashstyle}
$ ls <>/fftw-/lib/cmake/fftw3/
FFTW3Config.cmake  
FFTW3ConfigVersion.cmake 
FFTW3LibraryDepends.cmake 
FFTW3fConfig.cmake 
FFTW3fConfigVersion.cmake
```

:::
::: {.column width="50%"}

```{.cmake style=cmakestyle}
# FFTW3LibraryDepends.cmake
# . . .
add_library(FFTW3::fftw3 SHARED
                        IMPORTED)

set_target_properties(FFTW3::fftw3 
  PROPERTIES
    INTERFACE_LINK_LIBRARIES "m")
# set_properties ...
```
:::
::::::::::::::



<!--

There are two main ways packages are defined in CMake, either as a module or through config
details. Config details are usually provided as part of the package itself, and they are more closely
aligned with the functionality of the various find_…() commands discussed in the preceding
sections. Modules, on the other hand, are typically defined by something unrelated to the package,
usually by CMake or by projects themselves. As a result, modules are harder to keep up to date as
the package evolves over time.
Module and config files typically define variables and imported targets for the package. These may
provide the location of programs, libraries, flags to be used by consuming targets and so on.
Functions and macros can also be defined. There is no set of requirements for what will be
provided, but there are some conventions which are stated in the CMake developer manual. Project
authors must consult the documentation of each module or package to understand what is
provided. As a general guide, older modules tend to provide variables that follow a fairly consistent
pattern, whereas newer modules and config implementations usually define imported targets.
Where both variables and imported targets are provided, projects should prefer the latter due to
their superior robustness and better integration with CMake’s transitive dependency features.

## RECAP

\centering Projects often depend on other projects and libraries. 

\vspace{.5cm}

In CMake there are two main ways packages are defined and subsequently found:

  CMake provides two main mechanisms to detect and link these dependencies.

\vspace{.5cm}

:::::::::::::: {.columns}
::: {.column width="50%"}

1. **Module Packages**

- Defined by CMake or individual projects.
- Typically provide variables, macros, functions, and imported targets.
- Example: `FindMPI.cmake`

::: 
::: {.column width="50%"}

2. **Config Packages**

- Provided as part of the package itself.
- Tend to define imported targets.
- Example: `<Package>Config.cmake`

:::
::::::::::::::

## Finding Packages in CMake

In CMake there are two ways for searching packages

- **Modules** 
- **CMake package configurations** 
- **PkgConfig**
- **Write your own Find<package>.cmake module**

but both of them use the same inferface `find_package()`

  Part V: Deployment And
  Dependencies
  For the lucky few, a project may be independent of anything else, having no reliance on any
  externally provided content. The more likely scenario is that, at some point, the project needs to
  move beyond its own isolated existence and interact with external entities. This occurs in two
  directions:
  Dependencies
  The project may depend on other externally provided files, libraries, executables, packages, and
  so on.
  Consumers
  Other projects or users may wish to consume the project in a variety of ways. Some may want to
  incorporate the project at the source level, others may expect a pre-built binary package to be
  available. Another possibility is the assumption that the project is installed somewhere on the
  system. End users might just be installing the project to run it, not to build with it.

  For dependencies, it provides
  commands that operate at both the package level and at a lower level for finding individual files,
  libraries, etc. CMake also provides features that give a higher level entry point for dependency
  management. To support consumers, installation and package creation features are available.
  Packages can be created in a range of common formats.

  A project of at least modest size will likely rely on things provided by something outside the project
  itself. For example, it may expect a particular library or tool to be available, or it may need to know
  the location of a specific configuration or header file for a library it uses. At a higher level, the
  project may want to find a complete package that potentially defines a range of things including
  targets, functions, variables and anything else a regular CMake project might define.

  CMake provides a variety of features which enable projects to find things and to be found by or
  incorporated into other projects. Various find_…() commands provide the ability to search for
  specific files, libraries or programs, or indeed for an entire package. CMake modules also add the
  ability to use pkg-config to provide information about external packages, while other modules
  facilitate writing package files for other projects to consume. This chapter covers CMake’s support
  for searching for something already available on the file system.

  The basic idea of searching for something is relatively straightforward, but the details of how the
  search is conducted can be quite involved. In many cases, the default behaviors are appropriate,
  but an understanding of the search locations and their ordering can allow projects to tailor the
  search to account for non-standard behaviors and unusual circumstances.


The various find_…() commands discussed in the preceding sections all focus on finding one
specific item. Quite often, however, these items are just one part of a larger package. The package
as a whole may have its own characteristics that projects could be interested in, such as a version
number, or support for certain features. Projects will generally want to find the package as a single
unit rather than piece together its different parts manually.
-->


<!-- 


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

-->



<!-- 


## There is more

## WHERE DOES CMAKE LOOK FOR CONFIG MODULES?

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


- The `REQUIRED` keyword causes a missing package to fail the configure step
  
- Looks for a file named `find<package_name>.cmake` in the CMake cache variable `CMAKE_MODULE_PATH`
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
