---
aspectratio: 169
---

# VARIABLES 

## OVERVIEW 

<!--
  In CMake there are only two building blocks (syntactic elements) that define 
  the structure and organization of code and allow us to manage the build process
  of software projects

  The preceding chapters showed how to define basic targets and produce build outputs. On its own,
  this is already useful, but CMake comes with a whole host of other features which bring great
  flexibility and convenience. This chapter covers one of the most fundamental parts of CMake,
  namely the use of variables.

  MENTION HOW WE HAVE NOT REALLY DISCUSSED COMPILATIONS
-->

**Variables** are the basic unit of storage in CMake.

\vspace{.2cm}

<!-- 
  **Variables** and commands are the only two syntactic elements of the CMaka language. 
-->

\underline{Purpose}:

<!--
  controlling the configuration and behaviour of the build process

  customise and manage different aspects of the build system, enabling flexibility and reusability
-->

- **Configuration**: setting paths, compiler options, compiler standards 
  <!--and other configurations required during the build process -->
  
-  **Customisation:** manage and control the build process based on different criteria (target platform, build type, compiler ID, user-specific options)

\vspace{.3cm}

Two main types of variables: **Local**, **Cache**

<!--

  CMAKE VARIABLES ARE NOT ENVIRONMENT VARIABLES (UNLIKE MAKEFILES)

  Declared/Defined using the set() command.

  Customization: Variables allow you to customize the build process based on different criteria such as the target platform, build type (e.g., Debug or Release), or user-specific options.

  Reuse: By defining variables, you can reuse values throughout your CMake scripts, reducing redundancy and making maintenance easier.

  - Variables are essential for integrating external tools and dependencies. You can use variables to specify paths, compiler flags, and other configurations required for external libraries and tools, ensuring a smooth integration process.

  - Variables enable conditional logic in CMake scripts. By using variables in conditional statements, you can make decisions based on the system environment, platform, or user-defined settings, ensuring that the build process adapts appropriately to different scenarios.

  - Variables provide a way for users to customize the build process. By setting cache variables, users can override default settings through command-line arguments or CMake GUI tools, allowing for tailored builds based on specific needs and environments.

-->


## MOTIVATING EXAMPLE: TOGGLE LIBRARY USAGE 

\vspace{.3cm}

\centering Consider the same source code as for the greetings project.

\vspace{.5cm}

:::::::::::::: {.columns}
::: {.column width="65%"}

How can we toggle between the following two behaviours:

\vspace{.3cm}

1. Build `greetings.hpp` and `greetings.cpp` into a `STATIC` library and then link the resulting library into the `hello` executable 

\vspace{.3cm}

2. Build  `greetings.hpp`, `greetings.cpp` and `hello.cpp` into a single executable, without producing the library


