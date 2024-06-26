---
aspectratio: 169
---

# VARIABLES 

## VARIABLES 

Three types of variables 

- Local 
- Cache 
- Environment 

## LOCAL VARIABLES 

:::::::::::::: {.columns}
::: {.column width="50%"}

<!--
  - A new user-defined local variable can be created with the `set` command

  -  Variable names are case sensitive, values can only contain [A-Za-z0-9_]
-->

- To create a user-defined local variable 

  ```{.cmake style=cmakestyle}
  set(LIB_NAME "geometry") 
  ```

::: 
::: {.column width="50%"}

- **Variables are all strings** 
    
  ```{.cmake style=cmakestyle}
  set(FOO "bar") # "bar"
  set(FOO bar)   # "bar"
  set(FOO 42)    # "42"
  ```

- **Lists are ; separated strings**
  ```{.cmake style=cmakestyle}
  set(FOO "1" "2" "3") # "1;2;3"
  set(FOO 1 2 3)       # "1;2;3" 
  ```
 
- **Variables are expanded using ${}**
  
  ```{.cmake style=cmakestyle}
  set(FOO "${BAR}")
  ```

<!-- 
  Multiple arguments will be joined as a semicolon-separated list to form the actual variable value to be set.
-->
:::
:::::::::::::: 

## LOCAL VARIABLES II

- Variables can be expanded with the `${}` operator

    ```{.cmake style=cmakestyle}
    # ... 

    set(LIB_NAME "geometry")

    # lists are a series of ; values 
    set(SRCS "circle.cpp;square.cpp") 

    add_library(${LIB_NAME} STATIC ${SRCS} geometry.hpp)

    add_executable(main main.cpp)
    target_link_libraries(main PRIVATE ${LIB_NAME})
    ```
- Be careful with variables which contain whitespace (PATH) 

<!--
    - CMake variables are always of string type
    - The cmake-gui, ccmake interpret them as other types
    - A `list` variable can be defined by providing it as a `;` separated strings
-->


## SCOPE

- Local variables defined this way have a scope limited to the current ... and everything below it (CMAKE_CXX_STANDARD goes in the top level CMakeLists.txt)


## LOCAL VARIABLES: SCOPE

One of the most confusing aspects of CMake is the scoping of variables. 

Function. In effect when a variable is set within a function: the variable will be visible within the function, but not outside.

Directory. In effect when processing a CMakeLists.txt in a directory: variables in the parent folder will be available, but any that is set in the current folder will not be propagated to the parent.

Cache. These variables are persistent across calls to cmake and available to all scopes in the project. Modifying a cache variable requires using a special form of the set function.

## CMAKE LANGUAGE STANDARD 

:::::::::::::: {.columns}
::: {.column width="50%"}

In our geometry example we used C++ features from the C17 standard

```c++
//hello.cpp
#include <cstdlib>
#include <iostream>

int main(){
  std::cout << "Hello World!\n";
  return EXIT_SUCCESS;
}
```

::: 
::: {.column width="50%"}

Certain variables are known internally to CMake

```{.cmake style=cmakestyle}
# ...

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library(geometry STATIC ${SRCS})

# ...
```

:::
::::::::::::::

. . . 

- Running the build in verbose mode we can see how the flag `-std=17` has been applied to all targets
    
    ```{.bash style=bashstyle}
    $ cmake --build ./build --verbose
    [50%] Building ....
    /usr/bin/c++ -std=gnu++11 -o main.cxx.o -c main.cxx
    ```

# CACHE VARIABLES

## CACHE VARIABLES

- Cache variables are used to interact with the command line 
    ```{.bash style=bashstyle}
    $ cmake -D 
    ```

- Unlike local variables which have a lifetime limited to the processing of the CMakeLists.txt file, cache variables are stored in a special file called `CMakeCache.txt` in the build directory, and they persist between CMake runs. When you rerun the files generation stage, the cache is read in before starting

- Once set, cache variables remain set until something explicitly removes them from the cache.

- In a build, cached variables are set in the command line or in a graphical tool (such as ccmake, cmake-gui), and then written to a file called CMakeCache.txt.

- Things like the compiler location, as discovered or set on the first run, are cached.

## CONTROLLING COMPILER DEPENDENT FLAGS

fdfd

## CMAKE PRE-DEFINED VARIABLES 

- CMake already defines a list of variables internally (170+)

    ```{.bash style=bashstyle}
    $ cmake --help-variable-list
    ...
    ```
- A few useful CMake defined variables
  
    `PROJECT_SOURCE_DIR`
    : folder to the top level `CMakeLists.txt` 

    `PROJECT_BINARY_DIR`
    : build folder (`-B`) for the project

    `PROJECT_CURRENT_LIST_DIR`
    : folder to the current `CMakeLists.txt` being processed

