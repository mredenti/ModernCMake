---
aspectratio: 169
---



# CREATING A LIBRARY 

## OVERVIEW

<!-- 
  BUILDING AND LINKING STATIC AND SHARED LIBRARIES
-->

<!--
  A project almost always consists of more than a single executable built from a single source file. Projects are split across multiple source files, often spread across different subdirectories in the source tree. This practice not only helps in keeping source code organized within a project, but greatly favors modularity, code reuse, and separation of concerns, since common tasks can be grouped into libraries. This separation also simplifies and speeds up recompilation of a project during development. In this recipe, we will show

  how to group sources into libraries and how to link targets against these libraries.

  Keeping everything in one directory is fine for simple projects, but most real world projects split
  their files across multiple directories. It is common to find different file types or individual modules
  grouped under their own directories, or for files belonging to logical functional groupings to be in
  their own part of the project’s directory hierarchy. While the directory structure may be driven by
  how developers think of the project, the way the project is structured also impacts the build system.
-->

- Most projects consist of multiple source files

- Splitting code into multiple files enhances modularity, code reuse, and separation of concerns

- Using libraries simplifies code management and speeds up recompilation

<!-- 
  Why Use Libraries?
    Libraries organize common tasks and reusable code.
    They facilitate modular project structure.
    Libraries improve code maintainability and understanding.

  A project almost always consists of more than a single executable built from a single source file. 
  Only rarely we have one-source-file projects and more realistically, as projects grow, we split them up into separate files. This simplifies (re)compilation but also helps humans maintaining and understanding the project.

  Understanding the concepts that are to come in this chapter helps in organizing 
  and managing larger projects effectively, ensuring better code maintenance and scalability.
-->

BUT WHY DO WE NEED LIBRARIES? THAT AIN'T CLEAR! 

Mature applications are often built from many components, and I don't mean external dependencies here. Specifically, I'm talking about internal libraries. Adding them to the project is useful from a structural perspective, as related things are packaged together in a single logical entity. And they can be linked with other targets – another library or an executable. This is especially convenient when multiple targets are using the same library.

As software developers, we deliberately draw boundaries and designate components to group one or more units of translation (.cpp files). We do it for multiple reasons: to increase code readability, manage coupling and connascence, speed up the build process, and finally, extract the reusable components.

## A GREETINGS LIBRARY - SET UP (I)

:::::::::::::: {.columns}
::: {.column width="65%"}

```c++
// greetings/src/greetings.hpp
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
    [greetings
      [src
        [\colorbox{pink}{greetings.hpp}, file
        ]
        [greetings.cpp, file
        ]
        [hello.cpp, file
        ]
      ]
    ]
  ]
\end{forest}

::: 
::::::::::::::


## A GREETINGS LIBRARY - SET UP (II)

:::::::::::::: {.columns}
::: {.column width="65%"}

```c++
// greetings/src/greetings.cpp
#include <iostream>
#include "greetings.hpp"

namespace greetings {
  
  void say_hello() {
    std::cout << "Hello, World!\n";
  }