<!-- 
  This is a common use case where variables can control the build configuration.
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
      [src
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

## HOW TO DO IT (I)

\vspace{.5cm}

:::::::::::::: {.columns}
::: {.column width="67%"}

1. Introduce a logical variable, `USE_LIBRARY`, in the top level `CMakeLists.txt` file with value set to `OFF`. 

```{.cmake style=cmakestyle}
cmake_minimum_required(VERSION 3.21)

project(Greetings LANGUAGES CXX)

# Define a variable to toggle library usage
set(USE_LIBRARY OFF) # set(USE_LIBRARY "OFF")
message(STATUS "Compile sources into a library? 
                ${USE_LIBRARY}")

add_subdirectory(src)
```

::: 
::: {.column width="33%"}

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


<!-- 
  This example demonstrates how variables can be used to control the build process.
-->


## HOW TO DO IT (II)

\vspace{.5cm}

:::::::::::::: {.columns}
::: {.column width="67%"}

2. Introduce a variable `_sources`, listing `greetings.hpp` and `greetings.cpp` 

```{.cmake style=cmakestyle}
list(APPEND _sources greetings.hpp greetings.cpp)
```

3. Introduce an `if-else` statement based on the value of `USE_LIBRARY` to toggle between the two behaviours

```{.cmake style=cmakestyle}
if(USE_LIBRARY)

  add_library(greetings STATIC ${_sources})
  add_executable(hello hello.cpp)
  target_link_libraries(hello greetings)
else()

  add_executable(hello hello.cpp ${_sources})
endif()

```

::: 
::: {.column width="33%"}

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


<!-- 
  We can again build with the same set of commands. Since USE_LIBRARY is set to
  OFF, the hello-world executable will be compiled from all sources. This can be
  verified by running the objdump -x command on GNU/Linux.
-->

## HOW IT WORKS 

- The variable `USE_LIBRARY` has been set to `OFF` in the top level CMakeLists.txt file. 

- In the CMake language, true or false values can be expressed in a number of ways:
  
  - A logical variable is **true** if it is set to any of the following: **1**, **ON**, **YES**, **TRUE**, **Y**, or a **non-zero number**.
  
  - A logical variable is **false** if it is set to any of the following: **0**, **OFF**, **NO**, **FALSE**, **N**, **IGNORE**, **NOTFOUND**, an empty string **""**, or it ends in the suffix **-NOTFOUND**.

. . . 

\vspace{.2cm}

$\Rightarrow$ At build time...

```{.bash style=bashstyle}
$ cmake --build ./build --verbose
...
@[100%] Linking CXX executable hello@
cd <>/build/src ...
/usr/bin/c++ CMakeFiles/hello.dir/hello.cpp.o 
            CMakeFiles/hello.dir/greetings.cpp.o -o hello 
```


<!-- MENTION THE PROPERTIES EARLIER --> 


<!-- 
  Key Points:
  Local variables are declared using the set() command.
  Scope limited to the directory where they are defined.
  Useful for temporary settings and internal script logic.

- A local variable can be defined with the `set()` command

    ```{.cmake style=cmakestyle}
    set(<variable> <value>...)
    ```

- Variable names, `variable`, can contain `A-Za-z0-9_` with letters being
case-sensitive

    ```{.cmake style=cmakestyle}
    set(FOO "foo") 
    set(foo "bar")  
    ```

  - The ${} operator can be used recursively

  - A new user-defined local variable can be created with the `set` command

  -  Variable names are case sensitive, values can only contain [A-Za-z0-9_]

- Variables are expanded using ${}
  
    ```{.cmake style=cmakestyle}
    message(STATUS FOO=${FOO}) # "foo"
    message(STATUS foo=${foo}) # "bar"
    ```



\alert{I WOULD PROBABLY REMOVE THIS SCRAP AND YOU SIMPLY MENTION IT}

\vspace{0.5cm}

- CMake treats all variables as strings 

    
    ```{.cmake style=cmakestyle}
    set(FOO "bar") # "bar"
    set(FOO bar)   # "bar"
    set(FOO 42)    # "42"
    ```

\vspace{0.5cm}


- Lists are semicolon-separated strings
  
  ```{.cmake style=cmakestyle}
  set(FOO "1" "2" "3") # "1;2;3"
  set(FOO 1 2 3)       # "1;2;3" 
  set(FOO "1;2;3")     # "1;2;3" 
  ```

  the resultant string is how CMake represents lists.

  - The ${} operator can be used recursively

  - A new user-defined local variable can be created with the `set` command

  -  Variable names are case sensitive, values can only contain [A-Za-z0-9_]

  Be careful with variables which contain whitespace (PATH) 

  Multiple arguments will be joined as a semicolon-separated list to form the actual variable value to be set.


-->


## LOCAL VARIABLES - DIRECTORY SCOPE (I)

<!--
  SCOPE IS ONE OF THE MOST CONFUSING ASPECTS OF CMAKE

  Variables are scoped
  Each new scope creates a local copy of all variables
  Scopes created by add_subdirectory() or custom function call
  Top level scope is the CACHE, can serve as global variables. Values are kept between runs.
  Can prepopulate the cache variables with -D<var>=<val> on the command line

  One of the most confusing aspects of CMake is the scoping of variables. 
-->

\vspace{0.4cm}

A local variable has a scope corresponding to the CMakeLists.txt file in which the variable is defined (**directory scope**)...

\vspace{0.3cm}


... but **you can read the intended value of a local variable only after you have set it**.

:::::::::::::: {.columns}
::: {.column width="70%"}

  ```{.cmake style=cmakestyle}
  # project/CMakeLists.txt
  message(STATUS ${FOO}) # ""
  set(FOO "foo")
  message(STATUS ${FOO}) # "foo"
  ```

:::
::: {.column width="30%"}


\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [project
      [CMakeLists.txt, file
      ]
    ]
  ]
\end{forest}

:::
:::::::::::::: 

. . .

- Use `--warn-uninitialized` to warn about uninitialised values
  ```{.bash style=bashstyle}
  $ cmake -B ./build --warn-uninitialized
  CMake Warning (dev) at CMakeLists.txt:6 (message):
    uninitialized variable 'FOO'
  . . . 
  ```

## LOCAL VARIABLES - DIRECTORY SCOPE (II)

\vspace{.5cm}

<!-- 
  include() does not create a new scope, can be used within the directory scope of the current CMakeLists.txt file 
-->
The `add_subdirectory()` command creates a new scope for processing that subdirectory's CMakeLists.txt file.