- Help on a sigle variable can be obtained by querying the built-in documentation

    ```{.bash style=bashstyle}
    $ cmake --help-variable PROJECT_BINARY_DIR
    ```

## CMAKE COMPILER SELECTION 

CMake caches the compiler for a build directory on the first invocation.
CMake compiler detection has the following preference
– env variables ( CC, CXX )
– cc and cxx path entries
– gcc and g++ path entries


## SETTING THE COMPILER    

## RELEASE AND DEBUG BUILDS 

CMake distinguishes between the following build types:

Debug
: fkdjf

Release
: dfdf 

RelWithDebInfo
: fdfdf

MinSizeRel
: fdfdj

The build type can be selected on the command line


```{.bash style=bashstyle}
$ cmake --help-variable PROJECT_BINARY_DIR
```

```{.cmake style=cmakestyle}
# we default to Release build type
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release")
endif()
```

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


## STANDOUT 

We have to include the variable type here, which we didn't have to do before (but we could have) - it helps graphical CMake tools show the correct options. The main difference is the CACHE keyword and the description. If you were to run cmake -L or cmake -LH, you would see all the cached variables and descriptions.

## INSTRUCTOR 

Cache variables are primarily intended as a customization point for developers. Rather than hardcoding the value in the CMakeLists.txt file as a normal variable, a cache variable can be used so that the developer can override the value without having to edit the CMakeLists.txt file. Cache variables can be set on the cmake command line or modified by interactive GUI tools without having to change anything in the project itself. Using these customization points, the developer can turn different parts of the build on or off, set paths to external packages, use different flags for compilers and linkers, and so on. Later chapters cover these and other uses of cache variables.

## ENVIRONMENT VARIABLES


## Keypoints 

https://stackoverflow.com/questions/16851084/how-to-list-all-cmake-build-options-and-their-default-values

Example; - setting the C++ standard is often a decision driven by the project's code requirements.

Setting Cache Values On The Command Line
Setting cache variables via the command line is an essential part of automated build scripts and anything else driving CMake via the cmake command.

Try the following:

Try setting a cached variable using -DMY_VARIABLE=something before the -P flag. Which variable is shown?
:::::::::::::::::::::::::::::::::::::: discussion

CMake allows cache variables to be manipulated directly via command line options passed to cmake. The primary workhorse is the -D option, which is used to define the value of a cache variable.

The normal set command only sets the cached variable if it is not already set - this allows you to override cached variables with -D. Try:

cmake -DMY_CACHE_VAR="command line" -P cache.cmake
There are certain situations where caching the results of an intensive query or computation would benefit the compilation times. In these situations, you can use the keyword INTERNAL, identical to STRING FORCE, which hides the variable from listings/GUIs. You can use FORCE to set a cached variable even if it already set; this should not be very common. Since cached variables are global, sometimes they get used as a makeshift global variable.

Note

What is the different behaviour that you observe from the previous challenge?

The reason why the previous ovveriding of a normal variable did not work lies with an important point: normal and cache variables are two separate things. It is possible to have a normal variable and a cache variable with the same name, but holding different values.

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: callout

Since bool cached variables are so common for builds, there is a shortcut syntax for making one using [option][]:

option(MY_OPTION "On or off" OFF)
::::::::::::::::::::::::::::::::::::::::::::::::::

Environment variables
Although rarely useful, CMake also allows the value of environment variables to be retrieved and set using a modified form of the CMake variable notation. The following example shows how to retrieve and set an environment variable:

set(ENV{PATH} "$ENV{PATH}:/opt/myDir")
You can check to see if an environment variable is defined with if(DEFINED ENV{name}) (notice the missing $).

::::::::::::::::::::::::::::::::::::::::: callout

Note:
Setting an environment variable like this only affects the currently running CMake instance. As soon as the CMake run is finished, the change to the environment variable is lost. In particular, the change to the environment variable will not be visible at build time.

::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::: callout

Handy tip:
Use [include(CMakePrintHelpers)][CMakePrintHelpers] to add the useful commands cmake_print_properties and cmake_print_variables to save yourself some typing when debugging variables and properties.

::::::::::::::::::::::::::::::::::::::::::::::::::

Target properties and variables
You have seen targets; they have properties attached that control their behavior. Properties are a form of variable that is attached to a target; you can use [get_property][] and [set_property][], or [get_target_properties][] and [set_target_properties][] (stylistic preference) to access and set these. You can see a list of all properties by CMake version; there is no way to get this programmatically. Many of these properties, such as [CXX_EXTENSIONS][], have a matching variable that starts with CMAKE_, such as [CMAKE_CXX_EXTENSIONS][], that will be used to initialize them. So you can using set property on each target by setting a variable before making the targets.

