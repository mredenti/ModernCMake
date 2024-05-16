---
aspectratio: 169
---


# CREATING A LIBRARY / BUILDING AND LINKING STATIC AND SHARED LIBRARIES

## NOTES

You might also want to mention that they can add all sources to the executable alternatively...

The upcoming example is on chapter-01/recipe-03

<!--
  Only rarely we have one-source-file projects and more realistically, as projects grow, we split them up into separate files. This simplifies (re)compilation but also helps humans maintaining and understanding the project.

  A project almost always consists of more than a single executable built from a single source file. Projects are split across multiple source files, often spread across different subdirectories in the source tree. This practice not only helps in keeping source code organized within a project, but greatly favors modularity, code reuse, and separation of concerns, since common tasks can be grouped into libraries. This separation also simplifies and speeds up recompilation of a project during development. In this recipe, we will show
  how to group sources into libraries and how to link targets against these libraries.
-->

## A GREETINGS LIBRARY

:::::::::::::: {.columns}
::: {.column width="65%"}

```c++
// HelloWorld/src/greetings/greetings.h
#ifndef GREETINGS_H
#define GREETINGS_H

namespace greetings {

  void say_hello();
  
  void say_goodbye();
}

#endif // GREETINGS_H
```

::: 
::: {.column width="35%"}

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
    ]
  ]
\end{forest}

::: 
::::::::::::::


## A GREETINGS LIBRARY

:::::::::::::: {.columns}
::: {.column width="65%"}

```c++
// HelloWorld/src/greetings/greetings.cpp
#include <iostream>
#include "greetings.h"

namespace greetings {
  
  void say_hello() {
    std::cout << "Hello, World!" << std::endl;
  }

  void say_goodbye() {
    std::cout << "Goodbye, World!" << std::endl;
  }
}
```

::: 
::: {.column width="35%"}

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
    ]
  ]
\end{forest}

::: 
::::::::::::::

## A GREETING LIBRARY

:::::::::::::: {.columns}
::: {.column width="65%"}

```c++
#include <cstdlib>
#include "greetings/greetings.h"

int main() {

  greetings::say_hello();

  greetings::say_goodbye();

  return EXIT_SUCCESS;
}
```


::: 
::: {.column width="35%"}

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
    ]
  ]
\end{forest}

::: 
::::::::::::::

## IMPORTANT POINT

We will encounter the term target repeatedly. In CMake, a target is any object given as first argument to add_executable or add_library. Targets are the basic atom in CMake. Whenever you will need to organize complex projects, think in terms of its targets and their mutual dependencies. The whole family of CMake commands target_* can be used to express chains of dependencies and is much more effective than keeping track of state with variables. 

## CREATING A LIBRARY - HOW TO DO IT 

<!-- 
  These two new files will also have to be compiled and we have to modify CMakeLists.txt accordingly. However, in this example we want to compile them first into a library, and not directly into the executable
-->

1. Create a new **target**, this time a static library. The name of the library will be name of the target and the sources are listed as follows

    ```{.cmake style=cmakestyle}
    add_library(greetings STATIC Greetings.hpp Greetings.cpp) 
    ```
. . . 

2. The creation of the **target** for the `hello_world` executable is unmodified

    ```{.cmake style=cmakestyle}
    add_executable(hello_world hello.cpp) 
    ```

. . .

3. Finally we have to tell CMake that the `greetings` library target has to be linked into the executable target

    ```{.cmake style=cmakestyle}
    target_link_libraries(hello-world greetings)
    ```

## CONFIGURE AND BUILD

4. We can configure and build with the same commands as before 
    
    ```{.bash style=bashstyle}
    $ cmake -B ./build -S ./hello-world/
    $ cmake --build ./build --target help
    $ cmake --build ./build 
    Scanning dependencies of target message
    [ 25%] Building CXX object CMakeFiles/message.dir/Message.cpp.o
    [ 50%] Linking CXX static library libmessage.a
    [ 50%] Built target message
    Scanning dependencies of target hello-world
    [ 75%] Building CXX object CMakeFiles/hello-world.dir/helloworld.
    cpp.o
    [100%] Linking CXX executable hello-world
    [100%] Built target hello-world
    ```