:::::::::::::: {.columns}
::: {.column width="70%"}

  <!--

  - Variable values are inherited by CMakeLists.txt files in sub directories

  - Accessible in subdirectories but not vice versa

  Scopes created by add_subdirectory() or custom function call

  - Local variables are limited to the scope of the current directory and its subdirectories
  
  -  Local variables defined this way have a scope limited to the current ... and everything below it (CMAKE_CXX_STANDARD goes in the top level CMakeLists.txt)


--> 

\vspace{.5cm}

<!--
  Subdirectories inherit variables from their parent scope
-->

- All variables defined in the calling scope are copied into the subdirectory’s child scope upon
entry.

    ```{.cmake style=cmakestyle}
    # project/CMakeLists.txt
    set(FOO "foo") 
    add_subdirectory(src)
    ```

    ```{.cmake style=cmakestyle}
    # project/src/CMakeLists.txt
    message(STATUS ${FOO}) #"foo"
    ```

:::
::: {.column width="30%"}


\vspace{1cm}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [project
      [CMakeLists.txt, file
      ]
      [src
        [CMakeLists.txt, file
        ]
      ]
    ]
  ]
\end{forest}

:::
:::::::::::::: 

## LOCAL VARIABLES - DIRECTORY SCOPE (III)

\vspace{.5cm}

The `add_subdirectory()` command creates a new scope for processing that subdirectory's CMakeLists.txt file.

:::::::::::::: {.columns}
::: {.column width="70%"}

\vspace{.5cm}

- Any change to a variable in the subdirectory’s child scope is local to that child scope.

    ```{.cmake style=cmakestyle}
    # project/CMakeLists.txt
    set(FOO "foo") 
    add_subdirectory(src)
    message(STATUS ${FOO}) # "foo"
    ```

    ```{.cmake style=cmakestyle}
    # project/src/CMakeLists.txt
    unset(FOO) 
    message(STATUS ${FOO}) # ""
    ```

:::
::: {.column width="30%"}


\vspace{1cm}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [project
      [CMakeLists.txt, file
      ]
      [src
        [CMakeLists.txt, file
        ]
      ]
    ]
  ]
\end{forest}

:::
:::::::::::::: 

## LOCAL VARIABLES - DIRECTORY SCOPE (IV)

\vspace{.5cm}

<!-- 
  include() does not create a new scope, can be used within the directory scope of the current CMakeLists.txt file 
-->
The `add_subdirectory()` command creates a new scope for processing that subdirectory's CMakeLists.txt file.

:::::::::::::: {.columns}
::: {.column width="70%"}

  <!--

  - Variable values are inherited by CMakeLists.txt files in sub directories

  - Accessible in subdirectories but not vice versa

  Scopes created by add_subdirectory() or custom function call

  - Local variables are limited to the scope of the current directory and its subdirectories
  
  -  Local variables defined this way have a scope limited to the current ... and everything below it (CMAKE_CXX_STANDARD goes in the top level CMakeLists.txt)


--> 

\vspace{.5cm}

<!--
  Subdirectories inherit variables from their parent scope
-->

- If required, a local variable's scope can be extended to the parent

    ```{.cmake style=cmakestyle}
    # project/CMakeLists.txt
    add_subdirectory(src)
    message(STATUS ${BAR}) # "bar"
    ```

    ```{.cmake style=cmakestyle}
    # project/src/CMakeLists.txt
    set(BAR "bar" PARENT_SCOPE)
    ```

:::
::: {.column width="30%"}


\vspace{1cm}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [project
      [CMakeLists.txt, file
      ]
      [src
        [CMakeLists.txt, file
        ]
      ]
    ]
  ]
\end{forest}

:::
:::::::::::::: 

## LOCAL VARIABLES - FUNCTION SCOPE 


\vspace{0.5cm}

- Local variables are also scoped by functions (not by macro) - same arguments as before apply

```{.cmake style=cmakestyle}  
# CMakeLists.txt file
function(test)
  set(TEST "42") 
  set(TEST_EXTEND "42" PARENT_SCOPE)
endfunction()

test()
message(STATUS ${TEST}) # ""
message(STATUS ${TEST_EXTEND}) # "42"
```

\alert{What about the rest like accessing a pre-defined variable? -> show that you can still read directory scoped variables}


## {.standout}

<!-- 
  This example shows that it is possible to introduce conditionals to control the execution
  flow in CMake. However, the current setup does not allow the toggles to be set from
  outside, that is, without modifying CMakeLists.txt by hand. In principle, we want to be
  able to expose all toggles to the user, so that configuration can be tweaked without
  modifying the code for the build system. 

  Too .. you would need to modify the CMakeLists.txt file directly.

  Local variables are used to handle internal logic. How do we expose configuration options to the end user?
