# Try to find the FFTW libraries and headers
#  FFTW_FOUND - system has FFTW lib
#  FFTW_INCLUDE_DIR - the FFTW include directory
#  FFTW_LIBRARIES - Libraries needed to use FFTW


include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(FFTW3)
	if ( ${FFTW3_FOUND} )
		set(FFTW_FOUND 1)
		set(FFTW_LIBRARY FFTW3::fftw3)
		message(STATUS "vcpkg find fftw")
	endif()
endif()


if(NOT FFTW_FOUND)
	set(FFTW_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" CACHE PATH "Folder contains FFTW")
	
	message(STATUS "try to direct find fftw")

	find_path(FFTW_INCLUDE_DIR 
		NAMES  dlib/image_processing.h 
		PATHS ${FFTW_ROOT_DIR}
		PATH_SUFFIXES include)

	if(MSVC)	
		find_library(FFTW3_LIBRARY
			NAMES libfftw3-3  
			PATHS ${FFTW_ROOT_DIR} 
			PATH_SUFFIXES lib lib64)
		find_library(FFTW3f_LIBRARY 
			NAMES libfftw3f-3  
			PATHS ${FFTW_ROOT_DIR} 
			PATH_SUFFIXES lib lib64)
		find_library(FFTW3l_LIBRARY 
			NAMES libfftw3l-3v  
			PATHS ${FFTW_ROOT_DIR} 
			PATH_SUFFIXES lib lib64)
		LIST(APPEND FFTW_LIBRARY ${FFTW3_LIBRARY} ${FFTW3f_LIBRARY} ${FFTW3l_LIBRARY})
	else(MSVC)
		find_library(FFTW3_LIBRARY 
			NAMES fftw3 libfftw3.so.3
			PATHS ${FFTW_ROOT_DIR} 
			PATH_SUFFIXES lib lib64)		
		find_library(FFTW3f_LIBRARY 
			NAMES fftw3f libfftw3f.so.3 
			PATHS ${FFTW_ROOT_DIR} 
			PATH_SUFFIXES lib lib64)
		LIST(APPEND FFTW_LIBRARY ${FFTW3_LIBRARY} ${FFTW3f_LIBRARY})
	endif(MSVC)


	include(FindPackageHandleStandardArgs)
	find_package_handle_standard_args(FFTW
		FOUND_VAR FFTW_FOUND
		REQUIRED_VARS FFTW_INCLUDE_DIR FFTW_LIBRARY)
endif()
		
if(FFTW_FOUND)
  set(FFTW_INCLUDE_DIRS ${FFTW_INCLUDE_DIR})
  set(FFTW_LIBRARIES ${FFTW_LIBRARY})
  if(NOT FFTW_FIND_QUIETLY)
    message(STATUS "Found FFTW    (include: ${FFTW_INCLUDE_DIRS}, library: ${FFTW_LIBRARIES})")
  endif(NOT FFTW_FIND_QUIETLY)
  mark_as_advanced(FFTW_INCLUDE_DIR FFTW_LIBRARY)
endif()
