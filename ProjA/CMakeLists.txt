# REFERENCE PROJECT CMAKELISTS.TXT
#
# @author Barthélémy von Haller

cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

#set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/../cmake) # main (top) cmake dir
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake) # project specific cmake dir

# Set the name of your project here
project("ProjA"
    VERSION 1.0
    LANGUAGES CXX)

# Set the version number of your project here (format is MAJOR.MINOR.PATCHLEVEL - e.g. 1.0.0)
set(VERSION_MAJOR "0")
set(VERSION_MINOR "0")
set(VERSION_PATCH "0")
set(VERSION ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH})


# This line finds the boost lib and headers. 
# set(Boost_NO_BOOST_CMAKE ON) #  Don't do a find_package in config mode before searching for a regular boost install.
# find_package(Boost COMPONENTS unit_test_framework program_options REQUIRED)

# This sets the include directory for the reference project. This is the -I flag in gcc.
# All the includes should be in this variable To add new directories to the include path,
# just add them in this list (after a space), or add an include_directories statement in a
# subdirectory's CMakeLists.
include_directories(
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_BINARY_DIR}/include   # add the binary tree to the search path so that we will find Version.h
    ${Boost_INCLUDE_DIRS}
)

# Mac needed variables (adapt according to your needs)
set(CMAKE_MACOSX_RPATH ON)
#set(CMAKE_SKIP_BUILD_RPATH FALSE)
#set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
#set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
#set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

show_cmake_variables()

enable_testing()
add_subdirectory(include)
add_subdirectory(src)
add_subdirectory(doc)
add_subdirectory(test)

#
# SYSTEM PACKAGING (RPM, TGZ, ...)
# _____________________________________________________________________________

include(CPackConfig)

#
# CMAKE PACKAGING (for other CMake projects to use this one easily)
# _____________________________________________________________________________

include(package/PackageConfigurator)