-->

How can we enable users to adjust build configuration options without altering the CMakeLists.txt directly?

<!-- 
  This example shows that it is possible to introduce conditionals to control the execution
  flow in CMake. However, the current setup does not allow the toggles to be set from
  outside, that is, without modifying CMakeLists.txt by hand. In principle, we want to be
  able to expose all toggles to the user, so that configuration can be tweaked without
  modifying the code for the build system. We will show how to do that in a moment.
-->

## CACHE VARIABLES 

<!--
  
Cache variables are primarily intended as a customization point for developers. Rather than hardcoding the value in the CMakeLists.txt file as a normal variable, a cache variable can be used so that the developer can override the value without having to edit the CMakeLists.txt file. Cache variables can be set on the cmake command line or modified by interactive GUI tools without having to change anything in the project itself. Using these customization points, the developer can turn different parts of the build on or off, set paths to external packages, use different flags for compilers and linkers, and so on. Later chapters cover these and other uses of cache variables.
-->

\vspace{0.3cm}

<!--
  In the previous recipe, we introduced conditionals in a rather rigid fashion: by introducing variables with a given truth value hardcoded. This can be useful sometimes, but it prevents users of your code from easily toggling these variables. Another disadvantage of the rigid approach is that the CMake code does not communicate to the reader that this is a value that is expected to be modified from outside. The recommended way to toggle behavior in
  the build system generation for your project is to present logical switches as options in your CMakeLists.txt using the option() command.

  In addition to normal variables discussed in Section 6.1, “Variable Basics”, CMake also supports
cache variables. Unlike normal variables which have a lifetime limited to the processing of the
CMakeLists.txt file, cache variables are stored in the special file called CMakeCache.txt in the build
directory, and they persist between CMake runs. Once set, cache variables remain set until
something explicitly removes them from the cache.
Cache variables are primarily intended as a customization point for developers. Rather than hardcoding
the value in the CMakeLists.txt file as a normal variable, a cache variable can be used so that
the developer can override the value without having to edit the CMakeLists.txt file. Cache variables
can be set on the cmake command line or modified by interactive GUI tools without having to change
anything in the project itself. Using these customization points, the developer can turn different
parts of the build on or off, set paths to external packages, use different flags for compilers and
linkers, and so on. Later chapters cover these and other uses of cache variables.

Cache variables have more information attached to them than a normal variable, including a
nominal type and a documentation string. Both must be provided when setting a cache variable.
The docstring does not affect how CMake treats the variable. It is used only by GUI tools to provide
things like a tooltip or one-line description for the cache variable. The docstring should be short and
consist of plain text with no HTML markup. It can be an empty string.
CMake will always treat a variable as a string during processing. The type is used mostly to improve
the user experience in GUI tools
-->

**Cache variables** are primarily used to expose build configurations to the user. <!-- User controlled build options -->

\vspace{0.2cm}

- Defining a cache variable requires a special form of the `set` command

  ```{.cmake style=cmakestyle}  
  set(<variable> <value>... CACHE <type> <docstring>)
  ```

. . . 

- Unlike local variables you can ovveride default cache variable values from the CL
 
  ```{.cmake style=cmakestyle}  
  set(USE_LIBRARY OFF CACHE BOOL "Enable compilation into ...")
  message(STATUS "Compile sources into a library? ${USE_LIBRARY}") 
  ```

  ```{.bash style=bashstyle}
  $ cmake -B <...> -S <...> -D USE_LIBRARY:BOOL="ON" 
  . . . 
  -- Compiles sources into a library? ON
  . . .
  ```

<!-- 
  CACHE VARIABLES ARE PRIMARILY USED TO EXPOSE BUILD CONFIGURATION/CUSTOMISATION TO THE USER
-->

## CACHE VARIABLE TYPES

\vspace{.4cm}

```{.cmake style=cmakestyle}  
set(<variable> <value>... CACHE <type> <docstring>)
```

- Cache entries are `<type>`d and require a `<docstring>`:
  
<!--
    string <value> held by the variable conforms to one of the ways CMake represents booleans as strings ( )
-->

**BOOL**
  : corresponding string `<value>` can be **ON**/**OFF**, **TRUE**/**FALSE**, **1/0**, etc...

**STRING** 
  : an arbitrary string 

**PATH**
  : GUI tools present a dialog that selects a directory rather than a file

**FILEPATH**
  : a path to a file on disk <!--  GUI tools present a file dialog to the user for modifying the variable’s value. -->

