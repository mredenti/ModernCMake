---
title: Modern CMake
subtitle: Introduction to Build Systems (Generators) and Package Managers in HPC
author: Michael Redenti \and Mandana Safari
institute: m.redenti@cineca.it \and m.safari@cineca.it 
date: \today
aspectratio: 169
---
 

# INTRODUCTION


## MOTIVATION 

<!-- 
  Modern build systems should be able to build the software, package it, test it
  Challenges of traditional build systems and the need for modern tools like CMake
-->

\centering 

**Spend time on software development, not on software building!**

## TRADITIONAL BUILD SYSTEMS - CHALLENGES

GNU Make (Build System)
  : Complications with large projects
  : OS specific command issues
  : portability challenges

\alert{Cross-platform development would require manual updates across different build tools and IDEs respective configuration files}

. . . 

Autotools (a.k.a. Autohell)
  : Limited to Unix
  : complex manual scripts
  : poor IDE integration


## NEED FOR MODERN TOOLS... CMAKE

a picture with google trends would probably suffice

## OLD

:::::::::::::: {.columns}
::: {.column width="50%"}

**GNU Make (Build System)**

<!-- 
  Essentially combines 3 languages: file dependencies, \alert{shell commands}, string processing
-->

- Development and maintenance of Makefiles can become very complicated as the project grows (error prone to deal with thousands of files and dependencies)
- Lack of portability - OS specific commands (ls, grep, dir, ..., slash, backslash) will not port 

<!-- 
- portability is still possible to achieve but very cumbersome
-->

- GNU Make alternatives: NMake (Visual Studio) where shell commands are obviously targeted at Windows 

:::

. . . 

::: {.column width="50%"}

**Autotools (a.k.a. Autohell)**

\begin{itemize}
\item hell
\end{itemize}

- Been used for many years 
- Need to write scripts in Bourne shell, m4
- Only on Unix platforms $\Rightarrow$ Visual Studio, ... are unsupported
- Dependency discovery is mostly manual
- Typically long, difficult to understand scripts
- Poor integration with IDEs (example)
- Generates only Makefiles



:::
::::::::::::::

## Base Rule of CMake 

- Let developers use the IDE and tools they are most familiar with, they are not going to be as productive if you force them to use the comman line

- Nonostante the rich C++ ecosystem that is out there with various vendors creating IDEs, compilers, architecture but you can still express your build in one tool
  
## WHY CMAKE?



## WHAT IS CMAKE?

<!-- 
 ... that provides a family of software development tools

 - Build System Generator => it generates files, it does not build
 
- Dependency discovery is awesome (find_package())
- Can not overcome the limitations of the underlying IDEs
-->

- **C**ross Platform **Make** is an open-source **build system generator**.

- It uses scripts called **CMakeLists.txt** to generate build files for a specific environment (Makefiles, ...)

- Family of tools 
  - Build $\Rightarrow$ **CMake**
  - Test $\Rightarrow$ **CTest, CDash**
  - Package $\Rightarrow$ **CPack**

<!-- 
  CMake generates native makefiles and workspaces that can be used in the compiler environment of your choice

  Enable building (CMake), testing (CTest, CDash) and packaging (CPack) of software
-->

## CMAKE'S POSITION AMONG BUILD SYSTEMS 

standalone
  : Make, NMake, SCons, Ninja

integrated
  : Visual Studio, Xcode, Eclipse

generators
  : Autotools (a.k.a. Autohell), **CMake**, Meson

## Interest over time

## History

## Key Features 

Cross-platform (Linux, macOS, Windows, ...)

Open source 

Great effort on maintaning backwards-compatibility with older scripts 

Generates project files for major IDEs / build tools 

  - Make
  - Ninja
  - Microsoft Visual Studio 
  - Xcode  

Direct CMake integration 

  - Microsoft Visual Studio 2017...20??
  - JetBrains CLion

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
- build projects written in languages like C, C++, Fortran, and CUDA. 


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



**Key Points:**
- Challenges of software build systems.
- Evolution of CMake and its current role in modern C++ development.

<!-- 

  ## The complexity of the build process (compiled languages (C/C++/Fortran))
  
  Compilers, linkers, testing frameworks, packaging systems, and more contribute to the complexity of deploying high-quality, robust software. 

  Computers cannot execute such a source file, they must be translated into binary processor instructions first. Thus, next step is to feed this program to a compiler, which does this translation for us. There is a multitude of ways of doing that, depending on the compiler. The compiler then takes the source file and “compiles” it into an executable program which you can then start.

  More complex programs will usually consist of multiple C++ files which are then separately compiled into intermediate output files (usually with a .o or .obj extension) and then “linked” together by a program called linker to an executable. In fact, even if just a single source file is compiled into an executable, the compiler automatically invokes the linker behind the scenes.

![](./fig/BuildProcess.png)  

-->


## 6. CMake's Importance in Software Development

Discussion on how CMake fits into the software development process, its role in streamlining development, testing, deployment, and complex use cases like large-scale projects and cross-platform development.

## 7. CMake in HPC

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