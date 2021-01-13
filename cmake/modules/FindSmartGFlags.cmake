# - Try to find GFlags
#
# The following variables are optionally searched for defaults
#  GFlags_ROOT_DIR:            Base directory where all GFlags components are found
#
# The following are set after configuration is done:
#  GFlags_FOUND
#  GFlags_INCLUDE_DIRS
#  GFlags_LIBRARIES
#  GFlags_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(gflags)
	if ( ${gflags_FOUND} )
		set(GFlags_FOUND 1)
		set(GFlags_LIBRARY ${GFLAGS_LIBRARIES})
		message(STATUS "vcpkg find gflags")
	endif()
endif()


if(NOT GFlags_FOUND)
	set(GFlags_ROOT_DIR "" CACHE PATH "Folder contains GFlags")

	# We are testing only a couple of files in the include directories
	if(WIN32)
		find_path(GFlags_INCLUDE_DIR gflags/gflags.h
			PATHS ${GFlags_ROOT_DIR}
			PATH_SUFFIXES include)
	else()
		find_path(GFlags_INCLUDE_DIR gflags/gflags.h
			PATHS ${GFlags_ROOT_DIR}
			PATH_SUFFIXES include)
	endif()

	if(MSVC)
		find_library(GFlags_LIBRARY_RELEASE
			NAMES libgflags gflags
			PATHS ${GFlags_ROOT_DIR}
			PATH_SUFFIXES lib lib/Release Release)

		find_library(GFlags_LIBRARY_DEBUG
			NAMES gflagsd gflags
			PATHS ${GFlags_ROOT_DIR}
			PATH_SUFFIXES lib lib/Debug Debug)

		set(GFlags_LIBRARY optimized ${GFlags_LIBRARY_RELEASE} debug ${GFlags_LIBRARY_DEBUG})
	else()
		find_library(GFlags_LIBRARY 
			NAMES gflags
			PATHS ${GFlags_ROOT_DIR}
			PATH_SUFFIXES lib lib64)
	endif()

	find_package_handle_standard_args(GFlags 
		FOUND_VAR GFlags_FOUND
		REQUIRED_VARS GFlags_INCLUDE_DIR GFlags_LIBRARY)
endif()

if(GFlags_FOUND)
    set(GFlags_INCLUDE_DIRS ${GFlags_INCLUDE_DIR})
    # gflags depend on shlwapi under windows
    if(WIN32)
        set(GFlags_LIBRARIES ${GFlags_LIBRARY} shlwapi)
    else(WIN32)
        set(GFlags_LIBRARIES ${GFlags_LIBRARY})
    endif(WIN32)
    if(NOT GFlags_FIND_QUIETLY)
        message(STATUS "Found GFlags  (include: ${GFlags_INCLUDE_DIRS}, library: ${GFlags_LIBRARIES})")
    endif(NOT GFlags_FIND_QUIETLY)
    mark_as_advanced(GFlags_LIBRARY_DEBUG GFlags_LIBRARY_RELEASE
                     GFlags_LIBRARY GFlags_INCLUDE_DIR GFlags_ROOT_DIR)
endif()
