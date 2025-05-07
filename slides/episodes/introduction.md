---
title: Introduction to CMake
subtitle: Introduction to Build Systems and Package Managers in HPC
author: 
  - Michael Redenti 
  - Mandana Safari
institute: 
  - m.redenti@cineca.it 
  - m.safari@cineca.it 
date: \today
aspectratio: 169
---

# Outline 

## Agenda 

\vspace{.2cm}

| MORNING                                 | AFTERNOON                              |
| --------------------------------------- | -------------------------------------- |
| **09:00 - 09:30** Introduction to CMake | **13:00 - 14:00** CMake Targets        |
|                                         |                                        |
| **09:30 - 10:00** Creating a library    | **14:00 - 15:00** Finding Dependencies |
|                                         |                                        |
| **10:00 - 10:30** Practical session #1  | **15:00 - 15:30** Testing              |
|                                         |                                        |
| > **10:30 - 10:45** Coffe break <       | > **15:30 - 15:45** Coffe break <      |
|                                         |                                        |
| **10:45 - 11:30** Variables             | **15:45 - 17:00** Practical session #3 |
|                                         |                                        |
| **11:30 - 12:00** Practical session #2  |                                        |



<!-- 




\centering 

**OBJECTIVE** Spend time on software development, not on software building!

## CHALLENGES WITH TRADITIONAL BUILD SYSTEMS FOR LARGE SCALE PROJECTS


GNU Make
  : Complications with large projects 
  
    you can not just use Bash. In fact you can write make target recipes in any scripting language you want.

    Development and maintenance of Makefiles can become very complicated as the project grows (error prone to deal with thousands of files and dependencies) 

    Structuring Makefiles for a huge project is possible but very time consuming

    Often see developing and maintaining multiple Makefiles targeting a specific platform or even compiler toolchain
 
  : Platform dependence 
 
    Make does not know which compiler (options) we want and which environment we are on.

    OS specific commands (ls, grep, dir, ..., slash, backslash) will not port.
    
    Surely one can hack their ways to achieve portabilty but GNU Make alternatives: NMake (Visual Studio) where shell commands are obviously targeted at Windows
  : Manual Dependency Management
   
    Developers must manually handle dependencies, which can lead to errors and maintenance challenges. 
    If the project grows, maintaining these dependencies manually becomes error-prone and cumbersome.

    In CMake, dependency management is handled automatically.
 
  All of the above approached poorly integrate with IDEs and 
  cross-platform or IDE integrations would require manual updates across different build tools and IDEs respective configuration files

  CMake is particularly favored for its cross-platform capabilities and ease of managing complex projects. GNU Make remains a staple in Unix-like environments for its simplicity and power. 


. . . 

\hspace{0.5cm}

 
    I am not sure this is true : Limited to Unix platforms : Generates only Makefiles


Autotools  a.k.a. Autohell 

  : Complex manual scripts (Bourne shell, m4) 
 Long, difficult to understand scripts 

  : Poor IDE integration

  : Maintenance Overhead
  
 
    Keeping the Autotools scripts up to date and working correctly can require significant maintenance effort.

    Manual ordering of Fortran module files 

  

    You need to make sure that the module files are created before they are referenced 
 

-->

## WHY CMAKE

\begin{center}
    \includegraphics[width=1.2\paperwidth,height=0.8\paperheight]{./fig/GoogleTrends.png}
\end{center}


# WHAT IS CMAKE?

## WHAT IS CMAKE?

\begin{tikzpicture}[remember picture,overlay]
\node[anchor=north east,inner sep=0pt, xshift=.3cm, yshift=-0.8cm] at (current page.north east) {
  \href{http://www.example.com}{\includegraphics[width=4cm]{./fig/Logo_Kitware.png}}
};
\end{tikzpicture}

<!-- 
 ... that provides a family of software development tools

 - Build System Generator => it generates files, it does not build
 
- Dependency discovery is awesome (find_package())
- Can not overcome the limitations of the underlying IDEs
-->

**C**ross Platform **Make** is an open-source **build system generator** (\underline{not a build system!}).

<!-- 
   CTest is an executable that comes with CMake; it handles running the tests for the project. While CTest works well with CMake, you do not have to use CMake in order to use CTest. The main input file for CTest is called CTestTestfile.cmake. This file will be created in each directory that was processed by CMake (typically every directory with a CMakeLists file).
-->

\vspace{.4cm}

It is a family of software development tools:

\vspace{.1cm}

- **CMake** can generate build files for multiple build systems (Make, Ninja, Visual Studio, ...) and supports several languages (**C/C++**, **Fortran**, CUDA, HIP, C#, ...)

\vspace{.1cm}

- **CTest** is a test scheduling and reporting tool that handles the tests for the project

\vspace{.1cm}

- **CPack** is a cross-platform software packaging tool distributed with CMake <!-- Users of your software may not always want to, or be able to, build the software in order to install it. The software may be closed source, or it may take a long time to compile, or in the case of an end user application, the users may not have the skill or the tools to build the application. For these cases, what is needed is a way to build the software on one machine, and then move the install tree to a different machine.  CPack can create two basic types of packages, source and binary. With source packages, CPack makes a copy of the source tree and creates a zip or tar file. -->

\vspace{.3cm}

Version 3.0 was released in June 2014 and signals the beginning of **Modern CMake**.


<!-- 
  Let developers use the IDE and tools they are most familiar with, they are not going to be as productive if you force them to use the command line

  Nonostante the rich C++ ecosystem that is out there with various vendors creating IDEs, compilers, architecture but you can still express your build in one tool
-->


<!-- 
  CMake generates native makefiles and workspaces that can be used in the compiler environment of your choice

  Enable building (CMake), testing (CTest, CDash) and packaging (CPack) of software
-->

<!-- 
## CMAKE'S POSITION AMONG BUILD SYSTEMS

standalone
  : Make, NMake, SCons, Ninja

integrated
  : Visual Studio, Xcode, Eclipse

generators
  : Autotools (a.k.a. Autohell), **CMake**, Meson, Bazel
-->



## CMAKE FEATURES 

<!-- 

## WHY SHOULD YOU USE CMAKE 

- You want to avoid hard-coding paths

- You need to build a package on more than one computer
- You want to use CI (continuous integration)
- You need to support different OSs (maybe even just flavors of Unix)
- You want to support multiple compilers
- You want to use an IDE, but maybe not all of the time
- You want to describe how your program is structured logically, not flags and commands
- You want to use a library
- You want to use tools, like Clang-Tidy, to help you code
- You want to use a debugger

-->

\vspace{.3cm}

:::::::::::::: {.columns}
::: {.column width="50%"}

**Open Source**

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

<!--

  High-Level Abstractions: CMake provides commands and functions that abstract complex build tasks. For example, add_executable is a high-level command that simplifies the process of defining an executable target.

  Ease of Use: Writing CMake scripts is generally straightforward, focusing on specifying what to build and how, without delving into the details of the build system being generated.

  Importance of Order in CMakeLists.txt
  In scripting languages, the order of commands can be crucial because the interpreter executes them sequentially. This is also true for CMake:

  Sequential Execution: Commands in CMakeLists.txt are executed in the order they appear. This means that each command can depend on the results of the commands that preceded it.
  Dependencies and Definitions: If a command relies on a variable or target defined by a previous command, changing the order could result in errors or unexpected behavior.
  Scope and Visibility: The scope of variables and targets can be influenced by their position in the script. For example, a variable defined within a function or block may not be accessible outside of it.


  perhaps add support with google test and dynamic analysis - general support for test frameworks, static and dynamic analysis of your code
-->


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

:::
::::::::::::::
  

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



