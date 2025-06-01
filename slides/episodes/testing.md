---
aspectratio: 169
---


<!-- 
  TESTING and CODE ANALYSIS are important parts of the complete software cycle (mention the static and dynamic analysis as a final slide)

  CMake has direct support for defining test cases, which are executed with a dedicated testing tool, ctest.
-->



<!-- 

## EXTREMELY IMPORTANT FOR TESTING 

https://cmake.org/cmake/help/book/mastering-cmake/chapter/Testing%20With%20CMake%20and%20CTest.html#:~:text=the%20testing%20process.-,How%20Does%20CMake%20Facilitate%20Testing%3F,-%C2%B6

Use the following in the tutorial for the testing parts 

- https://coderefinery.github.io/cmake-workshop/testing/

-->

# CREATING AND RUNNING TESTS


## INTEGRATING TESTS IN THE CMAKE WORKFLOW

<!--
A natural follow-on to building a project is to test the artifacts it created. The CMake software suite
includes the ctest tool, which can be used to automate the testing phase. This chapter covers the
fundamental aspects of testing. It discusses how to define tests and execute them using the ctest
command-line tool. -->

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

    In this recipe, we will introduce unit tests using CTest, the testing tool distributed as a part
    of CMake. In order to keep the focus on the CMake/CTest aspect and to minimize the
    cognitive load, we wish to keep the code that is to be tested as simple as possible.
-->

<!-- 
  Testing is an essential activity in the development cycle. A well-designed test suite will help you detect bugs and can also facilitate the onboarding of new developers.

   and encourages simpler, modular code.

-->


Testing is an important aspect of software development. It helps catch bugs early, verify functionality, ensure proper installation, ...

\vspace{1cm}

