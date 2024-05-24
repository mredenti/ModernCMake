---
aspectratio: 169
---


# CREATING AND RUNNING TESTS

## WHY TESTING IS IMPORTANT

<!--
    Testing is an essential activity in the development cycle. A well-designed test suite will help you detect bugs and can also facilitate the onboarding of new developers. In this episode, we will look into how to use CTest to define and run our tests.

    Testing is a core component of the code development toolbox. 
    Performing automated testing by unit and integrations tests not only 
    helps the developer to detect functionality regressions early, but can also serve as a starting point for developers joining the project.

    It can help new developers to submit changes to the code project, with
    assurance that the expected functionality is preserved. For users of the code, automated
    tests can be essential when verifying that the installation preserves the functionality of the
    code. A nice byproduct of employing tests for units, modules, or libraries right from the
    start is that it can guide the programmer towards more modular and less complex code
    structures, using a pure, functional style, that minimizes and localizes global variables and
    the global state.

-->

- Early detection of functionality regressions

- Assurance of code functionality for new developers

- Verification of installation and deployment

- Encouragement of modular and less complex code

<!--
    Testing is an essential activity in the development cycle. A well-designed test suite will help you detect bugs and can also facilitate the onboarding of new developers. In this episode, we will look into how to use CTest to define and run our tests.
-->

## EXAMPLE: CREATING A SIMPLE UNIT TEST (I)

:::::::::::::: {.columns}
::: {.column width="65%"}

```c++
#include "sum_integers.hpp"
#include <vector>

using namespace std;

int sum_integers(const vector<int> ints) {
  auto sum = 0;
  for (auto i : ints) {
    sum += i;
  }
  return sum;
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
    [summation
      [src
        [sum\_integers.hpp, file
        ]
        [\colorbox{pink}{sum\_integers.cpp}, file
        ]
      ]
      [tests
        [test.cpp, file
        ]
      ]
    ]
  ]
\end{forest}

::: 
::::::::::::::

. . . 

Our objective is to write tests for this function.

## EXAMPLE: CREATING A SIMPLE UNIT TEST (II)

\vspace{.5cm}

In the `test.cpp` we write a `main()` that verifies that `1+2+3+4+5 = 15`.

:::::::::::::: {.columns}
::: {.column width="65%"}

```c++
#include "sum_integers.hpp"
#include <vector>

int main() {
  auto integers = {1, 2, 3, 4, 5};

  if (sum_integers(integers) == 15) {
    return 0;
  } else {
    return 1;
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
    [summation
      [src
        [sum\_integers.hpp, file
        ]
        [sum\_integers.cpp, file
        ]
      ]
      [tests
        [\colorbox{pink}{test.cpp}, file
        ]
      ]
    ]
  ]
\end{forest}

::: 
::::::::::::::

## HOW TO DO IT (I)

:::::::::::::: {.columns}
::: {.column width="65%"}

\vspace{.5cm}

1. In the top-level CMakeLists.txt file insert a call to `enable_testing()` to instruct CMake to produce an input file for ctest.

```{.cmake style=cmakestyle}
cmake_minimum_required(VERSION 3.21)

project(Summation LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# enable testing functionality
enable_testing()
```

::: 
::: {.column width="35%"}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [summation
      [\colorbox{pink}{CMakeLists.txt}, file
      ]
      [src
        [CMakeLists.txt, file
        ]
        [sum\_integers.hpp, file
        ]
        [sum\_integers.cpp, file
        ]
      ]
      [tests
        [CMakeLists.txt, file
        ]
        [test.cpp, file
        ]
      ]
    ]
  ]
\end{forest}

::: 
::::::::::::::


## HOW TO DO IT (II)

:::::::::::::: {.columns}
::: {.column width="65%"}

\vspace{.5cm}

2. We then define the summation OBJECT library 

```{.cmake style=cmakestyle}
add_library(summation OBJECT "")
target_sources(
    summation 
    PRIVATE 
        sum_integers.cpp
    PUBLIC 
        sum_integers.hpp) # test whether test.cpp gets it
```

::: 
::: {.column width="35%"}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [summation
      [CMakeLists.txt, file
      ]
      [src
        [\colorbox{pink}{CMakeLists.txt}, file
        ]
        [sum\_integers.hpp, file
        ]
        [sum\_integers.cpp, file
        ]
      ]
      [tests
        [CMakeLists.txt, file
        ]
        [test.cpp, file
        ]
      ]
    ]
  ]
\end{forest}

::: 
::::::::::::::


## HOW TO DO IT (III)

:::::::::::::: {.columns}
::: {.column width="65%"}

\vspace{.5cm}

3. We define the testing executable, link it to the summation library and define a test case with `add_test()`.

```{.cmake style=cmakestyle}
cmake_minimum_required(VERSION 3.21)

project(Summation LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# enable testing functionality
enable_testing()
```

