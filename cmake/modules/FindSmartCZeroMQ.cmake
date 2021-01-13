# Try to find the DLIB libraries and headers
#  
#  CZeroMQ_FOUND - system has CZeroMQ lib
#  CZeroMQ_INCLUDE_DIR - the CZeroMQ include directory
#  CZeroMQ_LIBRARIES - Libraries needed to use CZeroMQ

include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(czmq)
	if (czmq_FOUND)
		set(CZeroMQ_FOUND 1)
		set(CZeroMQ_LIBRARY czmq-static)
		message(STATUS "vcpkg find czmq")
	endif()
endif()


if(NOT CZeroMQ_FOUND)
    find_path(CZeroMQ_INCLUDE_DIR 
        NAMES  czmq.h 
        PATHS ${CZeroMQ_ROOT_DIR}
        PATH_SUFFIXES include)

    if(MSVC)
        find_library(CZeroMQ_LIBRARY_RELEASE
            NAMES czmq
            PATHS ${CZeroMQ_ROOT_DIR}
            PATH_SUFFIXES lib Release)

        find_library(CZeroMQ_LIBRARY_DEBUG
            NAMES zmqd czmq
            PATHS ${CZeroMQ_ROOT_DIR}
            PATH_SUFFIXES lib Debug)

        set(CZeroMQ_LIBRARY optimized ${CZeroMQ_LIBRARY_RELEASE} debug ${CZeroMQ_LIBRARY_DEBUG})
    else()	
        find_library(CZeroMQ_LIBRARY 
            NAMES czmq   
            PATHS ${CZeroMQ_ROOT_DIR} 
            PATH_SUFFIXES lib lib64)
    endif(MSVC)

	find_package_handle_standard_args(CZeroMQ
		FOUND_VAR CZeroMQ_FOUND
		REQUIRED_VARS CZeroMQ_INCLUDE_DIR CZeroMQ_LIBRARY)
endif()

if(CZeroMQ_FOUND)
  set(CZeroMQ_INCLUDE_DIRS ${CZeroMQ_INCLUDE_DIR})
  set(CZeroMQ_LIBRARIES ${CZeroMQ_LIBRARY})
  if(NOT CZeroMQ_FIND_QUIETLY)
    message(STATUS "Found czmq    (include: ${CZeroMQ_INCLUDE_DIRS}, library: ${CZeroMQ_LIBRARIES})")
  endif(NOT CZeroMQ_FIND_QUIETLY)
  mark_as_advanced(CZeroMQ_LIBRARY_RELEASE CZeroMQ_LIBRARY_DEBUG
	CZeroMQ_INCLUDE_DIR CZeroMQ_LIBRARY)
endif()
