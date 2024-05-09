---
aspectratio: 169
---

# Finding Packages 

## Motivation 

As your project grows ...

## Finding Packages 

In CMake there are two ways for searching packages

- **Modules** 
- **CMake package configurations** 

but both of them use the same inferface `find_package()`


##  Finding Packages - Predefined Modules 

a list with all cmake modules for a particular version...

##  Finding Packages - Modules 

```{.cmake style=cmakestyle}
# CMakeLists.txt
find_package(<package_name> REQUIRED)
```

- Looks for a file named `find<package_name>.cmake` in the CMake cache variable `CMAKE_MODULE_PATH`
- The `REQUIRED` keyword causes a missing package to fail the configure step
- The CMake scripts define variables and imported targets


- Maybe add a link to where one can find the CMake modules


## Finding Packages - Package Configurations

The preferred approach is to have an installed package provide its own details to CMake, there are config files and come with many packages (CMake compatible version of `.pc` files). The advantage is that while CMake includes a FindBoost, it has to be updated with each new Boost release, whereas BoostConfig.cmake can be included with each Boost release

If a `Find<package_name>.cmake` is not found, then it will try and find a `<package_name>Config.cmake` in the following locations:

| Syntax      | Description |
| ----------- | ----------- |
| Header      | Title       |
| Paragraph   | Text        |

including `<package_name>_DIR` if that variable exists (you can set it in the `CMakeLists.txt` file)

## Finding Packages - Package Configurations: Environment Hints

- In CMake 3.12+, individual packages locations can be hinted by setting their installation root path in `<PackageName>_ROOT`
- The CMake cache variable `CMAKE_PREFIX_PATH` can be used to hint a list of installation root paths at once


## {.standout}

If you are a package author, never supply a Find<package>.cmake, but instead always supply a <package>Config.cmake with all your builds. 

## {.standout}

Exercise

* Can you ...