\begin{tikzpicture}[remember picture,overlay]
\node[anchor=north east,inner sep=0pt, xshift=-1.6cm, yshift=-2.6cm] at (current page.north east) {
  \href{http://www.example.com}{\includegraphics[scale=0.38]{./fig/CMakeCTestWorkflow.png}}
};
\end{tikzpicture}

\vspace{2.5cm}

\begin{curiositybox}
\textbf{CTest} is a driver to kick off a test runner like Google Test or PyTest, or anything you like to run. You can handle your test suite definition, execution, and reporting through it.
\end{curiositybox}

<!--
    Testing is an essential activity in the development cycle. A well-designed test suite will help you detect bugs and can also facilitate the onboarding of new developers. In this episode, we will look into how to use CTest to define and run our tests.
-->

## EXAMPLE: CREATING A SIMPLE UNIT TEST (I)

<!--
  The implementation source
  file, sum_integers.cpp, does the work of summing up over a vector of integers, and
  returns the sum:

  The interface is exported to our example library in sum_integers.hpp,
-->

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
    [Summation
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

## EXAMPLE: CREATING A SIMPLE UNIT TEST (II)

\vspace{.5cm}

In `test.cpp` we verify that `1+2+3+4+5 = 15` by calling our function.

:::::::::::::: {.columns}
::: {.column width="65%"}

```c++
#include "sum_integers.hpp"
#include <vector>
#include <iostream>

int main() {
  auto integers = {1, 2, 3, 4, 5};

  if (sum_integers(integers) == 15) {
    return 0;
  } else {
    std::cout << "Wrong result\n";
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
    [Summation
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

<!-- 
  enable_testing() can be
called in a subdirectory without error, but without a call to enable_testing() at the top level, the
ctest input file will not be created at the top of the build tree where it is normally expected to be


I prefer to have verbose output, and I can do this with setting the CMake CTest arguments:

list(APPEND CMAKE_CTEST_ARGUMENTS "--output-on-failure")
list(APPEND CMAKE_CTEST_ARGUMENTS "--verbose")

CTest is a driver to kick off a test runner like Google Test or PyTest, or anything you like to run:

-->

1. In the top-level CMakeLists.txt file insert a call to `enable_testing()` which will instruct CMake to produce an input file for CTest in the `CMAKE_CURRENT_BINARY_DIR`.

```{.cmake style=cmakestyle}
cmake_minimum_required(VERSION 3.21)

project(Summation LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# enable testing functionality
enable_testing()

add_subdirectory(src)
add_subdirectory(tests)
```

::: 
::: {.column width="35%"}

\begin{forest}
  pic dir tree,
  where level=0{}{
    directory,
  },
  [ 
    [Summation
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
add_library(summation OBJECT)
target_sources(
    summation 
    PRIVATE 
        sum_integers.cpp) 

# Include directory for the summation target
target_include_directories(
    summation 
    PUBLIC 
        ${CMAKE_CURRENT_LIST_DIR})
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

3. Then, we define the testing executable, link it to the summation library and register a test target with `add_test()`.

```{.cmake style=cmakestyle}
# testing binary
add_executable(cpp_test test.cpp)
target_link_libraries(
    cpp_test 
    PRIVATE 
        summation)

# define tests
add_test(
    NAME test_sum_integers
    COMMAND cpp_test
  )
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

## RUNNING TESTS

We are now ready to build the code... 

```{.bash style=bashstyle}
$ cmake -B ./build -S ./summation 
$ cmake --build ./build 
```

...and run the test with `ctest`

```{.bash style=bashstyle}
$ ctest --test-dir ./build
Internal ctest changing into directory: <>/build
Test project <>/build
    Start 1: test_sum_integers
1/1 Test #1: test_sum_integers ................ Passed  0.00 sec

100% tests passed, 0 tests failed out of 1

Total Test time (real) =   0.01 sec
```

\centering 
**By default, a test will be deemed to pass if the command returns an exit code of 0.**

<!-- 

  More flexible pass/fail handling is supported...

-->


<!-- 
  It is up to the programmer to define the actual test command, which can be programmed in any language supported by
  the operating system environment running the test set. The only thing that CTest cares
  about, in order to decide whether a test has passed or failed, is the return code of the test
  command. CTest follows the standard convention that a zero return code means success,
  and a non-zero return code means failure. Any script that can return zero or non-zero can
  be used to implement a test case.

  Much more detailed and flexible criteria can be defined, which is covered in Section 27.3, “Pass / Fail Criteria And Other Result
  Types”, but a simple check of the exit code is often sufficient.
-->

## HOW IT WORKS 

- The command

  ```{.cmake style=cmakestyle}
  enable_testing()
  ```

  instructs CMake to write out a CTest input file (`CTestTestfile.cmake`) in the `CMAKE_CURRENT_BINARY_DIR`, which will contain details of all the tests defined in the project.

- Defining individual tests is done with the `add_test()` command

  ```{.cmake style=cmakestyle}
  add_test(
      NAME <name> 
      COMMAND <command> [<arg>...]
      [WORKING_DIRECTORY <dir>]) 
  ```

  which adds a new test case and the associated command to run.
  The `<command>` can be any arbitrary command (eg. full path to an executable) that could be run from a shell or command prompt. 
  As a special case, it can also be the name of an executable target defined by the project. 
<!-- 
  # By default, the test will run in the CMAKE_CURRENT_BINARY_DIR. The WORKING_DIRECTORY option 
  can be used to make the test run in some other location. An example where this can be useful 
  is to run the same executable in different directories to pick up different sets of input files,
  without having to specify them as command-line arguments.

  When a target name is used, CMake automatically substitutes the real path to the executable. 
  The automatic substitution of a target with its real location does not extend to the command
  arguments, only the command itself supports such substitution. If the location of a target needs to
  be given as a command line argument, generator expressions can be used.  
-->

<!-- 
    CMake will then translate that target name into the location of the binary built for that target. 
    The project doesn’t have to care where the build will create the binary in the file system, CMake will provide
    that information to ctest automatically.
-->

## DIAGNOSING TEST FAILURES (I)

Let us introduce a bug into our code...

```cpp
-sum += i;
+sum *= i;
```

...  and let the test fail

```{.bash style=bashstyle}
$ cmake --build ./build && ctest --test-dir ./build
Test project <>/build
    Start 1: test_sum_integers
1/1 Test #1: test_sum_integers ................***Failed 0.00 sec

0% tests passed, 1 tests failed out of 1

The following tests FAILED:
          1 - test_sum_integers (Failed)

Errors while running CTest
Output from tests in: <>/build/Testing/Temporary/LastTest.log
```  


## DIAGNOSING TEST FAILURES (II)

Different ways to inspect the output of the failed tests:

1. Inspect the file `Testing/Temporary/LastTestsFailed.log` located under the `build` directory
  ```{.bash style=bashstyle}
  Start testing: May 28 18:19 CEST
  ----------------------------------------------------------
  1/1 Testing: test_sum_integers
  1/1 Test: test_sum_integers
  Command: "<>/build/tests/cpp_test"
  Directory: <>/build/tests
  "test_sum_integers" start time: May 28 18:19 CEST
  Output:
  ----------------------------------------------------------
  Wrong result
  <end of output>
  Test time =   0.00 sec
  ----------------------------------------------------------
  Test Failed.
  ----------------------------------------------------------
  ```


<!--
   This file contains the full output of the test
commands, and is the first place to look during a postmortem analysis.
-->



## DIAGNOSING TEST FAILURES (III)


<!-- 
  It is possible to obtain more verbose test output from CTest by using the following CLI switches:
  --output-on-failure: Will print to the screen anything that the test program
  produces, in case the test fails.

  - CTest offers a very handy shortcut to rerun only the tests that have previously failed; the
CLI switch to use is `--rerun-failed`, and it proves extremely useful during debugging.
-->

2. Use `--rerun-failed --output-on-failure` to re-run the failed cases with output enabled.
  ```{.bash style=bashstyle}
  $ ctest --test-dir ./build/ --rerun-failed --output-on-failure
  Internal ctest changing into directory: <>/build
  Test project <>/build
      Start 1: test_sum_integers
  1/1 Test #1: test_sum_integers ................***Failed 0.00 sec
  Wrong result

  0% tests passed, 1 tests failed out of 1

  Total Test time (real) =   0.05 sec

  The following tests FAILED:
            1 - test_sum_integers (Failed)
  Errors while running CTest
  ```

- `--stop-on-failure` to end the test run at the first error encountered (CMake > 3.18) 

# TEST PROPERTIES

## TEST PROPERTIES

\centering 

**Just like targets, tests can have properties that control various aspects of their behavior.**

\raggedright

\vspace{.3cm}

Properties are set using the `set_tests_properties()` command.

. . .

**TIMEOUTS** 

The test is terminated and marked as failed if the test goes past specified time

```{.cmake style=cmakestyle}
set_tests_properties(myTest PROPERTIES TIMEOUT 10) # [s]
```

<!-- for whatever reason (the test has stalled or the machine is too slow) Specify a **TIMEOUT** for the test, and set it to 10 seconds: -->

```{.bash style=bashstyle}
$ ctest --test-dir ./build
Start 1: myTest
1/1 Test #1: myTest ..........................***Timeout 10.01 sec
0% tests passed, 1 tests failed out of 1
Total Test time (real) = 10.01 sec
The following tests FAILED:
1 - myTest (Timeout)
Errors while running CTest
```


## TEST PROPERTIES (Cont.)


**LABELS** 

```{.cmake style=cmakestyle}
add_test(NAME benchmark-a 
          COMMAND python ${CMAKE_CURRENT_SOURCE_DIR}/test/benchmark-a.py)
add_test(NAME benchmark-a 
          COMMAND python ${CMAKE_CURRENT_SOURCE_DIR}/test/benchmark-b.py)
add_test(NAME benchmark-c 
          COMMAND python ${CMAKE_CURRENT_SOURCE_DIR}/test/benchmark-c.py)

set_tests_properties(benchmark-a benchmark-b PROPERTIES LABELS "quick")
set_tests_properties(benchmark-c PROPERTIES LABELS "long")
```


- Filter by label 
  ```{.bash style=bashstyle}
  $ ctest --test-dir ./build -L quick
  ```

- See [\color{blue}{CMake: Test Properties Documentation}](https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html#test-properties) for a full list of properties 




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