# - Try to find ET199
#
# The following variables are optionally searched for defaults
#  ET199_ROOT_DIR:            Base directory where all ET199 components are found
#
# The following are set after configuration is done:
#  ET199_FOUND
#  ET199_INCLUDE_DIRS
#  ET199_LIBRARIES
#  ET199_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

set(ET199_ROOT_DIR "" CACHE PATH "Folder contains ET199")

find_path(ET199_INCLUDE_DIR et199_32.h
	PATHS ${ET199_ROOT_DIR}
	PATH_SUFFIXES include et199)

if(MSVC)
	if(CMAKE_CL_64)
		find_library(ET199_LIBRARY ET199_64
			PATHS ${ET199_ROOT_DIR}
			PATH_SUFFIXES lib et199)
	else(CMAKE_CL_64)
		find_library(ET199_LIBRARY ET199_32
			PATHS ${ET199_ROOT_DIR}
			PATH_SUFFIXES lib et199)
	endif(CMAKE_CL_64)
else()
	find_library(ET199_LIBRARY libET199.so 
        PATHS ${ET199_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
endif()

find_package_handle_standard_args(ET199 
	FOUND_VAR ET199_FOUND
	REQUIRED_VARS ET199_INCLUDE_DIR ET199_LIBRARY)

if(ET199_FOUND)
    set(ET199_INCLUDE_DIRS ${ET199_INCLUDE_DIR})
    set(ET199_LIBRARIES ${ET199_LIBRARY})
    if(NOT ET199_FIND_QUIETLY)
        message(STATUS "Found ET199  (include: ${ET199_INCLUDE_DIRS}, library: ${ET199_LIBRARIES})")
    endif(NOT ET199_FIND_QUIETLY)
    mark_as_advanced(ET199_LIBRARY_DEBUG ET199_LIBRARY_RELEASE
                     ET199_LIBRARY ET199_INCLUDE_DIR ET199_ROOT_DIR)
endif()

