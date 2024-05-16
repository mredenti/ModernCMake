# Introduction to CMake

## MOTIVATION 

- **productivity** spend time on software development, not software building 

## WHAT IS CMAKE

- CMake is a build file generator which means that it generates files but it does not actually build

- In CMake you write scripts called CMakeLists.txt which describe the build in a compiler and platform independent language

- Uses CMake language which is quite flexible as it allows scripting ...

- CMake allows you to build, test and package your software

## CMake Features 

- CMake is very popular such that it has been widely adopted across all major IDEs. This integration allows to open a CMake project, debug and so on directly through the IDE (interface)

- Perhaps it is not integrates with XCode but it can generate XCode files








## CMake language 

- CMake language is command based, one command per line

- CMake commands are procedures, they do not return values, they are not functions --> you can not nest them

- Commands can have many arguments and overloads 
  For instance, the file command has multiple profiles. 
  One allows to WRITE data to a file, another allows to READ data from a file

- Go to the documentation

  
- VARIABLES are strings -> it is up to the commands to interpret all of the values in they want but most of the time they are going to be strings 

- even lists are semi-colon separated strings












## Commands vs Functions

- In CMake, both commands and functions are used to perform specific tasks during the build configuration process, but they differ in scope, definition and usage. 

- Definition and Scope:
  - Commands in CMake are built-in operations provided by the CMake language. They are always available and can be used in any CMakeLists.txt file 

  - Commands have global scope, meaning their effects are not limited to the file or block in which they are used 

  - Functions in CMake are defined using the `function()` command and are called by their name
  - Functions can take arguments and optionally "return" values by modifying passed variables
  - Functions are user-defined and make use of commands to perform conditional logic, execute processes and so on...
