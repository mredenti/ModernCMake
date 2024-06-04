---
aspectratio: 169
---

# CMAKE LANGUAGE OVERVIEW 

## CMAKE LANGUAGE OVERVIEW (I)

\vspace{.5cm}

:::::::::::::: {.columns}
::: {.column width="50%"}

**Command based, one per line** 

```{.cmake style=cmakestyle}
set(FOO "bar")
add_executable(foo bar.cpp)
if(FOO)
```

\vspace{.2cm}

**Commands do not return values, no nesting**

\vspace{.2cm}

**Commands may have arguments and overloads** 

```{.cmake style=cmakestyle}
file(WRITE <file> <content>)
file(READ <file> <variable>)
```

\vspace{.2cm}

**Variables are defined with the command `set()`**

\vspace{.7cm}

[CMake Language - Documentation](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html) 

:::
::: {.column width="50%"}

**Variables are all strings**

```{.cmake style=cmakestyle}
set(FOO "a")
set(FOO a)
set(FOO 42)
```

\vspace{.2cm}

**Lists are semicolon-separated strings**

```{.cmake style=cmakestyle}
set(FOO "a;b;c")
set(FOO a b c)
list(APPEND FOO "d") 
```


\vspace{.2cm}

**Variables are read using `${}`**

```{.cmake style=cmakestyle}
message(${FOO}) # FOO="a;b;c;d"
```

:::
::::::::::::::


## CMAKE LANGUAGE OVERVIEW (II)

\vspace{.2cm}

:::::::::::::: {.columns}
::: {.column width="50%"}

**Control flow**

```{.cmake style=cmakestyle}
if() / elseif() / else() / endif()
```

```{.cmake style=cmakestyle}
foreach() / endforeach()
```

```{.cmake style=cmakestyle}
while() / endwhile()
```

```{.cmake style=cmakestyle}
break() / continue()
```

\vspace{.2cm}

**Comments start with #**

```{.cmake style=cmakestyle}
# I am a single line comment
```

:::
::: {.column width="50%"}

**Read another CMake file in the same context**

```{.cmake style=cmakestyle}
include(<file>)
```

\vspace{.2cm}


**Read another `CMakeLists.txt` file in `<dir>` in a new context**

```{.cmake style=cmakestyle}
add_subdirectory(<dir>)
```

\vspace{.2cm}

**Print a message**
<!-- 
  Usefule for displaying status, progress, warning or errors 
-->

```{.cmake style=cmakestyle}
message(<text>)
```

:::
::::::::::::::

## CMAKE LANGUAGE OVERVIEW (III)

<!--
  Looking back on the material covered in this book so far, CMake’s syntax is already starting to look
  a lot like a programming language in its own right. It supports variables, if-then-else logic, looping
  and inclusion of other files to be processed. It should be no surprise to learn that CMake also
  supports the common programming concepts of functions and macros too. Much like their role in
  other programming languages, functions and macros are the primary mechanism for projects and
  developers to extend CMake’s functionality and to encapsulate repetitive tasks in a natural way.
  They allow the developer to define reusable blocks of CMake code which can be called just like
  regular built-in CMake commands. They are also a cornerstone of CMake’s own module system
-->

\vspace{.5cm}

:::::::::::::: {.columns}
::: {.column width="50%"}

**FUNCTIONS**


**Defined using the `function()` command**

```{.cmake style=cmakestyle}
function(name [arg1 [arg2 [...]]])
# Function body (i.e. commands) ...
endfunction()
```

\vspace{.2cm}

**Example**

```{.cmake style=cmakestyle}
function(func_name arg1 arg2)
  message("Argument 1: ${arg1}")
  message("Argument 2: ${arg2}")
endfunction()

func_name("value1" "value2")
```

:::
::: {.column width="50%"}

. . . 

**MACROS**

**Defined using the `macro()` command**

```{.cmake style=cmakestyle}
macro(name [arg1 [arg2 [...]]])
# Macro body (i.e. commands) ...
endmacro()
```

\vspace{.2cm}

**Example** - please show the scope difference in the example

```{.cmake style=cmakestyle}
macro(macro_name arg1 arg2)
  message("Argument 1: ${arg1}")
  message("Argument 2: ${arg2}")
endmacro()

macro_name("value1" "value2")
```

:::
::::::::::::::

## MODULES 

\vspace{.5cm}

<!-- 
Code reuse is a valuable technique in software development and CMake has been designed to support it.
-->

- CMake **Modules** extend the functionality of the language by providing predefined `.cmake` scripts that simplify complex tasks. <!-- collect common functionality -->

