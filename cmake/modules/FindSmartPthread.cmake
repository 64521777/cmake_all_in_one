# - Try to find Pthread
#
# The following variables are optionally searched for defaults
#  Pthread_ROOT_DIR:            Base directory where all Pthread components are found
#
# The following are set after configuration is done:
#  Pthread_FOUND
#  Pthread_INCLUDE_DIRS
#  Pthread_LIBRARIES
#  Pthread_LIBRARYRARY_DIRS
include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(PThreads)
	if ( ${PThreads4W_FOUND} )
		set(Pthread_FOUND 1)
		set(Pthread_INCLUDE_DIR ${PThreads4W_INCLUDE_DIR})
		set(Pthread_LIBRARY ${PThreads4W_LIBRARY})
		message(STATUS "vcpkg find pthread")
	endif()
endif()

if(NOT Pthread_FOUND)
	set(Pthread_ROOT_DIR "" CACHE PATH "Folder contains Pthread")
	message(STATUS "direct find pthread")

	find_path(Pthread_INCLUDE_DIR pthread.h
		PATHS ${Pthread_ROOT_DIR}
		PATH_SUFFIXES include pthread/include)
		
	if(MSVC)
		if(CMAKE_CL_64)
			set(SUBPATH x64)
		else(CMAKE_CL_64)
			set(SUBPATH x86)
		endif(CMAKE_CL_64)
		
		find_library(Pthread_LIBRARY pthreadVC2
				PATHS ${Pthread_ROOT_DIR}
				PATH_SUFFIXES ${SUBPATH} pthread/lib)
	else()
		find_library(Pthread_LIBRARY pthread
			PATHS ${Pthread_ROOT_DIR}
			PATH_SUFFIXES lib lib64)
	endif()

	message(STATUS ${Pthread_INCLUDE_DIR} ${Pthread_LIBRARY})

	find_package_handle_standard_args(Pthread 
		FOUND_VAR Pthread_FOUND
		REQUIRED_VARS Pthread_INCLUDE_DIR Pthread_LIBRARY)
endif()

if(Pthread_FOUND)
    set(Pthread_INCLUDE_DIRS ${Pthread_INCLUDE_DIR})
    set(Pthread_LIBRARIES ${Pthread_LIBRARY})
    if(NOT Pthread_FIND_QUIETLY)
        message(STATUS "Found Pthread  (include: ${Pthread_INCLUDE_DIRS}, library: ${Pthread_LIBRARIES})")
    endif(NOT Pthread_FIND_QUIETLY)
    mark_as_advanced(Pthread_LIBRARY_DEBUG Pthread_LIBRARY_RELEASE
                     Pthread_LIBRARY Pthread_INCLUDE_DIR Pthread_ROOT_DIR)
endif()

