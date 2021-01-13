# Try to find the DLIB libraries and headers
#  
#  ZeroMQ_FOUND - system has ZeroMQ lib
#  ZeroMQ_INCLUDE_DIR - the ZeroMQ include directory
#  ZeroMQ_LIBRARIES - Libraries needed to use ZeroMQ

include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(ZeroMQ)
	if (ZeroMQ_FOUND)
		set(ZeroMQ_LIBRARY ${ZeroMQ_STATIC_LIBRARY})
		message(STATUS "vcpkg find ZeroMQ")
	endif()
endif()

if(NOT ZeroMQ_FOUND)

    find_path(ZeroMQ_INCLUDE_DIR 
        NAMES  zmq.h 
        PATHS ${ZeroMQ_ROOT_DIR}
        PATH_SUFFIXES include)

    if(MSVC)
        find_library(ZeroMQ_LIBRARY_RELEASE
            NAMES zmq
            PATHS ${ZeroMQ_ROOT_DIR}
            PATH_SUFFIXES lib Release)

        find_library(ZeroMQ_LIBRARY_DEBUG
            NAMES zmqd zmq
            PATHS ${ZeroMQ_ROOT_DIR}
            PATH_SUFFIXES lib Debug)

        set(ZeroMQ_LIBRARY optimized ${ZeroMQ_LIBRARY_RELEASE} debug ${ZeroMQ_LIBRARY_DEBUG})
    else()	
        find_library(ZeroMQ_LIBRARY 
            NAMES zmq   
            PATHS ${ZeroMQ_ROOT_DIR} 
            PATH_SUFFIXES lib lib64)
    endif(MSVC)


	find_package_handle_standard_args(ZeroMQ
		FOUND_VAR ZeroMQ_FOUND
		REQUIRED_VARS ZeroMQ_INCLUDE_DIR ZeroMQ_LIBRARY)
endif()

if(ZeroMQ_FOUND)
  set(ZeroMQ_INCLUDE_DIRS ${ZeroMQ_INCLUDE_DIR})
  set(ZeroMQ_LIBRARIES ${ZeroMQ_LIBRARY})
  if(NOT ZeroMQ_FIND_QUIETLY)
    message(STATUS "Found zmq    (include: ${ZeroMQ_INCLUDE_DIRS}, library: ${ZeroMQ_LIBRARIES})")
  endif(NOT ZeroMQ_FIND_QUIETLY)
  mark_as_advanced(ZeroMQ_LIBRARY_RELEASE ZeroMQ_LIBRARY_DEBUG
	ZeroMQ_INCLUDE_DIR ZeroMQ_LIBRARY)
endif()
