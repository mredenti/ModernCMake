---
aspectratio: 169
---

# TARGETS AND PROPERTIES


## WHAT IS A TARGET 


**In CMake, a target is a node <!-- logical unit --> inside the dependecy graph of your project**

- A target is declared by either `add_executable()` or `add_library()` commands where 

- \underline{Executable Targets}: Represent a binary that can be run. 

- \underline{Library Targets}: Represent shared, static libraries or object files. 


## TARGETS HAVE PROPERTIES

<!-- - Any target has a collection of properties, which define which define how the build recipe should be produced and how it should be used by other dependent targets in the project. -->



- A target is a node <!-- logical unit --> inside the dependecy graph of your project that encapsulates **properties**:

  **BUILD REQUIREMENTS**
    : Everything that is needed to build that target 

  **USAGE REQUIREMENTS**
    : Everything that is needed to use that target as a dependency of another target <!-- propagation occurs by target_link_libraries() -->

. . .

\vspace{.5cm}

  - source files (normally not a usage requirement)
  - include search paths (`-I/<>/include/`)
  - pre-processor macros (`-DTYPE=double`)
  - compiler/linker options (`-march=native`)
  - link-dependencies (`-lm`)

## TARGET PROPERTIES -  SETTING BUILD REQUIREMENTS (I)


:::::::::::::: {.columns}
::: {.column width="75%"}

\vspace{.2cm}

**COMPILER FLAGS** 

INCLUDE_DIRECTORIES

```{.cmake style=cmakestyle} 
target_include_directories(mylib PRIVATE include)
```

COMPILE_DEFINITIONS

```{.cmake style=cmakestyle} 
target_compile_definitions(mylib PRIVATE TYPE=double)
```

COMPILE_OPTIONS

```{.cmake style=cmakestyle} 
target_compile_options(mylib PRIVATE -march=native)
```


:::
::: {.column width="25%"}

\vspace{2cm}

```plantuml
skinparam defaultFontSize 18
top to bottom direction

object mylib{
    TYPE : STATIC_LIBRARY
    SOURCES : a.cpp;b.cpp
    INCLUDE_DIRECTORIES: include
    COMPILE_DEFINITIONS : TYPE=double
    COMPILE_OPTIONS : -march=native
    . . .
}

```

::: 
::::::::::::::

- put a link to a full list of properties that can be set on targets

\vspace{.2cm}


## TARGET PROPERTIES -  SETTING BUILD REQUIREMENTS (II)

\vspace{.5cm}

:::::::::::::: {.columns}
::: {.column width="83%"}

\vspace{.2cm}


```{.bash style=bashstyle}
$ cmake --build ./build 
...
@[ 33%] Building CXX object CMakeFiles/mylib.dir/a.cpp.o@
/usr/bin/c++ 
      -DTYPE=double -I/<>/include -march=native 
      -o CMakeFiles/mylib.dir/a.cpp.o -c a.cpp
@[ 66%] Building CXX object CMakeFiles/mylib.dir/b.cpp.o@
/usr/bin/c++ 
      -DTYPE=double -I/<>/include -march=native 
      -o CMakeFiles/mylib.dir/b.cpp.o -c b.cpp
@[100%] Linking CXX static library libmylib.a@
/usr/bin/ar qc libmylib.a 
        CMakeFiles/mylib.dir/a.cpp.o 
        CMakeFiles/mylib.dir/b.cpp.o
/usr/bin/ranlib libmylib.a
```


:::
::: {.column width="27%"}

\vspace{1.7cm}

```plantuml
skinparam defaultFontSize 18
top to bottom direction

object mylib{
    TYPE : STATIC_LIBRARY
    SOURCES : a.cpp;b.cpp
    INCLUDE_DIRECTORIES: include
    COMPILE_DEFINITIONS : TYPE=double
    COMPILE_OPTIONS : -march=native
    . . .
}

```

::: 
::::::::::::::

## TARGET PROPERTIES -  SETTING USAGE REQUIREMENTS (I)

:::::::::::::: {.columns}
::: {.column width="75%"}

\vspace{.2cm}

**COMPILER FLAGS** 

INTERFACE_INCLUDE_DIRECTORIES

```{.cmake style=cmakestyle} 
target_include_directories(mylib INTERFACE include)
```

INTERFACE_COMPILE_DEFINITIONS

```{.cmake style=cmakestyle} 
target_compile_definitions(mylib INTERFACE TYPE=double)
```

