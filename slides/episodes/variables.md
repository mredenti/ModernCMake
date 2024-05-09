---
aspectratio: 169
---

# VARIABLES


## VARIABLES

In CMake there are 3 distinct types of variables: 

- **Regular Variables**
- **Cache Variables**
- **Environments Variables** 

## REGULAR VARIABLES

The 

CMake already defines a list of variables internally. (mmmm)

```{.bash style=bashstyle}
$ cmake --help-variable-list
```
. . .

New user-defined variables can be created `set` command

```{.cmake style=cmakestyle}
# CMakeLists.txt
set(CMAKE_CXX_STANDARD 17)
```

## CACHE VARIABLES 


Unlike normal variables which have a lifetime limited to the processing of the CMakeLists.txt file, cache variables are stored in a special file called CMakeCache.txt in the build directory, and they persist between CMake runs. When you rerun the files generation stage, the cache is read in before starting

Once set, cache variables remain set until something explicitly removes them from the cache.

In a build, cached variables are set in the command line or in a graphical tool (such as ccmake, cmake-gui), and then written to a file called CMakeCache.txt.

Feel free to look back at the example you built in the last lesson and investigate the CMakeCache.txt file in your build directory there. Things like the compiler location, as discovered or set on the first run, are cached.

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