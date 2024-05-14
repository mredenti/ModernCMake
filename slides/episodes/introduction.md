---
title: Modern CMake
subtitle: Introduction to Build Systems (Generators) and Package Managers in HPC
author: Michael Redenti \and Mandana Safari
institute: m.redenti@cineca.it \and m.safari@cineca.it 
date: \today
aspectratio: 169
---

## WHY DO WE NEED A GOOD BUILD SYSTEM 

<!-- 
  Modern build systems should be able to build the software, package it, test it
 
  The choice for a particular build system should be guided by 
  the following idea: 
    every moment a developer spends writing or debugging build definitions is a second wasted. So is every second spent waiting for the build system to actually start compiling code.
-->

\centering 

**Spend time on software development, not on software building!**

## TRADITIONAL BUILD SYSTEMS - CHALLENGES


GNU Make
  : Complications with large projects 
  <!-- 
    Development and maintenance of Makefiles can become very complicated as the project grows (error prone to deal with thousands of files and dependencies) 

    Structuring Makefiles for a huge project is possible but very time consuming

    Often see developing and maintaining multiple Makefiles targeting a specific platform or even compiler toolchain
  -->
  : Lack of portability 
  <!-- 
    Make does not know which compiler (options) we want and which environment we are on.

    OS specific commands (ls, grep, dir, ..., slash, backslash) will not port.
    
    Surely one can hack their ways to achieve portabilty but GNU Make alternatives: NMake (Visual Studio) where shell commands are obviously targeted at Windows -->
  : Need to tell Make what  

<!--
  All of the above approached poorly integrate with IDEs and 
  cross-platform or IDE integrations would require manual updates across different build tools and IDEs respective configuration files
-->



. . . 

\hspace{0.5cm}

<!-- 
    I am not sure this is true : Limited to Unix platforms : Generates only Makefiles
-->

Autotools <!-- a.k.a. Autohell -->

  : Complex manual scripts (Bourne shell, m4) 
  <!-- Long, difficult to understand scripts -->

  : Poor IDE integration

  : Manual ordering of Fortran module files 
  <!-- 
    You need to make sure that the module files are created before they are referenced 
  -->

  : Manual dependency discovery 



# INTRODUCTION TO CMAKE

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

- **C**ross Platform **Make** is an open-source **build system generator**.

- It uses a scripting language to define the build process in **CMakeLists.txt** files, which are processed to generate project files for major IDEs and build tools.

<!-- 
  Let developers use the IDE and tools they are most familiar with, they are not going to be as productive if you force them to use the command line

  Nonostante the rich C++ ecosystem that is out there with various vendors creating IDEs, compilers, architecture but you can still express your build in one tool
-->


- Family of tools 
  - Build $\Rightarrow$ **CMake**
  - Test $\Rightarrow$ **CTest, CDash**
  - Package $\Rightarrow$ **CPack**

<!-- 
  CMake generates native makefiles and workspaces that can be used in the compiler environment of your choice

  Enable building (CMake), testing (CTest, CDash) and packaging (CPack) of software
-->

:::::::::::::: {.columns}
::: {.column width="5%"}


:::
::: {.column width="50%"}

\vspace{-2.5cm}
\hspace{-5cm}

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
  BackgroundColor<<Tool>> Pink
}

skinparam Arrow {
  Color Black
}

file "CMakeLists.txt" as ST
rectangle "CMake" as CM #Pink

collections "Visual Studio" as VS <<Windows>> #LightBlue
file "XCode" as XC <<macOS>> #LightBlue
file "Make" as MK <<Linux>> #LightBlue

ST --> CM

