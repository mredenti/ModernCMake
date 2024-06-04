---
aspectratio: 169
---



# ADVANCED TOPICS

## CMAKE FEATURES 

\vspace{.3cm}

:::::::::::::: {.columns}
::: {.column width="50%"}

**Finding Packages**

\vspace{0.2cm}

**Multiple Generators**

- Makefiles 
- Ninja
- Microsoft Visual Studio (.sln)
- Eclipse
- Xcode

\vspace{0.2cm}

**Cross-platform** (Linux, Windows, macOS, ...)

\vspace{0.2cm}

**Direct CMake integration with IDEs** 

  - Microsoft Visual Studio 2017...
  - JetBrains CLion


:::

. . . 

::: {.column width="50%"}


**Dependency discovery made easy**

- `find_package()`

\vspace{0.2cm}

**Automatic chaining of library dependency information**

\vspace{0.2cm}


**Compiler language level support**

- C, C++, Fortran, CUDA, HIP, ...

\vspace{0.2cm}

**Fortran Module Order**  

\vspace{0.2cm}

**Test frameworks integration**

- Catch2, GoogleTest

\vspace{0.2cm}

**CMake scripting language**
<!-- 

  CMake as a Scripting Language
  CMake is a tool designed to manage the build process of software projects. It uses a scripting language to define the build process in CMakeLists.txt files. Here’s how it fits the characteristics of a scripting language:

  Interpreted Execution: CMake processes the CMakeLists.txt files line by line to generate build instructions (e.g., Makefiles or Visual Studio project files).
  
  Automatic ordering of Fortran files based on `use` statements in the code for a library

  CMake is an open-source project that serves as a tool for building, testing, packaging, and distributing cross-platform software
    CMake is a scripting language written in C++
    CMake is a de facto industry standard for building C++ projects
    CMake is divided into 3 command-line tools:
    cmake: for generating compiler-independent build instruction
    ctest: for detecting and running tests
    cpack: for packing the software project into convenient installers

    Compiler indipendent configuration files (need example)

Uses CMake language

- Automatic dependency generation 
- 
- **Single description file** generate builds for many build systems and platforms from one description file 
  
- **Integration** easy to build end-to-end build systems using CTest and CPack
- It's platform- and - compiler-agnostic, allowing reuse of CMake scripts across different platforms.
- facilitate generation of files for different build systems across various platforms and IDEs
- automatically track and propagate internal dependencies
- Graphviz output for visualizing dependency trees
- Full cross platform install() system
- Compute link depend information, and chaining of dependent libraries

Discussion on how CMake fits into the software development process, its role in streamlining development, testing, deployment, and complex use cases like large-scale projects and cross-platform development.

-->

:::
::::::::::::::
  



## RESOURCES

BOOOKS 

FORUMS 

BUILT IN DOCUMENTATION



<!-- 

## PKGCONFIG 

\vspace{.3cm}

- If neither a `Find<PackageName>.cmake` module nor a `<PackageName>Config.cmake` is available, CMake can also use `pkg-config` to find and configure packages. put link

\vspace{.3cm}

**Example. Using `pkg-config` with FFTW**

:::::::::::::: {.columns}
::: {.column width="50%"}

```{.bash style=bashstyle}
$ ls <>/fftw-/lib/pkgconfig
fftw3f.pc  fftw3.pc
```

:::
::: {.column width="50%"}

```{.bash style=bashstyle}
$ cat <>/fftw3.pc
prefix=<path-to-root-fftw>
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Version: 3.3.10
Libs: -L${libdir} -lfftw3 
Libs.private: -lm
Cflags: -I${includedir}
```
:::
::::::::::::::


## WRITE YOUR OWN DETECTION SCRIPT

- CMake provides extensive modules for finding many popular software packages. Before writing your own detection scripts, always check the CMake online documentation for existing `Find<PackageName>.cmake` modules.


  to enable the discovery of files, programs, libraries...


