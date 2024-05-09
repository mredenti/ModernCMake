---
title: Modern CMake
subtitle: CINECA - Workshop on build systems
author: Michael Redenti 
institute: m.redenti@cineca.it
date: \today
aspectratio: 169
#- '\renewenvironment{Shaded}{\footnotesize\linespread{0.9}}{}'
---


# Introduction



## The importance of build systems

- Building code is hard 
- Some commong build systems:
  - Make
  - Ninja
  - invoke
  - rake (Ruby make)
- Disadvantages:
  - Mostly hand coded as you have to know all the proper commands 
  - Platform/compiler dependent 
  - Hard to extend, does not work well with IDEs

## Build system generators

- Autotools
- Bazel
- Meson
- **CMake (aka Cross-platform Make)**

## The importance of build system generators

- CMake is not a build system
- CMake generates build system files/scripts to be invoked on your native platform depending on how you configure CMake

## Basic Usage

:::::::::::::: {.columns}
::: {.column width="50%"}
```c++
cmake_minimum_required(VERSION 3.12)

project(hello_world)

add_executable(main main.cpp)
```
:::

. . .

::: {.column width="50%"}
```c++
#include <iostream>

int main()
{
  std::cout << "Hello, World!\n";
  return 0;
}
```
:::
::::::::::::::

## Source Code

:::::::::::::: {.columns}
::: {.column width="50%"}
```c++
#include <iostream>

using namespace std;

int main()
{
  cout << "Hello, World!" << endl;
  return 0;
}
```
:::

. . .

::: {.column width="50%"}
```c++
#include <iostream>



int main()
{
  std::cout << "Hello, World!\n";
  return 0;
}
```
:::
::::::::::::::


## {.standout}

The code on the \alert{right is right}.
The code on the \alert{left is wrong}.

## Source Code

> When you show a good and a bad example side-by-side, make sure that the good
> example is always on the right hand side.
>
> \hfill Your humble narrator

# UML Diagrams

## UML Diagrams

:::::::::::::: {.columns}
::: {.column width="50%"}
```plantuml
skinparam backgroundColor transparent

Alice -> Bob: Authentication Request
Bob --> Alice: Authentication Response

Alice -> Bob: Another authentication Request
Alice <-- Bob: another authentication Response
```
:::
::: {.column width="50%"}

Some Text here.

:::
::::::::::::::

## UML Diagrams

:::::::::::::: {.columns}
::: {.column width="50%"}
```plantuml
skinparam backgroundColor transparent

class Car
interface Driver

Driver - Car : drives >
Car *- Wheel : have 4 >
Car -- Person : < owns
```
:::
::: {.column width="50%"}

```plantuml
skinparam rectangle {
  BackgroundColor<<Windows>> LightBlue
  BackgroundColor<<macOS>> LightGreen
  BackgroundColor<<Linux>> LightYellow
}

rectangle "Source Tree" as ST
rectangle "CMake" as CM [ST] #Pink

rectangle "Visual Studio" as VS <<Windows>> 
rectangle "XCode" as XC <<macOS>> 
rectangle "Make" as MK <<Linux>> 

ST -down-> CM

CM -[hidden]-> VS
CM -[hidden]-> XC
CM -[hidden]-> MK

VS -[dashed,blue]-> "Windows\nBinaries": builds
XC -[dashed,green]-> "macOS\nBinaries": builds
MK -[dashed,yellow]-> "Linux\nBinaries": builds
```
:::
::::::::::::::

## Targets 

- A target is a logical unit in your application
- When logical chunks are used by other parts of the applications it makes sense to make a library, a library is typically made up of many logical units


## Lists

::: incremental

- Eat spaghetti
- Drink wine

:::
or

::: nonincremental

- Eat spaghetti
- Drink wine

:::

### Inside block 

```cpp
std::cout
```

## Wrappers

::: wrapper
- a
- list in a quote
:::

::: notes

This is my note.

- It can contain Markdown
- like this list

:::


## {.standout}

\Huge\faGrinStars




#include <fftw3.h>
#include <vector>
#include <complex>

class WavePacket {
private:
    std::vector<std::complex<double>> data;
    fftw_plan forwardPlan;
    fftw_plan backwardPlan;

public:
    WavePacket(int size) : data(size) {
        // Initialize FFTW plans
        fftw_complex* fftwData = reinterpret_cast<fftw_complex*>(data.data());
        forwardPlan = fftw_plan_dft_1d(size, fftwData, fftwData, FFTW_FORWARD, FFTW_MEASURE);
        backwardPlan = fftw_plan_dft_1d(size, fftwData, fftwData, FFTW_BACKWARD, FFTW_MEASURE);
    }

    ~WavePacket() {
        fftw_destroy_plan(forwardPlan);
        fftw_destroy_plan(backwardPlan);
        fftw_cleanup();
    }

    void executeForward() {
        fftw_execute(forwardPlan);
    }

    void executeBackward() {
        fftw_execute(backwardPlan);
    }

    // Method to initialize data
    void initializeGaussian(double mean, double std_dev) {
        double normalization = 1.0 / (std_dev * sqrt(2.0 * M_PI));
        for (size_t i = 0; i < data.size(); ++i) {
            double x = -10.0 + i * (20.0 / data.size()); // Assuming the grid ranges from -10 to 10
            data[i] = std::complex<double>(normalization * exp(-pow(x - mean, 2) / (2 * std_dev)), 0);
        }
    }

    // Accessors
    std::complex<double>& operator[](size_t idx) { return data[idx]; }
    const std::complex<double>& operator[](size_t idx) const { return data[idx]; }
};


CMake and Make are especially helpful when it comes to automation and save you time by putting all the commands required to build the program in either a Makefile or CMakeLists.txt file without having to type them out every time.

Make is a tool that controls the generation of executables and other non–source files of a program from the program’s source files. It obtains the instructions on how to build the program from a file called the Makefile.

On the other hand, CMake requires a CMakeLists.txt file and is a cross-platform Make. This means that it works on different operating systems. It allows compiler-independent builds, testing, packaging, and installation of software. It’s important to note that CMake produces build files for other systems; however, it’s not a build system itself. CMake can generate a Makefile, and then the generated Makefile can be used with Make in the platform being worked on:


To use Make, you have to manually create the Makefile, but with CMake, the Makefile is automatically created.

In the following sections, you’ll learn how to compile a simple program using both CMake and Make to better understand their differences.

```plantuml
skinparam roundcorner 25

skinparam rectangle {
  BorderColor Black
  BackgroundColor LightGreen
}

skinparam defaultTextAlignment center
skinparam ArrowColor Black
skinparam Arrow {
  Thickness 1
}

rectangle "Project File Generation" as CMake {
  rectangle "Configure" as Configure #LightGrey
  rectangle "Generate" as Generate #LightGrey
}

rectangle "Project Files" as Unix #LightBlue 

rectangle "Build" as Build 

' Connect the blocks
Configure -right-> Generate
Generate -right-> Unix
Unix -right-> Build
```