## BUILD .. 

dfd

## RUN 

5. Run 

    ```{.bash style=bashstyle}
    ./build/hello_world
    ```


## CREATING A LIBRARY - HOW IT WORKS

```{.cmake style=cmakestyle}
add_library(greetings STATIC Greetings.hpp Greetings.cpp) 
```

- Generates the necessary build instructions for compiling the specified sources, `Greetings.cpp`, into a static library

- The name of the target, `greetings`, can be used troughout `CMakeLists.txt` to refer to the library

- The actual name of the generated library will be formed by CMake by adding the prefix `lib` in front and the appropriate extension as a suffix.
    
    ```{.bash style=bashstyle}
    $ cmake --build ./build --target greetings
    ... libgreetings.a
    ```

  The library extension is determined based on the second argument, STATIC or SHARED, and the OS.


## LINKING A LIBRARY - HOW IT WORKS

```{.cmake style=cmakestyle}
target_link_libraries(hello-world greetings)
```

- Links the library into the executable. 
  
    ```{.bash style=bashstyle}
    $ cmake --build ./build --target greetings
    ... libgreetings.a
    ```

. . .

- Guarantees that the `hello-world` executable properly depends on the message library $\Rightarrow$ greetings library is always built before being linked it to the hello-world executable

    ```{.bash style=bashstyle}
    $ cmake --build ./build --target greetings
    ... libgreetings.a
    ```

After successful compilation, the build directory will contain the libmessage.a static
library (on GNU/Linux) and the hello-world executable

## STATIC, SHARED, OBJECT MODULE 

STATIC, which we have already encountered, will be used to create static
libraries, that is, archives of object files for use when linking other targets, such as
executables.
SHARED will be used to create shared libraries, that is, libraries that can be linked
dynamically and loaded at runtime. Switching from a static library to a dynamic
shared object (DSO) is as easy as using add_library(message SHARED
Message.hpp Message.cpp) in CMakeLists.txt.
OBJECT can be used to compile the sources in the list given to add_library to
object files, but then neither archiving them into a static library nor linking them
into a shared object. The use of object libraries is particularly useful if one needs
to create both static and shared libraries in one go. We will demonstrate this in
this recipe.
MODULE libraries are once again DSOs. In contrast to SHARED libraries, they are
not linked to any other target within the project, but may be loaded dynamically
later on. This is the argument to use when building a runtime plugin

## IMPORTED, INTERFACE, ALIAS

CMake is also able to generate special types of libraries. These produce no output in the
build system but are extremely helpful in organizing dependencies and build requirements
between targets:
IMPORTED, this type of library target represents a library located outside the
project. The main use for this type of library is to model pre-existing
dependencies of the project that are provided by upstream packages. As such
IMPORTED libraries are to be treated as immutable. We will show examples of
using IMPORTED libraries throughout the rest of the book. See also: https:/ /
cmake. org/ cmake/ help/ latest/ manual/ cmake- buildsystem. 7. html#importedtargets


INTERFACE, this special type of CMake library is similar to an IMPORTED library,
but is mutable and has no location. Its main use case is to model usage
requirements for a target that is outside our project. We will show a use case for
INTERFACE libraries in Recipe 5, Distributing a project with dependencies as Conda
package, in Chapter 11, Packaging Projects. See also: https:/ / cmake. org/ cmake/
help/ latest/ manual/ cmake- buildsystem. 7. html#interface- libraries
ALIAS, as the name suggests, a library of this type defines an alias for a preexisting
library target within the project. It is thus not possible to choose an alias
for an IMPORTED library. See also: https:/ / cmake. org/ cmake/ help/ latest/
manual/ cmake- buildsystem. 7. html#alias- libraries