INTERFACE_COMPILE_OPTIONS

```{.cmake style=cmakestyle} 
target_compile_options(mylib INTERFACE -march=native)
```

\vspace{.2cm}

:::
::: {.column width="25%"}

\vspace{2cm}

```plantuml
top to bottom direction

object mylib{
    TYPE : STATIC_LIBRARY
    
    SOURCES : a.cpp;b.cpp
    
    INTERFACE_INCLUDE_DIRECTORIES: include
    
    INTERFACE_COMPILE_DEFINITIONS : TYPE=double
    
    INTERFACE_COMPILE_OPTIONS : -march=native
    
    . . .
}

```
::: 
::::::::::::::


## TARGET PROPERTIES -  SETTING USAGE REQUIREMENTS (I)

:::::::::::::: {.columns}
::: {.column width="75%"}

\vspace{.2cm}

**COMPILER FLAGS** 

INTERFACE_INCLUDE_DIRECTORIES

```{.cmake style=cmakestyle} 
target_include_directories(mylib INTERFACE include)
```

INTERFACE_COMPILE_DEFINITIONS

```{.cmake style=cmakestyle} 
target_compile_definitions(mylib INTERFACE TYPE=double)
```

INTERFACE_COMPILE_OPTIONS

```{.cmake style=cmakestyle} 
target_compile_options(mylib INTERFACE -march=native)
```

**LINKER FLAGS**

LINK_LIBRARIES

```{.cmake style=cmakestyle} 
target_link_libraries(main PRIVATE mylib)
```

:::
::: {.column width="25%"}

\vspace{2cm}

```plantuml
top to bottom direction

object mylib{
    TYPE : STATIC_LIBRARY
    
    SOURCES : a.cpp;b.cpp
    
    INTERFACE_INCLUDE_DIRECTORIES: include
    
    INTERFACE_COMPILE_DEFINITIONS : TYPE=double
    
    INTERFACE_COMPILE_OPTIONS : -march=native
    
    . . .
}


object main{
    TYPE : STATIC_LIBRARY
    
    SOURCES : main.cpp
    
    LINK_LIBRARIES : mylib 
    
    . . . 

    INCLUDE_DIRECTORIES: include
    
    COMPILE_DEFINITIONS : TYPE=double
    
    COMPILE_OPTIONS : -march=native
}


mylib --> main 

```
::: 
::::::::::::::


## TARGET PROPERTIES -  SETTING USAGE REQUIREMENTS (II)

\vspace{.3cm}

:::::::::::::: {.columns}
::: {.column width="84%"}

\vspace{.2cm}


```{.bash style=bashstyle}
$ cmake --build ./build -v 
@[ 20%] Building CXX object CMakeFiles/mylib.dir/a.cpp.o@
/usr/bin/c++ -o CMakeFiles/mylib.dir/a.cpp.o -c <>/a.cpp
@[ 40%] Building CXX object CMakeFiles/mylib.dir/b.cpp.o@
/usr/bin/c++ -o CMakeFiles/mylib.dir/b.cpp.o -c <>/b.cpp
@[ 60%] Linking CXX static library libmylib.a@
/usr/bin/ar qc libmylib.a CMakeFiles/mylib.dir/a.cpp.o 
                CMakeFiles/mylib.dir/b.cpp.o
/usr/bin/ranlib libmylib.a
@[ 60%] Built target mylib@
@[ 80%] Building CXX object CMakeFiles/main.dir/main.cpp.o@
/usr/bin/c++ 
    -DTYPE=double -I<>/include -march=native 
    -o CMakeFiles/main.dir/main.cpp.o 
    -c <>/main.cpp
@[100%] Linking CXX executable main@
/usr/bin/c++ CMakeFiles/main.dir/main.cpp.o -o main libmylib.a 
```


:::
::: {.column width="26%"}

\vspace{1.7cm}

```plantuml
top to bottom direction

object mylib{
    TYPE : STATIC_LIBRARY
    
    SOURCES : a.cpp;b.cpp
    
    INTERFACE_INCLUDE_DIRECTORIES: include
    
    INTERFACE_COMPILE_DEFINITIONS : TYPE=double
    
    INTERFACE_COMPILE_OPTIONS : -march=native
    
    . . .
}


object main{
    TYPE : STATIC_LIBRARY
    
    SOURCES : main.cpp
    
    LINK_LIBRARIES : mylib 
    
    . . . 

    INCLUDE_DIRECTORIES: include
    
    COMPILE_DEFINITIONS : TYPE=double
    
    COMPILE_OPTIONS : -march=native
}


mylib --> main 

```