  void say_goodbye() {
    std::cout << "Goodbye, World!\n";
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
    [greetings
      [src
        [greetings.hpp, file
        ]
        [\colorbox{pink}{greetings.cpp}, file
        ]
        [hello.cpp, file
        ]
      ]
    ]
  ]
\end{forest}

::: 
::::::::::::::

## A GREETINGS LIBRARY - SET UP (III)

:::::::::::::: {.columns}
::: {.column width="65%"}

```c++
#include <cstdlib>
#include "greetings.hpp"

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
    [greetings
      [src
        [greetings.hpp, file
        ]
        [greetings.cpp, file
        ]
        [\colorbox{pink}{hello.cpp}, file
        ]
      ]
    ]
  ]
\end{forest}

::: 
::::::::::::::

## CREATING A STATIC LIBRARY - HOW TO DO IT (I)


:::::::::::::: {.columns}
::: {.column width="65%"}

1. In the top level `CMakeLists.txt` file declare the global setup of our project. Additionally, include a call to the `add_subdirectory()` command to incorporate the `CMakeLists.txt` configuration from the `src` subdirectory

```{.cmake style=cmakestyle}
cmake_minimum_required(VERSION 3.21)

project(Greetings LANGUAGES CXX)

add_subdirectory(src)
```

<!--
  These commands bring content from another file or directory into the build, allowing the
  build logic to be distributed across the directory hierarchy rather than forcing everything to be
  defined at the top-most level. This offers a number of advantages:
  - Build logic is localized, meaning that characteristics of the build can be defined in the directory
  where they have the most relevance.
  - Builds can be composed of subcomponents which are defined independently of the top level
  project consuming them. This is especially important if a project makes use of things like git
  submodules or embeds third party source trees.
  - Because directories can be self-contained, it becomes relatively trivial to turn parts of the build
  on or off simply by choosing whether to add in that directory.

  The add_subdirectory() command allows a project to bring another directory into the build. That
  directory must have its own CMakeLists.txt file which will be processed at the point where
  add_subdirectory() is called. A corresponding directory will be created in the project’s build tree.

  The sourceDir does not have to be a subdirectory within the source tree, although it usually is. Any
  directory can be added, with sourceDir being specified as either an absolute or relative path, the
  latter being relative to the current source directory. Absolute paths are typically only needed when
  adding directories that are outside the main source tree.
-->

::: 
::: {.column width="35%"}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [greetings
      [\colorbox{pink}{CMakeLists.txt}, file
      ]
      [src
        [CMakeLists.txt, file
        ]
        [greetings.hpp, file
        ]
        [greetings.cpp, file
        ]
        [hello.cpp, file
        ]
      ]
    ]
  ]
\end{forest}

::: 
::::::::::::::

## CREATING A STATIC LIBRARY - HOW TO DO IT (II)

<!-- 
  These two new files will also have to be compiled and we have to modify CMakeLists.txt accordingly. However, in this example we want to compile them first into a library, and not directly into the executable
-->


:::::::::::::: {.columns}
::: {.column width="65%"}

<!--
  We will encounter the term target repeatedly. In CMake, a target is any object given as first argument to add_executable or add_library. Targets are the basic atom in CMake. Whenever you will need to organize complex projects, think in terms of its targets and their mutual dependencies. The whole family of CMake commands target_* can be used to express chains of dependencies and is much more effective than keeping track of state with variables. 
-->

2. Create a new **target**, this time a static library. The name of the library will be name of the target and the sources are listed as follows

    ```{.cmake style=cmakestyle}
    add_library(greetings 
                STATIC 
                    greetings.hpp greetings.cpp) 
    ```
<!-- 
   - add_library(message STATIC Message.hpp Message.cpp): This will
   generate the necessary build tool instructions for compiling the specified sources into a library.


   - The first argument to add_library is the name of the target. The
   same name can be used throughout CMakeLists.txt to refer to the library. The
   actual name of the generated library will be formed by CMake by adding the
   prefix lib in front and the appropriate extension as a suffix. The library
   extension is determined based on the second argument, STATIC or SHARED, and
   the operating system.
-->

1. The creation of the **target** for the `hello` executable is unmodified

    ```{.cmake style=cmakestyle}
    add_executable(hello hello.cpp) 
    ```

::: 
::: {.column width="35%"}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [greetings
      [CMakeLists.txt, file
      ]
      [src
        [\colorbox{pink}{CMakeLists.txt}, file
        ]
        [greetings.hpp, file
        ]
        [greetings.cpp, file
        ]
        [hello.cpp, file
        ]
      ]
    ]
  ]
\end{forest}

::: 
::::::::::::::

## CREATING A STATIC LIBRARY - HOW TO DO IT (III)

:::::::::::::: {.columns}
::: {.column width="65%"}

4. Finally we have to tell CMake that the `greetings` library target has to be linked into the `hello` executable target

    ```{.cmake style=cmakestyle}
    target_link_libraries(hello greetings)
    ```

::: 
::: {.column width="35%"}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [greetings
      [CMakeLists.txt, file
      ]
      [src
        [\colorbox{pink}{CMakeLists.txt}, file
        ]
        [greetings.hpp, file
        ]
        [greetings.cpp, file
        ]
        [hello.cpp, file
        ]
      ]
    ]
  ]
\end{forest}

::: 
::::::::::::::

## GENERATE PROJECT FILES

<!--

  The output from the configuration and 
  generation is actually the same as before

  $\Rightarrow$ BUILD $\Rightarrow$ RUN
-->


Configure and generate project files  
    
```{.bash style=bashstyle}
$ cmake -B ../build --trace-source=CMakeLists.txt 
<>/greetings/CMakeLists.txt(1): cmake_minimum_required(VERSION 3.21)
<>/greetings/CMakeLists.txt(3): project(Greetings LANGUAGES CXX)
-- The CXX compiler identification is GNU 8.4.1
. . . 
-- Detecting CXX compile features - done
<>/greetings/CMakeLists.txt(5): add_subdirectory(src)
<>/greetings/src/CMakeLists.txt(1): 
        add_library(greetings STATIC greetings.cpp greetings.hpp)
<>/greetings/src/CMakeLists.txt(8): 
        add_executable(hello hello.cpp)
<>/greetings/src/CMakeLists.txt(12): 
        target_link_libraries(hello greetings)
-- Configuring done
-- Generating done
-- Build files have been written to: <>/build
```

## BUILD THE GREETINGS LIBRARY


```{.bash style=bashstyle}
$ cmake --build ./build --target greetings -v

[ 50%] Building CXX object src/CMakeFiles/greetings.dir/greetings.cpp.o
cd <>/build/src && /usr/bin/c++  
      -MD -MT src/CMakeFiles/greetings.dir/greetings.cpp.o 
      -MF CMakeFiles/greetings.dir/greetings.cpp.o.d 
      -o CMakeFiles/greetings.dir/greetings.cpp.o 
      -c <>/greetings/src/greetings.cpp
[100%] Linking CXX static library libgreetings.a
cd <>/build/src
. . . 
/usr/bin/ar qc libgreetings.a CMakeFiles/greetings.dir/greetings.cpp.o
/usr/bin/ranlib libgreetings.a
. . . 
[100%] Built target greetings
```

## BUILD AND LINK THE HELLO PROGRAM TO GREETINGS

```{.bash style=bashstyle}
$ cmake --build ./build --target hello -v

. . . 
[ 75%] Building CXX object src/CMakeFiles/hello.dir/hello.cpp.o
cd <>/build/src && /usr/bin/c++ 
    -MD -MT src/CMakeFiles/hello.dir/hello.cpp.o 
    -MF CMakeFiles/hello.dir/hello.cpp.o.d 
    -o CMakeFiles/hello.dir/hello.cpp.o 
    -c <>/greetings/src/hello.cpp
[100%] Linking CXX executable hello
cd <>/build/src && . . . 
/usr/bin/c++ CMakeFiles/hello.dir/hello.cpp.o -o hello libgreetings.a 
. . . 
```


## RUN 


:::::::::::::: {.columns}
::: {.column width="65%"}

\vspace{1cm}

- Finally we can run the `hello` program
    
    ```{.bash style=bashstyle}
    $ ./build/src/hello
    Hello, World!
    Goodbye, World!
    ```

- The call to `add_subdirectory(src)` creates a matching directory structure in the `build` folder

::: 
::: {.column width="35%"}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [greetings
      [CMakeLists.txt, file
      ]
      [src
        [..., file
        ]
      ]
    ]
    [build
      [..., file
      ]
      [CMakeFiles
      ]
      [src
        [...
        ]
        [hello, executable
        ]
        [libgreetings.a, executable
        ]
      ]
    ]
  ]
\end{forest}

::: 
::::::::::::::

## HOW IT WORKS - ADD_LIBRARY()

```{.cmake style=cmakestyle}
add_library(greetings STATIC greetings.hpp greetings.cpp) 
```

- Generates the necessary build instructions for compiling the specified sources, `Greetings.cpp`, into a **STATIC** library

- The name of the target, `greetings`, can be used troughout `CMakeLists.txt` to refer to the library

- The actual name of the generated library will be formed by CMake by adding the prefix `lib` in front and the appropriate extension as a suffix, determined based on the second argument (**STATIC**, **SHARED**, **OBJECT**, ...)  and the OS.


## HOW IT WORKS - TARGET_LINK_LIBRARIES()

\vspace{.5cm}

```{.cmake style=cmakestyle}
target_link_libraries(hello-world greetings)
```

<!--
  We will encounter the term target repeatedly. In CMake, a target is any object given as first argument to add_executable or add_library. Targets are the basic atom in CMake. Whenever you will need to organize complex projects, think in terms of its targets and their mutual dependencies. The whole family of CMake commands target_* can be used to express chains of dependencies and is much more effective than keeping track of state with variables. 

  - target_link_libraries(hello-world message): Links the library into the
executable. This command will also guarantee that the hello-world executable
properly depends on the message library. We thus ensure that the message
library is always built before we attempt to link it to the hello-world
executable.

- After successful compilation, the build directory will contain the libmessage.a static
library (on GNU/Linux) and the hello-world executable.
-->

- Guarantees that the `hello` target depends on the message library $\Rightarrow$ the **greetings** library is always built before being linked it to the `hello` executable

    ```{.bash style=bashstyle}
    $ cmake --build ./build 
    [ 25%] Building CXX object src/CMakeFiles/greetings.dir/greetings.cpp.o
    [ 50%] Linking CXX static library libgreetings.a
    [ 50%] Built target greetings
    [ 75%] Building CXX object src/CMakeFiles/hello.dir/hello.cpp.o
    [100%] Linking CXX executable hello
    [100%] Built target hello
    ```

<!--
$\Rightarrow$ the **greetings** library is always built before being linked it to the `hello` executable
-->

<!-- 
  After successful compilation, the build directory will contain the libmessage.a static
  library (on GNU/Linux) and the hello-world executable
-->

## HOW IT WORKS - TARGET PROPERTIES (I)

\vspace{.4cm}

A target is a logical unit that encapsulates the **properties** required to build a component of your software project.

\vspace{.3cm}

:::::::::::::: {.columns}
::: {.column width="80%"}


```{.cmake style=cmakestyle}
add_library(greetings STATIC greetings.hpp greetings.cpp) 

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

::: 
::: {.column width="10%"}


\scalebox{0.7}{
\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [greetings
      [CMakeLists.txt, file
      ]
      [src
        [\colorbox{pink}{CMakeLists.txt}, file
        ]
        [greetings.hpp, file
        ]
        [greetings.cpp, file
        ]
        [hello.cpp, file
        ]
      ]
    ]
  ]
\end{forest}
}