## THINGS THAT NEED TO BE UNDERSTOOD 

- object libraries -- how to I access them when compiled, do I get a target for each object -- how do I create a object for each and then use them as a library

## ADD_LIBRARY()

- add_library(message STATIC Message.hpp Message.cpp): This will
generate the necessary build tool instructions for compiling the specified sources into a library.


- The first argument to add_library is the name of the target. The
same name can be used throughout CMakeLists.txt to refer to the library. The
actual name of the generated library will be formed by CMake by adding the
prefix lib in front and the appropriate extension as a suffix. The library
extension is determined based on the second argument, STATIC or SHARED, and
the operating system.

- target_link_libraries(hello-world message): Links the library into the
executable. This command will also guarantee that the hello-world executable
properly depends on the message library. We thus ensure that the message
library is always built before we attempt to link it to the hello-world
executable.

- After successful compilation, the build directory will contain the libmessage.a static
library (on GNU/Linux) and the hello-world executable.

## STATIC, SHARED, .

CMake accepts other values as valid for the second argument to add_library and we will
encounter all of them in the rest of the book:
STATIC, which we have already encountered, will be used to create static
libraries, that is, archives of object files for use when linking other targets, such as
executables.
SHARED will be used to create shared libraries, that is, libraries that can be linked
dynamically and loaded at runtime. Switching from a static library to a dynamic
shared object (DSO) is as easy as using add_library(message SHARED
Message.hpp Message.cpp) in CMakeLists.txt.
OBJECT can be used to compile the sources in the list given to add_library to
object files, but then neither archiving them into a static library nor linking them
into a shared object. The use of object libraries is particularly useful if one needs
to create both static and shared libraries in one go. We will demonstrate this in
this recipe.
MODULE libraries are once again DSOs. In contrast to SHARED libraries, they are
not linked to any other target within the project, but may be loaded dynamically
later on. This is the argument to use when building a runtime plugin.

## IMPORTED TARGETS 

CMake is also able to generate special types of libraries. These produce no output in the
build system but are extremely helpful in organizing dependencies and build requirements
between targets:
IMPORTED, this type of library target represents a library located outside the
project. The main use for this type of library is to model pre-existing
dependencies of the project that are provided by upstream packages. As such
IMPORTED libraries are to be treated as immutable. We will show examples of
using IMPORTED libraries throughout the rest of the book. See also: https:/ /
cmake. org/ cmake/ help/ latest/ manual/ cmake- buildsystem. 7. html#importedtargets

INTERFACE, this special type of CMake library is similar to an IMPORTED library,
but is mutable and has no location. Its main use case is to model usage
requirements for a target that is outside our project. We will show a use case for
INTERFACE libraries in Recipe 5, Distributing a project with dependencies as Conda
package, in Chapter 11, Packaging Projects. See also: https:/ / cmake. org/ cmake/
help/ latest/ manual/ cmake- buildsystem. 7. html#interface- libraries
ALIAS, as the name suggests, a library of this type defines an alias for a preexisting
library target within the project. It is thus not possible to choose an alias
for an IMPORTED library. See also: https:/ / cmake. org/ cmake/ help/ latest/
manual/ cmake- buildsystem. 7. html#alias- libraries

# Build Configurations

## Scope 

Targets are visible at any scope after the point that they have been defined. Regular (non-cache) variables are scoped to directories, functions, and block()s, and are only visible to script code in the same directory function, and block scope (same function scope, and same directory level, or subdirectories added by add_subdirectory). To define a variable in the parent directory's scope, you must define it like set(<variable> <value>... PARENT_SCOPE).

## Extra 