::: 
::::::::::::::


## TARGET PROPERTIES -  SETTING BUILD AND USAGE REQUIREMENTS (I)

:::::::::::::: {.columns}
::: {.column width="70%"}

\vspace{.2cm}

**COMPILER FLAGS** 

(INTERFACE_)INCLUDE_DIRECTORIES

```{.cmake style=cmakestyle} 
target_include_directories(mylib PUBLIC include)
```

(INTERFACE_)COMPILE_DEFINITIONS

```{.cmake style=cmakestyle} 
target_compile_definitions(mylib PUBLIC TYPE=double)
```

(INTERFACE_)COMPILE_OPTIONS

```{.cmake style=cmakestyle} 
target_compile_options(mylib PUBLIC -march=native)
```

\vspace{.2cm}


**LINKER FLAGS**

(INTERFACE_)LINK_LIBRARIES

```{.cmake style=cmakestyle} 
target_link_libraries(mylib PUBLIC m)
```

:::
::: {.column width="30%"}

\vspace{2cm}

```plantuml
top to bottom direction

object mylib{
    TYPE : STATIC_LIBRARY
    
    SOURCES : a.cpp;b.cpp

    INCLUDE_DIRECTORIES: include
    
    COMPILE_DEFINITIONS : TYPE=double
    
    COMPILE_OPTIONS : -march=native
    
    LINK_LIBRARIES : m
    
    INTERFACE_INCLUDE_DIRECTORIES: include
    
    INTERFACE_COMPILE_DEFINITIONS : TYPE=double
    
    INTERFACE_COMPILE_OPTIONS : -march=native
    
    INTERFACE_LINK_LIBRARIES : m
    
    . . .
}

```

::: 
::::::::::::::



## TARGET PROPERTIES -  SETTING BUILD AND USAGE REQUIREMENTS (II)





# UNDERSTANDING VISIBILITY LEVELS: PRIVATE, INTERFACE, PUBLIC

## SETUP

\vspace{.3cm}

Let us move the `greetings.hpp` header file into an `include/` folder for the sake of argument

\vspace{.3cm}

:::::::::::::: {.columns}
::: {.column width="67%"}

```c++
// greetings/src/greetings.cpp
#include <iostream>
#include "greetings.hpp" // <-- !!!!!

// . . . some other stuff 
```

```c++
// greetings/src/hello.cpp
#include <cstdlib>
#include "greetings.hpp" // <-- !!!!!

int main() {

 // . . . some other stuff
```

::: 
::: {.column width="33%"}

\vspace{-.1cm}

\scalebox{0.9}{
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
        [CMakeLists.txt, file
        ]
        [\colorbox{pink}{greetings.cpp}, file
        ]
        [include
          [greetings.hpp, file
          ]
        ]
        [\colorbox{pink}{hello.cpp}, file
        ]
      ]
    ]
  ]
\end{forest}
}
::: 
::::::::::::::


## HEADER NOT FOUND

\vspace{.3cm}

Compilation fails if compiler can not find header file **greetings.hpp**

\vspace{.1cm}

:::::::::::::: {.columns}
::: {.column width="67%"}

```{.cmake style=cmakestyle}
add_library(greetings 
            STATIC 
              greetings.cpp) 
add_executable(hello hello.cpp) 
target_link_libraries(hello PRIVATE greetings)
```


```{.bash style=bashstyle}
$ cmake -B ./build -S greetings
$ cmake --build ./build
@[25%] Building CXX object <>/greetings.cpp.o@
/usr/bin/c++ -c <>/greetings.cpp
<>/src/greetings.cpp:2:10: fatal error: 
  greetings.hpp: No such file or directory
 #include "greetings.hpp"
          ^~~~~~~~~~~~~~~
```

::: 
::: {.column width="33%"}


\scalebox{0.9}{
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
        [greetings.cpp, file
        ]
        [include
          [greetings.hpp, file
          ]
        ]
        [hello.cpp, file
        ]
      ]
    ]
  ]
\end{forest}
}

::: 
::::::::::::::



## PRIVATE

\vspace{.2cm}

Let us set the header search path as a **build requirement (PRIVATE)** of the `greetings` library