**INTERNAL**
  : hidden from the user by GUI tools 
  <!--
    Internal cache variables are sometimes used to persistently record internal information by the project, such as caching the result of an intensive query or computation. 
  -->

\vspace{.2cm}

- These are only used by `cmake-gui` and `ccmake` to display the appropriate type of edit widget

<!-- 

## EXAMPLE: CACHE VARIABLES OF TYPE STRING

- You can override default cache variable values through the command line 
  
  ```{.cmake style=cmakestyle}  
  # CMakeLists.txt
  set(TRAFFIC_LIGHT "RED" CACHE STRING "Traffic light color")
  
  if(TRAFFIC_LIGHT MATCHES "RED")
    message(FATAL_ERROR "STOP")
  elseif(TRAFFIC_LIGHT MATCHES "GREEN")
    message(STATUS "GO")
  else()
    message(STATUS "ACCELLERATE")
  endif()
  ```

  ```{.bash style=bashstyle}
  $ cmake -B <...> -S <...> -D TRAFFIC_LIGHT="GREEN" 
  -- GO
  ```

-->

## BOOLEAN SPECIALISATION

<!-- 
  Setting a boolean cache variable is such a common need that CMake provides a separate command for it.
-->

\vspace{.3cm}

- Setting a boolean cache variable is such a common need that CMake provides a shortcut 
    
  ```{.cmake style=cmakestyle}  
  # set(USE_LIBRARY "OFF" CACHE BOOL "Build project with library")
  option(USE_LIBRARY "Build project with library" OFF)
  ```
<!-- 
  Setting a boolean cache variable is such a common need that CMake provides a separate command for it.
-->

- Another example: Enable CUDA language if required
    
  ```{.cmake style=cmakestyle}  
  # set(ENABLE_CUDA "OFF" CACHE BOOL "Build project with CUDA enabled")
  option(ENABLE_CUDA "Build project X with CUDA support" OFF)

  if(ENABLE_CUDA)
    enable_language(CUDA)
  endif()
  ```

  ```{.bash style=bashstyle}
  $ cmake -B <...> -S <...> -D ENABLE_CUDA=ON 
  -- nvcc .. missing output
  ```

## CACHE VARIABLES - GLOBAL SCOPE (?) 

- Unlike local variables, **cache variables have global scope** 


    \vspace{.5cm}

    ```{.cmake style=cmakestyle}  
    # CMakeLists.txt file
    function(test)
      set(TEST "42")  // ADD CACHE /..
      set(TEST_EXTEND "42" PARENT_SCOPE)
    endfunction()

    test()
    message(STATUS ${TEST}) # ""
    message(STATUS ${TEST_EXTEND}) # "42"
    ```

  
## CMAKECACHE.TXT


:::::::::::::: {.columns}
::: {.column width="45%"}

\vspace{1cm}

- Cache variables are stored in a file called **CMakeCache.txt** located in the top directory of the build tree 
<!--
  - Stores optional choices and provides a project global variable repository
-->

- The **CMakeCache.txt** file is a set of entries of the form 

    ```shell
    // docstring 
    KEY:TYPE=VALUE
    ```

- Cache variables persist across calls to `cmake`



:::
::: {.column width="55%"}

\begin{tikzpicture}[xscale=0.9, yscale=0.9, % Adjust the scale factors as needed
  state/.style={rectangle, rounded corners, draw=black, fill=blue!20, thick, minimum height=3em, minimum width=7em, text centered},
  file/.style={rectangle, draw=black, fill=yellow!20, thick, minimum height=3em, minimum width=7em, text centered, dashed},
  process/.style={rectangle, rounded corners, draw=black, fill=green!20, thick, minimum height=3em, minimum width=7em, text centered},
  circle state/.style={circle, draw=black, fill=black, thick, minimum size=.5cm, inner sep=0pt, text centered, font=\footnotesize\color{white}},
  line/.style={draw, thick, -{Latex[length=3mm, width=2mm]}},
  every node/.style={transform shape} % Ensures nodes are scaled properly
]

% Nodes
\node (cleanstate) [circle state] {};
\node (configure) [state, below=0.8cm of cleanstate] {configure};
\node (generate) [state, below=0.8cm of configure] {generate};
\node (build) [process, below=0.8cm of generate] {build};
\node (workingstate) [circle state, right=2cm of build, yshift=-0.5cm] {};
\node (cmakelists) [file, right=1.5cm of configure, yshift=1.5cm] {CMakeLists.txt};
\node (cmakecache) [file, right=1.5cm of configure, yshift=-1cm] {CMakeCache.txt};
\node (makefile) [file, right=1.5cm of generate, yshift=-1cm] {Makefile};
\node (binaries) [file, below=0.8cm of build] {binaries};

