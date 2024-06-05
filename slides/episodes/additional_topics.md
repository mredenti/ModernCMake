---
aspectratio: 169
---



# ADVANCED TOPICS

## CMAKE FEATURES 

\vspace{.3cm}

:::::::::::::: {.columns}
::: {.column width="50%"}

**Finding Dependencies**

- [\color{blue}{PkgConfig}](https://cmake.org/cmake/help/latest/module/FindPkgConfig.html)
- Write your own module file


**[\color{blue}{Installing Dependencies}](https://cmake.org/cmake/help/latest/module/ExternalProject.html)**

- `external_project_add()`
- `FetchContent_Declare()`

:::

::: {.column width="50%"}


**[\color{blue}{Generator Expressions}](https://cmake.org/cmake/help/latest/manual/cmake-generator-expressions.7.html)**

\vspace{0.2cm}

**[\color{blue}{Installation}](https://cmake.org/cmake/help/latest/command/install.html)**

\vspace{0.2cm}


**Test frameworks integration**

- [\color{blue}{GoogleTest}](https://google.github.io/googletest/quickstart-cmake.html)




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
  



## ADDITIONAL RESOURCES


- [\color{blue}{CMake Cookbook}](https://www.packtpub.com/product/cmake-cookbook/9781788470711)

- [\color{blue}{CMake Discourse}](https://discourse.cmake.org/)

- [\color{blue}{Professional CMake: A Practical Guide 18th Edition}](https://crascit.com/professional-cmake/)

 


# HANDS ON

