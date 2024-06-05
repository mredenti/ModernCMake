---
aspectratio: 169
---



# ADVANCED TOPICS

## CMAKE FEATURES 

\vspace{.3cm}

:::::::::::::: {.columns}
::: {.column width="50%"}

**Finding Packages**

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

:::
::::::::::::::
  



## RESOURCES


\begin{figure}[ht]
    \centering
    \begin{subfigure}[b]{0.25\textwidth}
        \includegraphics[width=\textwidth]{./fig/ProfessionalCMake.jpg}
        %\caption{Caption 1}
        %\label{fig:image1}
    \end{subfigure}
    \hfill
    \begin{subfigure}[b]{0.25\textwidth}
        \includegraphics[width=\textwidth]{./fig/ProfessionalCMake.jpg}
        %\caption{Caption 2}
        %\label{fig:image2}
    \end{subfigure}
    \hfill
    \begin{subfigure}[b]{0.25\textwidth}
        \includegraphics[width=\textwidth]{./fig/ProfessionalCMake.jpg}
        %\caption{Caption 3}
        %\label{fig:image3}
    \end{subfigure}
\end{figure}

 


# HANDS ON