% Lines
\path [line] (cleanstate) -- (configure);
\path [line] (configure) -- (generate);
\path [line] (generate) -- (build);
\path [line] (build) -- (binaries);
\path [line] (configure) -- (cmakelists);
\path [line] (configure) -- (cmakecache);
\path [line] (cmakecache) -- (configure);
\path [line] (generate) -- (makefile);
\path [line] (makefile) -- (build);
\path [line] (workingstate) -- (build);

% New line from build to configure
\draw [line] (build.west) -- ++(-1,0) |- node[near start, above, align=center]{if CMakeLists.txt \\ changed} (configure.west);

% Labels
\node at (cleanstate.north) [above=.1cm] {clean state};
\node at (workingstate.south) [below=.1cm] {working state};

\end{tikzpicture}

\end{tikzpicture}

:::
:::::::::::::: 


## VARIABLES AND THE CACHE 

Dereferences look first for a local variable, then
in the cache if there is no local definition for a
variable
Local variables hide cache variables

<!-- 
  ## ENVIRONMENT VARIABLES 

  Although rarely useful, CMake also allows the value of environment variables to be retrieved and set using a modified form of the CMake variable notation. 



**READ**

```{.cmake style=cmakestyle}
if(DEFINED ENV{PATH}) # notice the missing $
  message(STATUS "PATH is set to: $ENV{PATH}")
endif()
```

**WRITE**

```{.cmake style=cmakestyle}
set(ENV{PATH} "$ENV{PATH}:/opt/myDir")
```



**\underline{Note}**
  Setting an environment variable like this only affects the currently running CMake instance. 
 
    As soon as the CMake run is finished, the change to the environment variable is lost. In particular, the change to the environment variable will not be visible at build time.

-->


<!-- 

## RECAP: VARIABLE SCOPE

\alert{MOST LIKELY WILL SKIP THIS SLIDE}

**Function**. In effect when a variable is set within a function: the variable will be visible within the function, but not outside.

**Directory**. In effect when processing a CMakeLists.txt in a directory: variables in the parent folder will be available, but any that is set in the current folder will not be propagated to the parent.

**Cache**. These variables are persistent across calls to cmake and available to all scopes in the project. Modifying a cache variable requires using a special form of the set function.

**Environment**

-->

# COMPILATION 

## CMAKE VARIABLES 

\vspace{.5cm}

CMake already defines a list of variables internally that can be used by the project

```{.bash style=bashstyle}
$ cmake --help-variable-list | wc -l
701 
```

Help on a single variable can be obtained by querying the built-in documentation

```{.bash style=bashstyle}
$ cmake --help-variable "CMAKE_<LANG>_COMPILER"
CMAKE_<LANG>_COMPILER
---------------------

The full path to the compiler for ``LANG``.

This is the command that will be used as the ``<LANG>`` compiler.  
. . . 
```

## SOME USEFUL CMAKE VARIABLES 

- Non user settable variables

  `CMAKE_HOST_SYSTEM_NAME`
    : Name of the OS CMake is running on

  `PROJECT_BINARY_DIR`
    : Full path to build directory for project (`-B`) 

  `CMAKE_CURRENT_LIST_DIR`
    : Full directory of the listfile currently being processed

\vspace{.3cm}

- User settable variables

  `CMAKE_<LANG>_COMPILER` 
    : The full path to the compiler for `LANG`

  `CMAKE_BUILD_TYPE`
    : Specifies the build type (`Debug`, `Release`, `RelWithDebInfo`, `MinSizeRel`)

  `CMAKE_Fotran_PREPROCESS`
    : Control whether the Fortran source file should be preprocessed

\vspace{.4cm}

[CMake Variables - Documentation](https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html) 

## SPECIFYING THE COMPILER 

CMake stores compilers for each language in the `CMAKE_<LANG>_COMPILER` variable, where `<LANG>` is any of the supported languages.

The user can set this variable in one of two ways:

1. [preferred] By using the `-D` option in the CLI

  ```{.bash style=bashstyle}
  $ cmake -B ./build -S <...> -D CMAKE_CXX_COMPILER:FILEPATH=clang++
  ```

2. By exporting the environment variable `CXX` (`CC`, `FC`) 
  
  ```{.bash style=bashstyle}
  $ env CXX=clang++ cmake -B ./build -S <...>
  ```

**Note:** We have here assumed that the additional compilers are available in the standard paths
where CMake does its lookups. If that is not the case, the user will need to pass the full path
to the compiler executable or wrapper.