CM --> VS
CM --> XC
CM --> MK
```

:::
::::::::::::::


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

- **C**ross Platform **Make** is an open-source **build system generator**.

- It uses a scripting language to define the build process in **CMakeLists.txt** files, which are processed to generate project files for major IDEs and build tools.

<!-- 
  Let developers use the IDE and tools they are most familiar with, they are not going to be as productive if you force them to use the command line

  Nonostante the rich C++ ecosystem that is out there with various vendors creating IDEs, compilers, architecture but you can still express your build in one tool
-->


- Family of tools 
  - Build $\Rightarrow$ **CMake**
  - Test $\Rightarrow$ **CTest, CDash**
  - Package $\Rightarrow$ **CPack**

- Version 3.0 was released in June 2014 and signals the beginning of "Modern CMake".

## CMAKE POPULARITY/WHO ELSE IS USING CMAKE

interest over time and its relevance as the predominant build systems in C++ projects


**CMAKE'S POSITION AMONG BUILD SYSTEMS**

standalone
  : Make, NMake, SCons, Ninja

integrated
  : Visual Studio, Xcode, Eclipse

generators
  : Autotools (a.k.a. Autohell), **CMake**, Meson, Bazel

## CMAKE FEATURES 

:::::::::::::: {.columns}
::: {.column width="50%"}

**Cross-platform** (Linux, Windows, macOS, ...)

\vspace{0.2cm}

**Open Source**

\vspace{0.2cm}

**Multiple Generators**

- Makefiles (Unix, NMake, Borland, ...)
- Ninja
- Microsoft Visual Studio (.sln)
- Eclipse
- Xcode

\vspace{0.2cm}


**Direct CMake integration with IDEs** 

  - Microsoft Visual Studio 2017...20??
  - JetBrains CLion


:::

. . . 

::: {.column width="50%"}

**CMake scripting language**

\vspace{0.2cm}

**Dependency discovery made easy**

- `find_package()`

\vspace{0.2cm}

**Automatic chaining of library dependency information**

\vspace{0.2cm}


**Compiler language level support**

- C, C++, Fortran, CUDA, HIP, ...

\vspace{0.2cm}

**Fortran Module Order**  

<!-- 
  Automatic ordering of Fortran files based on `use` statements in the code for a library

  CMake is an open-source project that serves as a tool for building, testing, packaging, and distributing cross-platform software
    CMake is a scripting language written in C++
    CMake is a de facto industry standard for building C++ projects
    CMake is divided into 3 command-line tools:
    cmake: for generating compiler-independent build instruction
    ctest: for detecting and running tests
    cpack: for packing the software project into convenient installers
-->

:::
::::::::::::::
  
## CMAKE LANGUAGE OVERVIEW 



## History

## Key Features

Build System Generator 

Compiler indipendent configuration files 

Uses CMake language

- Automatic dependency generation 
- Automatic chaining of library dependency information
- Dependency discovery is awesome (find_package())
- **Single description file** generate builds for many build systems and platforms from one description file 
- **Integration** easy to build end-to-end build systems using CTest and CPack
- It's platform- and - compiler-agnostic, allowing reuse of CMake scripts across different platforms.
- facilitate generation of files for different build systems across various platforms and IDEs
- automatically track and propagate internal dependencies


## CMake High Level View

:::::::::::::: {.columns}
::: {.column width="60%"}
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
  BackgroundColor<<Tool>> Pink
}

skinparam Arrow {
  Color Black
}

file "CMakeLists.txt" as ST
rectangle "CMake" as CM #Pink

collections "Visual Studio" as VS <<Windows>> #LightBlue
file "XCode" as XC <<macOS>> #LightBlue
file "Make" as MK <<Linux>> #LightBlue

ST --> CM

CM --> VS
CM --> XC
CM --> MK
```
:::


::: {.column width="40%"}

```plantuml
skinparam rectangle {
    StrokeColor Black
    BackgroundColor White
}

rectangle "Source Tree" as ST
rectangle "CMake" as CMake
rectangle "Visual Studio" as VS
rectangle "Windows Binaries" as WB
rectangle "XCode" as XC
rectangle "macOS Binaries" as MB
rectangle "Make" as MK
rectangle "Linux Binaries" as LB

ST -down-> CMake : generates
CMake -right-> VS : for Windows
CMake -down-> XC : for macOS
CMake -left-> MK : for Linux
VS -down-> WB
XC -down-> MB
MK -down-> LB
```

:::
::::::::::::::