- At times writing your own detection scripts might be the only option. CMake provides a family of `find_*()` commands for this purpose:
  
  **find_path()** 
    : to find a directory containing the named file

  **find_file()**
    : to find a full path to a named file

  **find_library()**
    : to find a library

  **find_program()** 
    : to find a program


  IMPORTANT AND INTERESTING

  For a large selection of common dependencies, the Find<PackageName>.cmake modules shipped with CMake work flawlessly and are maintained by the CMake developers. This lifts the burden of programming your own dependency detection tricks.

  find_package will set up imported targets: targets defined outside your project that you can use with your own targets. The properties on imported targets defines usage requirements for the dependencies. A command such as:

  target_link_libraries(your-target
    PUBLIC
      imported-target
    )
  will set compiler flags, definitions, include directories, and link libraries from imported-target to your-target and to all other targets in your project that will use your-target.

  These two points simplify enormously the burden of dependency detection and consistent usage within a multi-folder project.

## WRITING A FindFFTW3.cmake (I)

:::::::::::::: {.columns}
::: {.column width="85%"}

1. Check for FFTW environment variables and set them if not already defined.

```{.cmake style=cmakestyle}
if(NOT FFTW_HOME AND DEFINED ENV{FFTW_HOME} )
    set(FFTW_ROOT $ENV{FFTW_HOME} )
endif()

if(NOT FFTW_ROOT AND DEFINED ENV{FFTW_ROOT} )
    set(FFTW_ROOT $ENV{FFTW_ROOT} )
endif()
```

2. Use `find_path()` to locate the directory containing the `fftw3.h` header file.
   
```{.cmake style=cmakestyle}
find_path( 
    FFTW_INCLUDE_DIR 
    NAMES fftw3.h
    PATHS 
        ${FFTW_ROOT}/include
        /usr/local/include
        /usr/include
    DOC "Path to FFTW include directory")
```

:::
::: {.column width="15%"}

\vspace{2.5cm}

\begin{adjustbox}{margin=-1cm 0cm 0cm 0cm}
\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [\colorbox{pink}{FindFFTW3.cmake}, file
    ]
  ]
\end{forest}
\end{adjustbox}

:::
::::::::::::::


## WRITING A FindFFTW3.cmake (II)

\vspace{0.2cm}

:::::::::::::: {.columns}
::: {.column width="85%"}

3. Locate the FFTW library file.

```{.cmake style=cmakestyle}
find_library( 
    FFTW_LIBRARY 
    NAMES fftw3
    PATHS ${FFTW_ROOT}
    PATH_SUFFIXES "lib" "lib64" 
    DOC "Path to FFTW library")
```

4. Include the `FindPackageHandleStandardArgs` module and use `find_package_handle_standard_args()` to validate the found paths.
   
```{.cmake style=cmakestyle}
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  FFTW
  FOUND_VAR 
    FFTW_FOUND
  REQUIRED_VARS 
    FFTW_LIBRARY FFTW_INCLUDE_DIR)
```

:::
::: {.column width="15%"}

\vspace{2.5cm}


\begin{adjustbox}{margin=-1cm 0cm 0cm 0cm}
\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [\colorbox{pink}{FindFFTW3.cmake}, file
    ]
  ]
\end{forest}
\end{adjustbox}

:::
::::::::::::::

## WRITING A FindFFTW3.cmake (III)

\vspace{0.2cm}

:::::::::::::: {.columns}
::: {.column width="85%"}

4. Set the `FFTW_LIBRARIES` and `FFTW_INCLUDE_DIRS` if FFTW is found.

```{.cmake style=cmakestyle}
if(FFTW_FOUND)
  set(FFTW_LIBRARIES ${FFTW_LIBRARY})
  set(FFTW_INCLUDE_DIRS ${FFTW_INCLUDE_DIR})
endif()
```

5. Create an imported target for FFTW using `add_library()` and set the appropriate properties.
   
```{.cmake style=cmakestyle}
if(FFTW_FOUND AND NOT TARGET FFTW3::fftw3)
  add_library(FFTW3::fftw3 UNKNOWN IMPORTED)
  set_target_properties(FFTW3::fftw3 PROPERTIES
    IMPORTED_LOCATION "${FFTW_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${FFTW_INCLUDE_DIR}")
endif()

set_target_properties(FFTW3::fftw3 PROPERTIES
  INTERFACE_LINK_LIBRARIES "m")
```

:::
::: {.column width="15%"}

\vspace{2.5cm}


\begin{adjustbox}{margin=-1cm 0cm 0cm 0cm}
\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [\colorbox{pink}{FindFFTW3.cmake}, file
    ]
  ]
\end{forest}
\end{adjustbox}

:::
::::::::::::::

## RECAP 

\vspace{.3cm}

