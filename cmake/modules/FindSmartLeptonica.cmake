# - Try to find Leptonica
#
# The following variables are optionally searched for defaults
#  Leptonica_ROOT_DIR:            Base directory where all Leptonica components are found
#
# The following are set after configuration is done:
#  Leptonica_FOUND
#  Leptonica_INCLUDE_DIRS
#  Leptonica_LIBRARIES
#  Leptonica_LIBRARYRARY_DIRS
include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(leptonica)
	if ( ${leptonica_FOUND} )
		set(Leptonica_FOUND 1)
		set(Leptonica_LIBRARY lmdb)
		message(STATUS "vcpkg find leptonica")
	endif()
endif()

if(NOT Leptonica_FOUND)
	set(Leptonica_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" CACHE PATH "Folder contains Leptonica")

	# Leptonica depend on lept
	find_path(Leptonica_INCLUDE_DIR leptonica/allheaders.h
		PATHS ${Leptonica_ROOT_DIR}
		PATH_SUFFIXES include)

	if(MSVC)
		find_library(Leptonica_LIBRARY_RELEASE
			NAMES lept
			PATHS ${Leptonica_ROOT_DIR}
			PATH_SUFFIXES Release)

		find_library(Leptonica_LIBRARY_DEBUG
			NAMES lept
			PATHS ${Leptonica_ROOT_DIR}
			PATH_SUFFIXES Debug)

		set(Leptonica_LIBRARY optimized ${Leptonica_LIBRARY_RELEASE} debug ${Leptonica_LIBRARY_DEBUG})
	else()	
		find_library(Leptonica_LIBRARY lept
			PATHS ${Leptonica_ROOT_DIR}
			PATH_SUFFIXES lib lib64)
	endif()

	find_package_handle_standard_args(Leptonica 
		FOUND_VAR Leptonica_FOUND
		REQUIRED_VARS Leptonica_INCLUDE_DIR Leptonica_LIBRARY)
endif()

if(Leptonica_FOUND)
    set(Leptonica_INCLUDE_DIRS ${Leptonica_INCLUDE_DIR})
    set(Leptonica_LIBRARIES ${Leptonica_LIBRARY})
    if(NOT Leptonica_FIND_QUIETLY)
        message(STATUS "Found Leptonica  (include: ${Leptonica_INCLUDE_DIRS}, library: ${Leptonica_LIBRARIES})")
    endif(NOT Leptonica_FIND_QUIETLY)
    mark_as_advanced(Leptonica_LIBRARY_DEBUG Leptonica_LIBRARY_RELEASE
					Leptonica_INCLUDE_DIR Leptonica_LIBRARY Leptonica_ROOT_DIR)
endif()