<!-- 

  ## The complexity of the build process (compiled languages (C/C++/Fortran))
  
  Compilers, linkers, testing frameworks, packaging systems, and more contribute to the complexity of deploying high-quality, robust software. 

  Computers cannot execute such a source file, they must be translated into binary processor instructions first. Thus, next step is to feed this program to a compiler, which does this translation for us. There is a multitude of ways of doing that, depending on the compiler. The compiler then takes the source file and “compiles” it into an executable program which you can then start.

  More complex programs will usually consist of multiple C++ files which are then separately compiled into intermediate output files (usually with a .o or .obj extension) and then “linked” together by a program called linker to an executable. In fact, even if just a single source file is compiled into an executable, the compiler automatically invokes the linker behind the scenes.

![](./fig/BuildProcess.png)  

-->

## CMAKE LANGUAGE




## 6. CMake's Relevance in HPC 

Color and progress output for make
- Graphviz output for visualizing dependency trees
- Full cross platform install() system
- Compute link depend information, and chaining of
dependent libraries
- make help, make foo.o, make foo.i, make foo.s
29

Discussion on how CMake fits into the software development process, its role in streamlining development, testing, deployment, and complex use cases like large-scale projects and cross-platform development.

# Workshop Outline and Setup

## Agenda

Overview of the workshop format which includes episodes with exercises, each teaching a CMake concept.


Detailed agenda with timings for each session, including breaks and Q&A sessions.

<!--
  ## Objectives

  Focus on modern CMake especially for HPC, building reliable projects in C/C++/Fortran, and best practices for using CMake in collaborative projects.
-->

**Skills Developed:**
- Writing maintainable build configuration files.
- Managing dependencies and libraries.
- Integrating CMake with CI/CD pipelines.

## Setup

<!-- 
  Details on required software installations, system configurations, how to access materials, and initial setup instructions.

-->


Logging into G100 Cineca cluster

```{.bash style=bashstyle}
$ ssh <username>@login.g100.cineca.it
```

Clone the exercises repository

```{.bash style=bashstyle}
$ git clone ...
```

Loading the cmake module

```{.bash style=bashstyle}
$ module load cmake/3.21.4
```




## Agenda 

Lunch Break
Episode 6: Advanced CMake Features
Generator expressions
Functions and Macros
Scripting in CMake
Exercise: Create a CMake macro for repetitive tasks.
Episode 7: Testing with CMake
Adding tests with CTest
Test-driven development with CMake
Exercise: Write and add several tests to the existing CMake project.
Episode 8: Installing and Packaging with CMake
Install commands
CPack for packaging
Exercise: Write CMake install rules and generate a package.
Episode 9: Managing Large Projects
Organizing a project with subdirectories
Interface libraries
Managing dependencies
Exercise: Refactor the project to use subdirectories.
Episode 10: Modern CMake Practices
Usage of modern CMake commands and targets
Avoiding common pitfalls
CMake project review and Q&A
Exercise: Participants review each other's CMake projects and provide feedback.
Conclusion and Wrap-Up
Recap of the workshop
Additional resources for further learning
Feedback and workshop evaluation


## Abstracting away the build tool
CMake also comes to our aid in helping us not have to deal with the platform differences of the build tool. The cmake --build option directs CMake to invoke the appropriate build tool for us, which allows us to specify the whole build something like this:

## More

CMake as a Scripting Language
CMake is a tool designed to manage the build process of software projects. It uses a scripting language to define the build process in CMakeLists.txt files. Here’s how it fits the characteristics of a scripting language:

Interpreted Execution: CMake processes the CMakeLists.txt files line by line to generate build instructions (e.g., Makefiles or Visual Studio project files).

High-Level Abstractions: CMake provides commands and functions that abstract complex build tasks. For example, add_executable is a high-level command that simplifies the process of defining an executable target.

Ease of Use: Writing CMake scripts is generally straightforward, focusing on specifying what to build and how, without delving into the details of the build system being generated.

Importance of Order in CMakeLists.txt
In scripting languages, the order of commands can be crucial because the interpreter executes them sequentially. This is also true for CMake:

Sequential Execution: Commands in CMakeLists.txt are executed in the order they appear. This means that each command can depend on the results of the commands that preceded it.
Dependencies and Definitions: If a command relies on a variable or target defined by a previous command, changing the order could result in errors or unexpected behavior.
Scope and Visibility: The scope of variables and targets can be influenced by their position in the script. For example, a variable defined within a function or block may not be accessible outside of it.


## Maybe 

add support with testing frameworks GoogleTest as well as static and dynamic analysis