::: 
::: {.column width="10%"}

::: 
::::::::::::::

<!-- 
  These collection of properties define **how** the build "artifact" should be produced and how it should be used by other dependent targets in the project (usage requirements)
-->

## HOW IT WORKS - TARGET PROPERTIES (II)

\vspace{.3cm}

A target is a logical unit that encapsulates the **properties** required to build a component of your software project.

\vspace{.3cm}

:::::::::::::: {.columns}
::: {.column width="80%"}


```{.cmake style=cmakestyle}
include(CMakePrintHelpers)

add_executable(hello hello.cpp)
target_link_libraries(hello greetings)

cmake_print_properties(TARGETS hello
                    PROPERTIES TYPE SOURCES LINK_LIBRARIES)
```

```{.bash style=bashstyle}
$ cmake -B <build-tree> -S <source-tree>
...
-- hello.TYPE : EXECUTABLE
-- hello.SOURCES : hello.cpp 
-- hello.LINK_LIBRARIES : greetings
```

::: 
::: {.column width="10%"}


\scalebox{0.7}{
\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [greetings
      [CMakeLists.txt, file
      ]
      [src
        [\colorbox{pink}{CMakeLists.txt}, file
        ]
        [greetings.hpp, file
        ]
        [greetings.cpp, file
        ]
        [hello.cpp, file
        ]
      ]
    ]
  ]