```{.bash style=bashstyle}
$ ls $CMAKE_PREFIX_PATH/share/cmake-3.27/Modules/cmake
FindMPI.cmake
CheckCXXCompilerFlag.cmake
...(+267)
```
- **Modules** can then be included into other CMakeLists files using the `include()` command.

- **Example:** Check whether the CXX compiler supports a given flag
```{.cmake style=cmakestyle}
include(CheckTypeSize)
check_type_size(long SIZEOF_LONG)
```

<!-- 
  Example: `Find<Package>.cmake` modules help in locating and configuring and external dependency to be used by the project.
-->


add a link to the documentation 

<!-- 

  ## The complexity of the build process (compiled languages (C/C++/Fortran))
  
  Compilers, linkers, testing frameworks, packaging systems, and more contribute to the complexity of deploying high-quality, robust software. 

  Computers cannot execute such a source file, they must be translated into binary processor instructions first. Thus, next step is to feed this program to a compiler, which does this translation for us. There is a multitude of ways of doing that, depending on the compiler. The compiler then takes the source file and “compiles” it into an executable program which you can then start.

  More complex programs will usually consist of multiple C++ files which are then separately compiled into intermediate output files (usually with a .o or .obj extension) and then “linked” together by a program called linker to an executable. In fact, even if just a single source file is compiled into an executable, the compiler automatically invokes the linker behind the scenes.

![](./fig/BuildProcess.png)  

-->



## RECOMMENDATION: USE THE BUILT IN DOCUMENTATION!

\centering \textbf{The CMake language is \underline{\textit{(too)}} rich in features and capabilities!}

\raggedright

\vspace{0.3cm}

**COMMANDS** 

```{.bash style=bashstyle}
$ cmake --help-command-list | wc -l
128
```

\vspace{0.1cm}

```{.bash style=bashstyle}
$ cmake --help-command include
include
-------
Load and run CMake code from a file or module.

 include(<file|module> [OPTIONAL] [RESULT_VARIABLE <var>]
                       [NO_POLICY_SCOPE])

If ``OPTIONAL`` is present, then no error is raised if the file 
does not exist.
...
```

## RECOMMENDATION: USE THE BUILT IN DOCUMENTATION!

\centering \textbf{The CMake language is \underline{\textit{(too)}} rich in features and capabilities!}

\raggedright

**MODULES** 
<!-- 
  A multitude of variables control the build process or extract information about the host system
-->

```{.bash style=bashstyle}
$ cmake --help-module-list | wc -l
269
```

```{.bash style=bashstyle}
$ cmake --help-module CheckCXXCompilerFlag

```




<!--
  The add_subdirectory command allows a project to be separated into directories

  CMake is a declarative language which contains 90+ commands. It contains general purpose constructs: set , unset, if , elseif , else , endif, foreach, while, break
-->


## BUILD SYSTEM GENERATOR

<!--
  CMake is a tool designed to help you build and test your software. It is now more popular than ever and is now supported by some major IDEs and libraries, including Android Studio, CLion, QtCreator or Visual Studio.

  Let's cover the basics, understand how CMake works and how to write modern and extensible cross-platform build scripts with CMake.

  CMake as a Scripting Language
  CMake is a tool designed to manage the build process of software projects. It uses a scripting language to define the build process in CMakeLists.txt files. Here’s how it fits the characteristics of a scripting language:

  Interpreted Execution: CMake processes the CMakeLists.txt files line by line to generate build instructions (e.g., Makefiles or Visual Studio project files).
-->

CMake uses **a scripting language to define the build process** in **CMakeLists.txt** files, which are processed to generate project files for major IDEs and build systems

:::::::::::::: {.columns}
::: {.column width="5%"}

::: 
::: {.column width="85%"}

```plantuml
left to right direction
skinparam PackagePadding 2
skinparam BoxPadding 2
skinparam NodePadding 2
skinparam style strictuml
skinparam padding 0
scale 0.8

skinparam rectangle {
  BackgroundColor<<Windows>> LightBlue
  BackgroundColor<<macOS>> LightBlue
  BackgroundColor<<Linux>> LightBlue
  BackgroundColor<<Tool>> Green
}

skinparam Arrow {
  Color Black
}

file "CMakeLists.txt" as ST
rectangle "CMake" as CM #Pink

collections ".sln files" as VS <<Windows>> #FEFECE
collections "XCode" as XC <<macOS>> #FEFECE
collections "Makefiles" as MK <<Linux>> #FEFECE

rectangle "Make" as make #Pink
rectangle "xcode" as xcode #Pink
rectangle "visual-studio" as visual #Pink

ST --> CM

CM --> VS
CM --> XC
CM --> MK

MK <-- make 
XC <-- xcode
VS <-- visual
```

::: 
::: {.column width="10%"}

:::
:::::::::::::: 
