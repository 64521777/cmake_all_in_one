# Try to find the DLIB libraries and headers
#  CCV_FOUND - system has CCV lib
#  CCV_INCLUDE_DIR - the CCV include directory
#  CCV_LIBRARIES - Libraries needed to use CCV

set(CCV_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" CACHE PATH "Folder contains LIBCCV")

find_path(CCV_INCLUDE_DIR 
	NAMES  ccv.h 	
	PATHS ${CCV_ROOT_DIR}
	PATH_SUFFIXES include)

find_library(CCV_LIBRARY 
	NAMES ccv   
	PATHS ${CCV_ROOT_DIR}
	PATH_SUFFIXES lib lib64)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CCV
	FOUND_VAR CCV_FOUND
	REQUIRED_VARS CCV_INCLUDE_DIR CCV_LIBRARY)

if(CCV_FOUND)
  set(CCV_INCLUDE_DIRS ${CCV_INCLUDE_DIR})
  set(CCV_LIBRARIES ${CCV_LIBRARY})
  if(NOT CCV_FIND_QUIETLY)
    message(STATUS "Found ccv    (include: ${CCV_INCLUDE_DIRS}, library: ${CCV_LIBRARIES})")
  endif(NOT CCV_FIND_QUIETLY)
  mark_as_advanced(CCV_INCLUDE_DIR CCV_LIBRARY)
endif()