\end{forest}
}

::: 
::: {.column width="10%"}

::: 
::::::::::::::

## HOW IT WORKS - DEPENDENCY GRAPH (I)

<!-- 
    To print a target property on screen, we first need to store it in the `<var>` variable and then message() it to the user; we have to read them one by one. 
-->

\vspace{.5cm}

\centering 

**A target is a node inside the dependecy graph of your project**

\vspace{.4cm}

:::::::::::::: {.columns}
::: {.column width="60%"}

```{.cmake style=cmakestyle}
# src/CMakeLists.txt
add_library(greetings 
      STATIC 
      greetings.hpp greetings.cpp) 

add_executable(hello hello.cpp)
target_link_libraries(hello greetings)
```

```{.bash style=bashstyle}
$ cmake -B <build-tree> -S <source-tree>
$ cmake --build <build-tree>
... missing output
```

::: 
::: {.column width="40%"}

```plantuml
top to bottom direction

title Greetings : Dependency Graph

object hello{
  TYPE : EXECUTABLE
  SOURCES : hello.cpp 
  LINK_LIBRARIES : greetings
  . . . 
}

object greetings{
    TYPE : STATIC_LIBRARY
    SOURCES : greetings.cpp/.hpp
    LINK_LIBRARIES : NOT_FOUND
    . . .
}

greetings --> hello 

```