In the above example, note that .h header files were specified as sources too, not just the .cpp implementation files. Headers listed as sources don’t get compiled directly on their own, but the effect of adding them is for the benefit of IDE generators like Visual Studio, Xcode, Qt Creator, etc. This causes those headers to be listed in the project’s file list within the IDE, even if no source file refers to it via #include. This can make those headers easier to find during development and potentially aid things like refactoring functionality

## IMPORTANT POINT TO UNDERSTAND - add_subdirectory vs include 

If you need to support CMake 3.12 or older, you will need to either pull up any target_link_libraries() calls to the same directory as the target they operate on, or else use include() rather than add_subdirectory() to avoid introducing a new directory scope. Prefer the former where possible, since it is likely to be more intuitive for developers.

## Motivation 

Build configuration is a critical aspect of software development, particularly in the context of compiled languages such as C, C++, and Fortran. 

Effective build configuration is crucial for several reasons:

Performance: Properly optimized build configurations can significantly improve the performance of the final product.
Portability: Ensures that the software can be built and run on different platforms and environments.
Debugging and Testing: Different configurations can be tailored for more effective debugging and testing.
Reproducibility: Ensures that builds are consistent and reproducible, which is essential for collaborative development and for maintaining stable production environments.

Understanding and managing build configurations is a foundational skill in software engineering, particularly when dealing with complex systems or when targeting multiple platforms. It is about balancing the needs for development efficiency, performance, and maintainability of the codebase.

## Motivation II
Build Configuration often includes:

Compiler Settings:
Choice of Compiler: Determining which compiler (e.g., GCC, Clang, MSVC) is best suited for the project based on platform, performance needs, or specific feature requirements.
Compiler Options: Configuring compiler flags that affect optimization levels, debugging information, and more.
Build Types:
Development Builds: Often have debugging enabled (more verbose logging, no optimization) to facilitate easier tracing of errors and bugs.
Release Builds: Optimized for performance and may include additional changes like disabling logging or assertions to enhance speed and reduce binary size.
Other specialized builds like Test builds (which might include instrumentation for better testing coverage) or Profile builds (used for performance analysis).
Linker Settings:
Static vs. Dynamic Linking: Deciding whether libraries used in the project should be linked statically or dynamically.
Linker Flags: Customizing how the linker behaves, which can affect the final executable's performance and size.
Platform-Specific Configurations:
Tailoring the build process to different operating systems (Linux, Windows, macOS) or even specific versions or distributions of these OSes.
Configuring builds for different hardware architectures (x86, ARM, etc.).
Optimization Settings:
Setting compiler flags that control optimization levels, such as -O2 or -O3 for GCC and Clang, or /O2 for MSVC.
Other optimizations like link time code generation (LTCG) or profile-guided optimizations (PGO).
Environment Variables:
Using environment variables to influence the build process, such as PATH, LD_LIBRARY_PATH, or specific toolchain variables like CC and CXX for defining the C and C++ compilers, respectively.



## Specifying the compiler

<!--

  CMake is aware of the environment and many options can either be
  set via the -D switch of its CLI or via an environment variable. The former
  mechanism overrides the latter, but we suggest to always set options
  explicitly with -D. Explicit is better than implicit, since environment
  variables might be set to values that are not suitable for the project at
  hand.

  We recommend to set the compilers using the -D
  CMAKE_<LANG>_COMPILER CLI options instead of exporting CXX, CC, and
  FC. This is the only way that is guaranteed to be cross-platform and
  compatible with non-POSIX shells. It also avoids polluting your
  environment with variables, which may affect the environment for
  external libraries built together with your project.

-->

CMake stores compilers for each language in the `CMAKE_<LANG>_COMPILER` variable. This variable can be set in one of two ways:

1. By using the `-D` option in the CLI

    ```{.bash style=bashstyle}
    $ module load intel-oneapi-compilers # just mention the path to...
    $ cmake -D CMAKE_CXX_COMPILER=icpp
    ```