<!-- 
  We recommend to set the compilers using the -D
  CMAKE_<LANG>_COMPILER CLI options instead of exporting CXX, CC, and
  FC. This is the only way that is guaranteed to be cross-platform and
  compatible with non-POSIX shells. It also avoids polluting your
  environment with variables, which may affect the environment for
  external libraries built together with your project.
-->

## SPECIFYING THE COMPILER (Cont.)

CMake caches the compiler for a build directory on the first invocation...

```{.bash style=bashstyle}
$ cmake -B ./build -S <...> -DCMAKE_CXX_COMPILER:FILEPATH=$(which clang++)
-- The CXX compiler identification is Clang 14.0.0
-- Detecting CXX compiler ABI info
...
-- Detecting CXX compile features - done
-- Configuring done (0.9s)
-- Generating done (0.0s)
-- Build files have been written to: <>./build
```

. . . 

... such that on a second invocation 

```{.bash style=bashstyle}
$ cmake -B ./build -S <...>
-- Configuring done (0.0s)
-- Generating done (0.0s)
-- Build files have been written to:<>/build
```

## SPECIFYING THE COMPILER (Cont.)

You can verify which compiler has been cache either by inspecting the `CMakeCache.txt` file directly or by printing Cache variables to screen with the flag `-LAH`

```{.bash style=bashstyle}
$ cmake -B ./build -S <...> -LAH | grep "CMAKE_CXX_COMPILER"
CMAKE_CXX_COMPILER:FILEPATH=/usr/bin/clang++
```

where 

- `-L`: lists all the variables in the CMake cache
- `-LA`: lists all the variables in the CMake cache as well as advanced ones
- `-LAH`: lists all the variables in the CMake cache as well as advanced ones with the docstring

## SETTING THE STANDARD 

<!--
  Programming languages have different standards available, that is, different versions that
  offer new and improved language constructs. Enabling new standards is accomplished by
  setting the appropriate compiler flag.
-->

- Setting the C++ standard is often a decision driven by the project's code requirements.

- CMake offers a platform- and compiler-independent mechanism for setting the language standard for `CXX`
and `C`:

  ```{.cmake style=cmakestyle}
  # myProject/CMaleLists.txt
  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
  set(CMAKE_CXX_EXTENSIONS OFF)
  ```

  ```{.bash style=bashstyle}
  @[ 50%] Building CXX object main.cxx.o@
  /usr/bin/c++ -std=gnu++17 -o main.o -c main.cpp
  ```


## SETTING THE STANDARD (Cont.)

`CMAKE_CXX_STANDARD` 
  : mandates the standard that we would like to have.

`CXX_STANDARD_REQUIRED` 
  : specifies that the version of the standard chosen is required. If this version is not available, CMake will stop configuration with an error. When this property is set to OFF, CMake will look for next latest version of the standard, until a proper flag has been set. This means to first look for `C++14`, then `C++11`, then `C++98`.

`CXX_EXTENSIONS` 
  : tells CMake to only use compiler flags that will enable the ISO C++ standard, without compiler-specific extensions.

## COMPILATION FLAGS

<!--
  Sometimes you may want to set compiler-specific flags or override the default CMake behavior from the command line. This can be useful for enabling optimizations, warnings, or other compiler-specific features.
-->

- Setting the `CMAKE_CXX_FLAGS` CMake cache variable from the command line allows for customisation of compiler-specific options.

- This can be useful for enabling optimisations, warnings, or other compiler-specific features:

  ```{.bash style=bashstyle}
  $ cmake -B <build-tree> -S <source-tree> \
              -DCMAKE_CXX_FLAGS="-O2 -Wall -Wextra"

  @[ 50%] Building CXX object main.cxx.o@
  /usr/bin/c++ -O2 -Wall -Wextra -o main.o -c main.cpp
  ```


## BUILD TYPES 

\vspace{.2cm}

CMake distinguishes between the following build types:


:::::::::::::: {.columns}
::: {.column width="30%"}

Debug
: 

Release
: 

RelWithDebInfo
: 

MinSizeRel
: 

::: 
::: {.column width="70%"}

```{.cmake style=cmakestyle}
include(CMakePrintHelpers)
cmake_print_variables(CMAKE_BUILD_TYPE
                      CMAKE_CXX_FLAGS
                      CMAKE_CXX_FLAGS_DEBUG
                      CMAKE_CXX_FLAGS_RELEASE)
```

:::
::::::::::::::


The build type can be selected on the command line


```{.bash style=bashstyle}
$ cmake -B ./build-rel -S <...> -D CMAKE_BUILD_TYPE:STRING=Release
-- CMAKE_BUILD_TYPE="Release" ; CMAKE_CXX_FLAGS="" ; 
CMAKE_CXX_FLAGS_DEBUG="-g" ; CMAKE_CXX_FLAGS_RELEASE="-O3 -DNDEBUG"
```

