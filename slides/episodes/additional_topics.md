---
aspectratio: 169
---


## A LIST 

of additional topics


## RESOURCES

BOOOKS 

FORUMS 

BUILT IN DOCUMENTATION


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

<!--
  to enable the discovery of files, programs, libraries...
--> 

- At times writing your own detection scripts might be the only option. CMake provides a family of `find_*()` commands for this purpose:
  
  **find_path()** 
    : to find a directory containing the named file

  **find_file()**
    : to find a full path to a named file

  **find_library()**
    : to find a library

  **find_program()** 
    : to find a program

<!-- 
  IMPORTANT AND INTERESTING

  For a large selection of common dependencies, the Find<PackageName>.cmake modules shipped with CMake work flawlessly and are maintained by the CMake developers. This lifts the burden of programming your own dependency detection tricks.

  find_package will set up imported targets: targets defined outside your project that you can use with your own targets. The properties on imported targets defines usage requirements for the dependencies. A command such as:

  target_link_libraries(your-target
    PUBLIC
      imported-target
    )
  will set compiler flags, definitions, include directories, and link libraries from imported-target to your-target and to all other targets in your project that will use your-target.

  These two points simplify enormously the burden of dependency detection and consistent usage within a multi-folder project.
-->

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
