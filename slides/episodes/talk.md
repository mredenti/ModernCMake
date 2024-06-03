- Ok, I think we should probably get started. 
- My name is Michael and I work as a ... here in CINECA. I mainly deal with ...
- Today I will talk about CMake. The motivation for talking about CMake in this workshop definitely has to do with its wide adoption...
  - Just like C++, CMake has a big userbase, it dominates the industry 
  - They have a strong focus on backwards compatibility
  - complex, feature, rich, "multi paradigm toolset" (just like C++)
  - bad reputation, horrible syntax, "bloated"


## WHAT IS CMAKE 

- CMake is a portable build system generator, but not a build system. 

- The main thing about being modern is the Target Centric approach. All the targets that you declare full carry their own build and usage requirements with it and they will propagate this.


## WHY EFFICIENT BUILD SYSTEMS MATTER 


- Today we are going to talk about CMake
- Good tools matter when it comes to building software
- The thing about CMake is very flexible, you can do a lot of things in order to boost productivity


## POPULARITY 

- Given its popularity ...


## WHAT IS CMAKE 

- CMake is a BUILD FILE generator, meaning it generates files; it does not build. 

- The CMake language is platform and compiler indipendent language

- Not the nicest language, too many features, ...

- The CMake ecocsystem is a family of tools for building, testing and packaging your software

- CMake puts a lot of effort on backwards compatibility, so that old CMake scripts should work

## CMAKE FEATURES 

- CMake itself is a cross--platform software, meaning that it will run on a lot different platforms: OS, Windows, Linux

- Multiple Generators: As we already mentioned CMake is a build file generator and so it will build files for many IDEs and build tools

- Direct CMake integration: given its popularity it is now directly supported and bundled with major IDEs; you can build CMake projects directly from the IDE..


- Language is quite flexible and also works in scripting mode as if it was bash; but if you were on windows you do not want to write in power shell or whatever



## CMAKE LANGUAGE 

- The CMake language is **command based**, one command per line
  
- All of these commands are procedures, they do not return values. And so you can not nest them


- Command may have many arguments and overloads. For instance, the command `file()` has multiple profiles, one allows to write data to file, another will read data from file. 

- The CMake documentation will show you all the different variants, examples with the different parameters that you can pass

## BASIC STEPS WITH CMAKE 

- Detection of the compiler, build flags, configuration


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



## TARGET CONFIGURATION

- For your targets you  need to define include directories, to sepcify where are the headers, 
- You need to specify compile definitions, preprocessor macros, definitios 
- compile options (for example if i want to define all of the warnings)
- All of these commands have visibility levels




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