::: 
::: {.column width="35%"}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [summation
      [CMakeLists.txt, file
      ]
      [src
        [CMakeLists.txt, file
        ]
        [sum\_integers.hpp, file
        ]
        [sum\_integers.cpp, file
        ]
      ]
      [tests
        [\colorbox{pink}{CMakeLists.txt}, file
        ]
        [test.cpp, file
        ]
      ]
    ]
  ]
\end{forest}

::: 
::::::::::::::

## about tests i

The add_test() command is how a project can define a test case. It supports a couple of different
forms, but the one shown above with NAME and COMMAND keywords is recommended.
The argument following NAME should generally contain only letters, numbers, hyphens, and
underscores. Other characters may be supported if using CMake 3.19 or later, but projects should
avoid anything complicated and stick with these basic characters in most cases.
The COMMAND can be any arbitrary command that could be run from a shell or command prompt. As a
special case, it can also be the name of an executable target defined by the project. CMake will then
translate that target name into the location of the binary built for that target. In the above example,
the SomethingWorks test will run the executable built for the testSomething CMake target. The project
doesn’t have to care where the build will create the binary in the file system, CMake will provide
that information to ctest automatically.

## about tests ii

By default, a test is deemed to pass if it returns an exit code of 0. Much more detailed and flexible
criteria can be defined, which is covered in Section 27.3, “Pass / Fail Criteria And Other Result
Types”, but a simple check of the exit code is often sufficient.


## nuid 

The following sequence of steps will configure, build, and test a project.

## CREATING A SIMPLE UNIT TEST

put code for a simple program 


Our plan
is to write and test code that can sum up integers, and nothing more. Just like in primary
school, when we learned multiplication and division after learning how to add, at this
point, our example code will only add and will only understand integers; it will not need to
deal with floating point numbers.

To show that
CMake does not impose any restrictions on the language to implement the actual tests, we
will test our code using not only a C++ executable, but also using a Python script and a shell
script. For simplicity, we will do this without using any testing libraries, but we will
introduce C++ testing frameworks in later recipes in this chapter


# TEST PROPERTIES: TIMEOUT, COST AND LABELS

## som


sdf

<!-- 

## Getting ready with the code 

 Finally, the main function is defined in main.cpp, which collects the command-line
arguments from argv[], converts them into a vector of integers, calls
the sum_integers function, and prints the result to the output:
#include "sum_integers.hpp"
#include <iostream>
#include <string>
#include <vector>
// we assume all arguments are integers and we sum them up
// for simplicity we do not verify the type of arguments
int main(int argc, char *argv[]) {
std::vector<int> integers;
for (auto i = 1; i < argc; i++) {
integers.push_back(std::stoi(argv[i]));
}
auto sum = sum_integers(integers);
std::cout << sum << std::endl;
}
Our goal is to test this code using a C++ executable (test.cpp), a Bash shell script
(test.sh), and a Python script (test.py), to demonstrate that CMake does not really
mind which programming or scripting language we prefer, as long as the implementation
can return a zero or non-zero value that CMake can interpret as a success or failure,
respectively.


In the C++ example (test.cpp), we verify that 1 + 2 + 3 + 4 + 5 equals 15, by calling
sum_integers:
#include "sum_integers.hpp"
#include <vector>
int main() {
auto integers = {1, 2, 3, 4, 5};
if (sum_integers(integers) == 15) {
return 0;
} else {
return 1;
}
}

The Bash shell script test example calls the executable, which is received as a positional
argument:
#!/usr/bin/env bash
EXECUTABLE=$1
OUTPUT=$($EXECUTABLE 1 2 3 4)
if [ "$OUTPUT" = "10" ]
then
exit 0
else
exit 1
fi


## How to do it 