::: 
::::::::::::::


## HOW IT WORKS - DEPENDENCY GRAPH (II)

<!-- 
    To print a target property on screen, we first need to store it in the `<var>` variable and then message() it to the user; we have to read them one by one. 
-->

\vspace{.5cm}

\centering 

**Direct dependencies between targets are created with `target_link_libraries()`**

\vspace{.4cm}

:::::::::::::: {.columns}
::: {.column width="60%"}

```{.cmake style=cmakestyle}
# src/CMakeLists.txt
add_library(greetings 
      STATIC 
      greetings.hpp greetings.cpp) 

add_executable(hello hello.cpp)
# target_link_libraries(hello greetings)
```

```{.bash style=bashstyle}
$ cmake -B <build-tree> -S <source-tree>
$ cmake --build <build-tree>
... missing output
```

::: 
::: {.column width="40%"}

```plantuml
top to bottom direction

title Greetings : Dependency Graph

object hello{
  TYPE : EXECUTABLE
  SOURCES : hello.cpp 
  LINK_LIBRARIES : NOT_FOUND
  . . . 
}

object greetings{
    TYPE : STATIC_LIBRARY
    SOURCES : greetings.cpp/.hpp
    LINK_LIBRARIES : NOT_FOUND
    . . .
}

greetings -[hidden]-> hello 

```


::: 
::::::::::::::



## LIBRARY TYPES: STATIC, SHARED, OBJECT 

            
```{.cmake style=cmakestyle}
add_library(<name> [STATIC | SHARED | OBJECT ]
                    [<source>...])
                    [EXCLUDE_FROM_ALL]
```

**STATIC** 
 : used to create static libraries, that is, archives of object files for use when linking other targets


**SHARED**
  : used to create shared libraries, that is, libraries that can be linked dynamically and loaded at runtime
  
**OBJECT** 
  : used to compile the sources in the list given to `add_library()` to object files, but then neither archiving them into a static library nor linking them into a shared object. 
  


## SHOW OBJECT 

SHOW SAME EXAMPLES WITH OBJECT TYPES TO CLARIFY THE DIFFERENCE WITH OUTPUT AS WELL

<!-- 

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


  The use of object libraries is particularly useful if one needs to create 
  both static and shared libraries in one go. We will demonstrate this in

  MODULE libraries are once again DSOs. In contrast to SHARED libraries, they are
  not linked to any other target within the project, but may be loaded dynamically
  later on. This is the argument to use when building a runtime plugin

-->

<!-- 

I WILL SHOW THIS IN THE EXERCISES AND TELL THEM TO OPEN UP THE LINK

## GRAPHVIZ OF DEPENDENCIES

- CMake can use the Graphviz graph visualization software (http://www.graphviz.org) to
generate the dependency graph of a project:

    ```{.bash style=bashstyle}
    $ cmake -B ./build -S . --graphviz=greetings.dot
    $ dot -T png greetings.dot -o greetings.png
    ```

The generated diagram will show dependencies between targets in different directories

show the picture

-->

<!--

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

We will encounter the term target repeatedly. In CMake, a target is any object given as first argument to add_executable or add_library. Targets are the basic atom in CMake. Whenever you will need to organize complex projects, think in terms of its targets and their mutual dependencies. The whole family of CMake commands target_* can be used to express chains of dependencies and is much more effective than keeping track of state with variables. 

-->


<!-- 

  IMPORTANCE ABOUT SCOPE

  Targets are visible at any scope after the point that they have been defined. Regular (non-cache) variables are scoped to directories, functions, and block()s, and are only visible to script code in the same directory function, and block scope (same function scope, and same directory level, or subdirectories added by add_subdirectory). To define a variable in the parent directory's scope, you must define it like set(<variable> <value>... PARENT_SCOPE).


-->