2. [Discouraged] By exporting the environment variables `CXX` (`CC`, `FC`, `NVCC`)
   
    ```{.bash style=bashstyle}
    $ env CXX=clang++ cmake ..
    ```

I am not convinced, there should also be a way to set it in the CMakeLists.txt file for instance when I want to use different compilers...

<!--

  How it works
  At configure time, CMake performs a series of platform tests to determine which compilers
  are available and if they are suitable for the project at hand. A suitable compiler is not only
  determined by the platform we are working on, but also by the generator we want to use.
  The first test CMake performs is based on the name of the compiler for the project
  language. For example, if cc is a working C compiler, then that is what will be used as the
  default compiler for a C project. On GNU/Linux, using Unix Makefiles or Ninja, the
  compilers in the GCC family will be most likely chosen by default for C++, C, and Fortran.
  On Microsoft Windows, the C++ and C compilers in Visual Studio will be selected,
  provided Visual Studio is the generator. MinGW compilers are the default if MinGW or
  MSYS Makefiles were chosen as generators.

  DEFAULTS 

  Where can we find which default compilers and compiler flags will be picked up by CMake
  for our platform? CMake offers the --system-information flag, which will dump all
  information about your system to the screen or a file. To see this, try the following:
  $ cmake --system-information information.txt
  Searching through the file (in this case, information.txt), you will find the default
  values for the CMAKE_CXX_COMPILER, CMAKE_C_COMPILER, and
  CMAKE_Fortran_COMPILER options, together with their default flags. We will have a look
  at the flags in the next recipe.

-->

## Extracting compiler information 

```{.cmake style=cmakestyle}
# CMakeLists.txt 
...
message(STATUS "Is the C++ compiler loaded? ${CMAKE_CXX_COMPILER_LOADED}")
if(CMAKE_CXX_COMPILER_LOADED)
  message(STATUS "The C++ compiler ID is: ${CMAKE_CXX_COMPILER_ID}")
  message(STATUS "Is the C++ from GNU? ${CMAKE_COMPILER_IS_GNUCXX}")
  message(STATUS "The C++ compiler version is: ${CMAKE_CXX_COMPILER_VERSION}")
endif()
```

## Switching the build type



## Controlling compiler flags 

## Setting the standard for the language

## CMake Stages


## How it works


# Creating a library

## Making a library


- `main` is both the name of the executable file generated and the name of the **CMake target** created (we will talk about targets in more depth)
- The source file list comes next, and you can list as many as you'd like
- CMake is smart, and will only compile source file extensions. The headers will be, for most intents and purposes, ignored; the only reason to list them is to get them to show up in IDEs


```{.cmake style=cmakestyle}
add_library(one STATIC two.cpp three.h)
```

- You get to pick a type of library, STATIC, SHARED, or MODULE. If you leave this choice off, the value of BUILD_SHARED_LIBS will be used to pick between STATIC and SHARED.


## Try different compilation settings 

- As you'll see in the following sections, often you'll need to make a fictional target, that is, one where nothing needs to be compiled, for example, for a header-only library. That is called an INTERFACE library, and is another choice; the only difference is it cannot be followed by filenames.

- You can also make an ALIAS library with an existing library, which simply gives you a new name for a target. The one benefit to this is that you can make libraries with :: in the name (which you'll see later). 

Before doing this we should re-fresh on the steps involved in the compilation process

- Swapping compilers 
- Pre-processing flags 
- Linking flags 

## Compiler 

CMake may pick the wrong compiler on systems with multiple compilers. You can use the environment variables CC and CXX when you first configure, or CMake variables CMAKE_CXX_COMPILER, etc. - but you need to pick the compiler on the first run; you can’t just reconfigure to get a new compiler.

## Setting compiler options 

## Using different compilers 

## {.standout}

Exercise. Configure a project to use a different compiler.

## Managing build types


## {.standout}

Exercise. Modify the CMake project to support multiple build types