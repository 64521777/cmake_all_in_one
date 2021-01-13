cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# ---- Project ----

# Note: update this to your new project's name and version
project(
    Hello
    VERSION 1.0
    LANGUAGES CXX
)

# ---- Include guards ----

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(
        FATAL_ERROR
        "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there."
    )
endif()

# ---- Include cmake modules ----
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

option(HELLO_VERBOSE_OUTPUT "show verbose information" ON)

# --- Include common marcos and functions ---
include(Custom)
# --- Include options to get user config
#include(options)
# --- Include version to gen version.h ---
include(version)
# --- Include to enviroment_check gen envriment.h ---
include(enviroment_check)
# --- config compiler ---
include(ConfigCompiler)

# --- config project ---
enable_testing() # needed on top-level CMakeLists.txt

#add_subdirectory(ProjA)
add_subdirectory(ProjB)