```{.bash style=bashstyle}
$ cmake --build ./build-rel
/usr/bin/c++ @-O3 -DNDEBUG@ CMakeFiles/main.dir/main.cpp.o -o main
```


<!-- 
```{.cmake style=cmakestyle}
# we default to Release build type
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release")
endif()
```
-->


<!-- 
## CACHE VARIABLES

- Cache variables are used to interact with the command line 
    ```{.bash style=bashstyle}
    $ cmake -D 
    ```

- Unlike local variables which have a lifetime limited to the processing of the CMakeLists.txt file, cache variables are stored in a special file called `CMakeCache.txt` in the build directory, and they persist between CMake runs. When you rerun the files generation stage, the cache is read in before starting

- Once set, cache variables remain set until something explicitly removes them from the cache.

- In a build, cached variables are set in the command line or in a graphical tool (such as ccmake, cmake-gui), and then written to a file called CMakeCache.txt.

- Things like the compiler location, as discovered or set on the first run, are cached.
-->

## CHECKING COMPILER FLAGS AS FROM THE WORKSHOP 

you might need to introduce modules as well

## CONTROLLING COMPILER DEPENDENT FLAGS

## CONTROLLING COMPILER FLAGS

I think these are cache variables

Compiler flags for different compilers 

```{.cmake style=cmakestyle}
set(CMAKE_CXX_STANDARD 17)

if(CMAKE_CXX_COMPILER_ID MATCHES Intel)
    set(CMAKE_CXX_FLAGS "-ip -xHOST")
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES GNU)
    set(CMAKE_CXX_FLAGS "-Ofast -march=native")
endif()
```

The above will the set the flags for the entire project

<!--

## Keypoints 

https://stackoverflow.com/questions/16851084/how-to-list-all-cmake-build-options-and-their-default-values


The primary workhorse is the -D option, which is used to define the value of a cache variable.
The normal set command only sets the cached variable if it is not already set - this allows you to override cached variables with -D. Try:


## CACHE VARIABLES

The primary workhorse is the -D option, which is used to define the value of a cache variable.

Cache variables have more information attached to them than a normal variable, including a nominal type and a documentation string. Both must be provided when setting a cache variable. The docstring does not affect how CMake treats the variable. It is used only by GUI tools to provide things like a tooltip or one-line description for the cache variable. The docstring should be short and consist of plain text with no HTML markup. It can be an empty string. CMake will always treat a variable as a string during processing. The type is used mostly to improve the user experience in GUI tools, with some important exceptions discussed later in this section.

This is why we care about cache variables which can not be changed - caching the results of an intensive query or computation.

There is a special case for handling values initially declared without a type on the cmake command line. If the project’s CMakeLists.txt file then tries to set the same cache variable and specifies a type of FILEPATH or PATH, then if the value of that cache variable is a relative path, CMake will treat it as being relative to the directory from which cmake was invoked and automatically convert it to an absolute path. This is not particularly robust, since cmake could be invoked from any directory, not just the build directory. Therefore, developers are advised to always include a type if specifying a variable on the cmake command line for a variable that represents some kind of path. It is a good habit to always specify the type of the variable on the command line in general anyway so that it is likely to be shown in GUI applications in the most appropriate form. It will also prevent one of the surprising behavior scenarios mentioned in the previous section.

Local variables work in this directory or below.
The main difference between a normal and a cache variable is that the latter can be ovveriden without having to edit the CMakeLists.txt file.
You can glob to collect files from disk, but it might not always be a good idea.
An important difference between normal and cache variables is that the set() command will only overwrite a cache variable if the FORCE keyword is present. When used to define cache variables without the FORCE keyword, the set() command conceptually acts more like set-if-not-set.
Cache variables allow the user to set variables and options which can be easily overriden from the command line without making changes to the CMakeLists.txt
Prefer to provide cache variables for controlling whether to enable optional parts of the build instead of encoding the logic in build scripts outside of CMake. Try to establish a variable naming convention early. For cache variables, consider grouping related variables under a common prefix followed by an underscore to take advantage of how CMake GUI groups variables based on the same prefix automatically. Also consider that the project may one day become a sub-part of some larger project, so a name beginning with the project name or something closely associated with the project may be desirable.


## Mark as advanced 

Advanced variables are not displayed in the
cache editors by default
- Allows for complicated, seldom changed
options to be hidden from users
- Cache variables of the INTERNAL type are
never shown in cache editors


-->


<!--
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
-->

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
-->
