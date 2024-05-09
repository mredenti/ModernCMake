cmake_minimum_required(VERSION 3.21)

project(cmake_tutorial LANGUAGES CXX)

message(STATUS "CMAKE_CXX_STANDARD is: ${CMAKE_CXX_STANDARD}")

set(CMAKE_CXX_STANDARD 17)

if (NOT CMAKE_BUILD_TYPE) # an empty string is equivalent to a false logical variable
  set(CMAKE_BUILD_TYPE CustomReleaseA)
endif()

message(STATUS "CMAKE_CXX_STANDARD is: ${CMAKE_CXX_STANDARD}")
message(STATUS "CMAKE_BUILD_TYPE is: ${CMAKE_BUILD_TYPE}")

add_executable(main main.cpp)