\vspace{.2cm}

:::::::::::::: {.columns}
::: {.column width="72%"}

```{.cmake style=cmakestyle}
add_library(greetings STATIC greetings.cpp) 
target_include_directories(greetings 
          PRIVATE ${CMAKE_CURRENT_LIST_DIR}/include)
add_executable(hello hello.cpp) 
target_link_libraries(hello PRIVATE greetings)
```

```{.bash style=bashstyle}
$ cmake -B ./build -S ./greetings
$ cmake --build ./build
@[25%] Building CXX object <>/greetings.cpp.o@ 
/usr/bin/c++ -I<>/include 
      -o <>/greetings.cpp.o -c <>/greetings.cpp
@[50%] Linking CXX static library libgreetings.a@
@[75%] Building CXX object <>/hello.cpp.o@
/usr/bin/c++ -o <>/hello.cpp.o -c <>/hello.cpp
<>/hello.cpp:2:10: fatal error: No such file 
 #include "greetings.hpp" ...
```
::: 
::: {.column width="28%"}

\vspace{-.2cm}

\scalebox{0.9}{
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
        [greetings.cpp, file
        ]
        [include
          [greetings.hpp, file
          ]
        ]
        [hello.cpp, file
        ]
      ]
    ]
  ]
\end{forest}
}

::: 
::::::::::::::

## INTERFACE

\vspace{.3cm}

Let us set the header search path as a **usage requirement (INTERFACE)** of the `greetings` library

\vspace{.3cm}

:::::::::::::: {.columns}
::: {.column width="72%"}

```{.cmake style=cmakestyle}
add_library(greetings STATIC greetings.cpp) 
target_include_directories(greetings 
            INTERFACE ${CMAKE_CURRENT_LIST_DIR}/include)
add_executable(hello hello.cpp) 
target_link_libraries(hello PRIVATE greetings)
```

```{.bash style=bashstyle}
$ cmake -B ./build -S ./greetings
$ cmake --build ./build
@[25%] Building CXX object <>/greetings.cpp.o@
@[50%] Linking CXX static library libgreetings.a@
@[75%] Building CXX object <>/hello.cpp.o@
/usr/bin/c++ -o <>/hello.cpp.o -c <>/hello.cpp
<>/hello.cpp:2:10: fatal error: greetings.hpp: No such file or directory
 #include "greetings.hpp"
          ^~~~~~~~~~~~~~~
compilation terminated.
```

::: 
::: {.column width="28%"}

\vspace{-.2cm}

\scalebox{0.9}{
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
        [greetings.cpp, file
        ]
        [include
          [greetings.hpp, file
          ]
        ]
        [hello.cpp, file
        ]
      ]
    ]
  ]
\end{forest}
}
::: 
::::::::::::::


## PUBLIC

\vspace{.3cm}

Let us set the header search path as a **build and usage (PUBLIC)** requirement of the `greetings` library.

\vspace{.1cm}

:::::::::::::: {.columns}
::: {.column width="72%"}

```{.cmake style=cmakestyle}
add_library(greetings STATIC greetings.cpp) 
target_include_directories(greetings 
            PUBLIC ${CMAKE_CURRENT_LIST_DIR}/include)
add_executable(hello hello.cpp) 
target_link_libraries(hello PRIVATE greetings)
```

```{.bash style=bashstyle}
$ cmake -B ./build -S ./greetings
$ cmake --build ./build
@[ 25%] Building CXX object <>/greetings.cpp.o@
@[ 50%] Linking CXX static library libgreetings.a@
@[ 50%] Built target greetings@
@[ 75%] Building CXX object <>/hello.cpp.o@
@[100%] Linking CXX executable hello@
@[100%] Built target hello@
```

::: 
::: {.column width="28%"}

\vspace{-.2cm}

\scalebox{0.9}{
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
        [greetings.cpp, file
        ]
        [include
          [greetings.hpp, file
          ]
        ]
        [hello.cpp, file
        ]
      ]
    ]
  ]
\end{forest}
}

::: 
::::::::::::::


## AUMMARY 

TARGETS ARE LIKE OBJECTS WITH PROPERTIES

- USAGE REQUIREMENT PROPAGATE ALON EDGES OF THE DEPENDENCY GRAPH AND IF
  
- Private populates the non interface property
- INTERFACE populates the INTERFACE_ property.
- PUBLIC populates both.