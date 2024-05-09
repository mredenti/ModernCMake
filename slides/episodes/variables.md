---
aspectratio: 169
---

# Variables 


## Variables 

In CMake there are 3 distinct types of variables: 

- **Normal Variables**
- **Cache Variables**
- **Environments Variables** 

## Normal Variables 

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

## Cache Variables 


## Environment Variables 


## Keypoints 

https://stackoverflow.com/questions/16851084/how-to-list-all-cmake-build-options-and-their-default-values

Example; - setting the C++ standard is often a decision driven by the project's code requirements.