We will now describe, step by step, how to set up testing for our project, as follows:
1. For this example, we require C++11 support, a working Python interpreter, and
the Bash shell:
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
project(recipe-01 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(PythonInterp REQUIRED)
find_program(BASH_EXECUTABLE NAMES bash REQUIRED)
2. We then define the library, the dependencies of the main executable, and the
testing executable:
# example library
add_library(sum_integers sum_integers.cpp)
# main code
add_executable(sum_up main.cpp)
target_link_libraries(sum_up sum_integers)

# testing binary
add_executable(cpp_test test.cpp)
target_link_libraries(cpp_test sum_integers)
3. Finally, we turn on the testing functionality and define four tests. The last two
tests call the same Python script; first without any command-line argument, and
then with --short:
enable_testing()
add_test(
NAME bash_test
COMMAND ${BASH_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/test.sh
$<TARGET_FILE:sum_up>
)
add_test(
NAME cpp_test
COMMAND $<TARGET_FILE:cpp_test>
)


You should also try to break the implementation, to verify whether the test set
catches the change.


## How it works?

The two key commands here are enable_testing(), which enables testing for this
directory and all subfolders within it (in this case, the entire project, since we place it in the
main CMakeLists.txt), and add_test(), which defines a new test and sets the test name
and the command to run; an example is as follows:
add_test(
NAME cpp_test
COMMAND $<TARGET_FILE:cpp_test>
)
In the preceding example, we employed a generator expression:
$<TARGET_FILE:cpp_test>. Generator expressions are expressions that are evaluated at
build system generation time. We will return to generator expressions in more detail in
Chapter 5, Configure-time and Build-time Operations, Recipe 9, Fine-tuning configuration and
compilation with generator expressions. At this point, we can state that
$<TARGET_FILE:cpp_test> will be replaced by the full path to the cpp_test executable
target.


Generator expressions are extremely convenient in the context of defining tests, because we
do not have to explicitly hardcode the locations and names of the executables into the test
definitions. It would be very tedious to achieve this in a portable way, since both the
location of the executable and the executable suffix (for example, the .exe suffix on
Windows) can vary between operating systems, build types, and generators. Using the
generator expression, we do not have to explicitly know the location and name.
It is also possible to pass arguments to the test command to run; for example:
add_test(
NAME python_test_short
COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/test.py --short
--executable $<TARGET_FILE:sum_up>
)

In this example, we run the tests sequentially (Recipe 8, Running tests in parallel, will show
you how to shorten the total test time by executing tests in parallel), and the tests are
executed in the same order that they are defined (Recipe 9, Running a subset of tests, will
show you how to change the order or run a subset of tests). It is up to the programmer to
define the actual test command, which can be programmed in any language supported by
the operating system environment running the test set. The only thing that CTest cares
about, in order to decide whether a test has passed or failed, is the return code of the test
command. CTest follows the standard convention that a zero return code means success,
and a non-zero return code means failure. Any script that can return zero or non-zero can
be used to implement a test case.
Now that we know how to define and execute tests, it is also important that we know how
to diagnose test failures. For this, we can introduce a bug into our code and let all of the
tests fail:


If we then wish to learn more, we can inspect the file
Testing/Temporary/LastTestsFailed.log. This file contains the full output of the test
commands, and is the first place to look during a postmortem analysis. It is possible to
obtain more verbose test output from CTest by using the following CLI switches:
--output-on-failure: Will print to the screen anything that the test program
produces, in case the test fails.
-V: Will enable verbose output from tests.
-VV: Enables even more verbose output from tests.

CTest offers a very handy shortcut to rerun only the tests that have previously failed; the
CLI switch to use is --rerun-failed, and it proves extremely useful during debugging.

We have executed the test set using the ctest command, but CMake will also create
targets for the generator in question (make test for Unix Makefile generators, ninja
test for the Ninja tool, or RUN_TESTS for Visual Studio). This means that there is yet
another (almost) portable way to run the test step:

In the previous recipe, we used an integer return code to signal success or failure in
test.cpp. This is fine for simple tests, but typically, we would like to use a testing
framework that offers an infrastructure to run more sophisticated tests with fixtures,
comparisons with numerical tolerance, and better error reporting if a test fails. A modern
and popular test library is Catch2 (https:/ / github. com/ catchorg/ Catch2). One nice
feature of this test framework is the fact that it can be included in your project as a singleheader
library, which makes compilation and updating the framework particularly easy. In
this recipe, we will use CMake in combination with Catch2, to test the summation code
introduced in the previous recipe.

mention also google test

In this recipe, we will demonstrate how to implement unit testing using the Google Test
framework, with the help of CMake. In contrast to the previous recipe, the Google Test
framework is more than a header file; it is a library containing a couple of files that need to
be built and linked against. We could place these alongside our code project, but to make
the code project more lightweight, we will choose to download a well-defined version of
the Google Test sources at configure time, and then build the framework and link against it.
We will use the relatively new FetchContent module (available since CMake version
3.11). We will revisit FetchContent in Chapter 8, The Superbuild Pattern, where we will
discuss how the module works under the hood, and where we will also illustrate how to
emulate it by using ExternalProject_Add. This recipe is inspired by (and adapted from)
the example at https:/ / cmake. org/ cmake/ help/ v3. 11/ module/ FetchContent. html.

very important command 

-L[A][H]                     = List non-advanced cached variables.

-LAH: This consists of three combined options:

-L: Lists all variables. When you run this command, it will print out all the cached variables after processing the CMakeLists.txt files. These variables include both user-defined and internal variables.
-A: This option is related to the list of options provided by -L. In some versions of CMake, -A can be combined with other options to provide additional details, but this is not universally supported across all versions and may be redundant or unrecognized.
-H: Helps to include help text for each variable when listed. This means that each variable printed by -L will also include a description if available.

-->