In CMake, packages are defined and found in two primary ways:

**Module Packages**: Defined by CMake or individual projects, typically providing variables, macros, functions, and imported targets. Example: FindMPI.cmake.

**Config Packages**: Provided by the package itself, usually defining imported targets. Example: <Package>Config.cmake.

\vspace{.2cm}

Modules: Defined by CMake or projects, harder to keep up to date as packages evolve.

Config: Provided by the package itself, closely aligned with CMake's find commands, ensuring compatibility and ease of use.
Projects should prefer imported targets due to their robustness and better integration with CMake’s transitive dependency features.


## INTEGRATION WITH TEST FRAMEWORKS

we do not discuss here ...


## USING TIMEOUTS FOR LONG TESTS

- Ideally tests should take only a short time in order to motivate the developers to run the test often, and to encourage testing every commit. 

- At times, tests might take longer or get stuck (eg. high file I/O load) and we may need to implement timeouts to termitate tests that go overtime before they pile up and delay the entire terst and deploy pipeline.

- Implementing timeouts can be achieved with properties too...


[CMake Properties On Tests - Documentation](https://cmake.org/cmake/help/v3.19/manual/cmake-properties.7.html#properties-on-tests)

## VALGRIND EXAMPLE SOMEWHERE

lkl


## Using timeouts for long tests

The code for this recipe is available at https:/ / github. com/ dev- cafe/
cmake- cookbook/ tree/ v1. 0/ chapter- 04/ recipe- 07. The recipe is valid
with CMake version 3.5 (and higher), and has been tested on GNU/Linux,
macOS, and Windows.
Ideally, the test set should take only a short time, in order to motivate developers to run the
test set often, and to make it possible (or easier) to test every commit (changeset). However,
some tests might take longer or get stuck (for instance, due to a high file I/O load), and we
may need to implement timeouts to terminate tests that go overtime, before they pile up
and delay the entire test and deploy pipeline. In this recipe, we will demonstrate one way
of implementing timeouts, which can be adjusted separately for each test.

In addition, we specify a TIMEOUT for the test, and set it to 10 seconds:
set_tests_properties(example PROPERTIES TIMEOUT 10)

Now, to verify that the TIMEOUT works, we increase the sleep command in
test.py to 11 seconds, and rerun the test:

## RUNNING TESTS IN PARALLEL

Most modern computers have four or more CPU cores. One fantastic feature of CTest is its
ability to run tests in parallel, if you have more than one core available. This can
significantly reduce the total time to test, and reducing the total test time is what really
counts, to motivate developers to test frequently. In this recipe, we will demonstrate this
feature and discuss how you can optimize the definition of your tests for maximum
performance.

## RUNNING A SUBSET OF THE TESTS 

In the previous recipe, we learned how to run tests in parallel with the help of CMake, and
we discussed that it is advantageous to start with the longest tests. While this strategy
minimizes the total test time, during the code development of a particular feature, or
during debugging, we may not wish to run the entire test set. We may prefer to start with
the longest tests, especially while debugging functionality that is exercised by a short test.
For debugging and code development, we need the ability to only run a selected subset of
tests. In this recipe, we will present strategies to accomplish that.


## INTEGRATED SUPPORT FOR TESTING FRAMEWORKS AND STATIC CODE ANALYSIS

- Support is also provided for the popular GoogleTest framework

- While GoogleTest can be used standalone, CTest can drive the tests defined with the GoogleTest framework, taking over how tests are scheduled to run and the environment they run in.

List of testing frameworks:
  - fdfd
  - fdfd

- CMake also has direct support for a number of popular static code analysis tools

  - clang-tidy
  - cppcheck
  - include-what-you-use 

The above complement tests by providing additional verification of the code quality, adherence to relevant standards and catching common programming models.
Dynamic code analysis is also possible with CMake projects.

## CTEST 

- The CTest is the testing tool used to control how tests execute

- By default, `ctest` will execute all defined tests one at a time, logging a status message as each test is started and completed, but hiding all test output. An overall summary of the tests will be printed at the end.

- Rich features are provided for defining how tests use resources, constraints between tests, and controlling how
tests execute.

- Reporting options include support for a dedicated dashboard server (CDash) or file ouptput in the widely used JUnit XML format.

# The CTest command-line interface

## CTEST 

show a couple of things with the CTest command line interface

-->