::::::::::::::::::::::::::::::::::::::::: callout

More reading
Based on Modern CMake basics/variables
Also see CMake's docs
::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: instructor

Cache variables have more information attached to them than a normal variable, including a nominal type and a documentation string. Both must be provided when setting a cache variable. The docstring does not affect how CMake treats the variable. It is used only by GUI tools to provide things like a tooltip or one-line description for the cache variable. The docstring should be short and consist of plain text with no HTML markup. It can be an empty string. CMake will always treat a variable as a string during processing. The type is used mostly to improve the user experience in GUI tools, with some important exceptions discussed later in this section.

This is why we care about cache variables which can not be changed - caching the results of an intensive query or computation.

INTERNAL The variable is not intended to be made available to the user. Internal cache variables are sometimes used to persistently record internal information by the project, such as caching the result of an intensive query or computation. GUI tools do not show INTERNAL variables. INTERNAL also implies FORCE.

There is a special case for handling values initially declared without a type on the cmake command line. If the project’s CMakeLists.txt file then tries to set the same cache variable and specifies a type of FILEPATH or PATH, then if the value of that cache variable is a relative path, CMake will treat it as being relative to the directory from which cmake was invoked and automatically convert it to an absolute path. This is not particularly robust, since cmake could be invoked from any directory, not just the build directory. Therefore, developers are advised to always include a type if specifying a variable on the cmake command line for a variable that represents some kind of path. It is a good habit to always specify the type of the variable on the command line in general anyway so that it is likely to be shown in GUI applications in the most appropriate form. It will also prevent one of the surprising behavior scenarios mentioned in the previous section.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: keypoints

Local variables work in this directory or below.
The main difference between a normal and a cache variable is that the latter can be ovveriden without having to edit the CMakeLists.txt file.
You can glob to collect files from disk, but it might not always be a good idea.
An important difference between normal and cache variables is that the set() command will only overwrite a cache variable if the FORCE keyword is present. When used to define cache variables without the FORCE keyword, the set() command conceptually acts more like set-if-not-set.
Cache variables allow the user to set variables and options which can be easily overriden from the command line without making changes to the CMakeLists.txt
Prefer to provide cache variables for controlling whether to enable optional parts of the build instead of encoding the logic in build scripts outside of CMake. Try to establish a variable naming convention early. For cache variables, consider grouping related variables under a common prefix followed by an underscore to take advantage of how CMake GUI groups variables based on the same prefix automatically. Also consider that the project may one day become a sub-part of some larger project, so a name beginning with the project name or something closely associated with the project may be desirable.
::::::::::::::::::::::::::::::::::::::::::::::::::

modern-cmake/episodes/03-variables.md at main · mredenti/modern-cmake

## IMPORTANT

known extensions to CMake: .c .C .c++ .cc .cpp .cxx .cu .mpp .m .M .mm .ixx .cppm .h
  .hh .h++ .hm .hpp .hxx .in .txx .f .F .for .f77 .f90 .f95 .f03 .hip .ispc

## {.standout}

However, this will set the flags for the entire project. If you want fine-grained control, a nicer way is to define compile flags per target like in this example (here we want to lower the optimization level for mytarget to -O1):


## CMAKECACHE.TXT

Stores optional choices and provides a project global variable repository
- Variables are kept from run to run
- Located in the top directory of the build tree
- A set of entries like this:
– KEY:TYPE=VALUE
- Valid types:
– BOOL
– STRING
– PATH
– FILEPATH
– INTERNAL
(these are only used by cmake-gui and ccmake to display the appropriate type
of edit widget)

## Variables and the Cache

Dereferences look first for a local variable, then
in the cache if there is no local definition for a
variable
Local variables hide cache variables


## Mark as advanced 

Advanced variables are not displayed in the
cache editors by default
- Allows for complicated, seldom changed
options to be hidden from users
- Cache variables of the INTERNAL type are
never shown in cache editors

## CMake SPECIAL VARIABLES 

cmake --help-variables or online docs

User settable variables
– BUILD_SHARED_LIBS
– CMAKE_INSTALL_PREFIX
– CMAKE_CXX_FLAGS / CMAKE_<LANG>_FLAGS

CMake pre-defined variables (should not be set by user code)
– WIN32, UNIX, APPLE, CMAKE_VERSION
– CMAKE_SOURCE_DIR, CMAKE_BINARY_DIR
– PROJECT_NAME
– PROJECT_SOURCE_DIR, PROJECT_BINARY_DIR