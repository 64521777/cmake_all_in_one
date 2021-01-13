# - Try to find MPEG7Fex
#
# The following variables are optionally searched for defaults
#  MPEG7Fex_ROOT_DIR:            Base directory where all MPEG7Fex components are found
#
# The following are set after configuration is done:
#  MPEG7Fex_FOUND
#  MPEG7Fex_INCLUDE_DIRS
#  MPEG7Fex_LIBRARIES
#  MPEG7Fex_LIBRARYRARY_DIRS
include(FindPackageHandleStandardArgs)

set(MPEG7Fex_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" CACHE PATH "Folder contains MPEG7Fex")

find_path(MPEG7Fex_INCLUDE_DIR MPEG7FexLib/Descriptors.h
	PATHS ${MPEG7Fex_ROOT_DIR}
	PATH_SUFFIXES include)

if(MSVC)
    find_library(MPEG7Fex_LIBRARY_RELEASE
        NAMES MPEG7Fex
        PATHS ${MPEG7Fex_ROOT_DIR}
        PATH_SUFFIXES Release)

    find_library(MPEG7Fex_LIBRARY_DEBUG
        NAMES MPEG7Fex
        PATHS ${MPEG7Fex_ROOT_DIR}
        PATH_SUFFIXES Debug)

    set(MPEG7Fex_LIBRARY optimized ${MPEG7Fex_LIBRARY_RELEASE} debug ${MPEG7Fex_LIBRARY_DEBUG})
else()
	find_library(MPEG7Fex_LIBRARY libMPEG7Fex.a libMPEG7Fex.so
        PATHS ${MPEG7Fex_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
endif()

find_package_handle_standard_args(MPEG7Fex 
	FOUND_VAR MPEG7Fex_FOUND
	REQUIRED_VARS MPEG7Fex_INCLUDE_DIR MPEG7Fex_LIBRARY)

if(MPEG7Fex_FOUND)
    set(MPEG7Fex_INCLUDE_DIRS ${MPEG7Fex_INCLUDE_DIR})
    set(MPEG7Fex_LIBRARIES ${MPEG7Fex_LIBRARY})
    if(NOT MPEG7Fex_FIND_QUIETLY)
        message(STATUS "Found MPEG7Fex  (include: ${MPEG7FEX_INCLUDE_DIRS}, library: ${MPEG7Fex_LIBRARIES})")
    endif(NOT MPEG7Fex_FIND_QUIETLY)
    mark_as_advanced(MPEG7Fex_LIBRARY_DEBUG MPEG7Fex_LIBRARY_RELEASE
                     MPEG7Fex_LIBRARY MPEG7Fex_INCLUDE_DIR MPEG7Fex_ROOT_DIR)
endif()

