# Try to find the FFMPEG libraries and headers
#  FFMPEG_FOUND - system has FFMPEG lib
#  FFMPEG_INCLUDE_DIRS - the FFMPEG include directory
#  FFMPEG_LIBRARIES - Libraries needed to use FFMPEG
#  FFMPEG_LIB_DIRS - 

include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(FFMPEG)
	# vcpkg's FindFFMPEG.cmake 没有定义 FFMPEG_FOUND
	if (FFMPEG_FOUND OR FFMPEG_LIBRARIES)
		set(FFMPEG_FOUND 1)
		message(STATUS "vcpkg find ffmpeg")
	endif()
endif()

if (NOT FFMPEG_FOUND)
	set(FFMPEG_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" CACHE PATH "Folder contains FFMPEG")
	
	message(STATUS "try to direct find ffmpeg")

	find_path(AVCODEC_INCLUDE_DIR 
		NAMES libavcodec/avcodec.h 
		PATHS ${FFMPEG_ROOT_DIR}
		PATH_SUFFIXES include FFInterface/include)

	find_path(AVFORMAT_INCLUDE_DIR 
		NAMES libavformat/avformat.h
		PATHS ${FFMPEG_ROOT_DIR}
		PATH_SUFFIXES include FFInterface/include)

	find_path(AVUTIL_INCLUDE_DIR 
		NAMES libavutil/imgutils.h 
		PATHS ${FFMPEG_ROOT_DIR}
		PATH_SUFFIXES include FFInterface/include)
		
	find_path(SWSCALE_INCLUDE_DIR 
		NAMES libswscale/swscale.h 
		PATHS ${FFMPEG_ROOT_DIR}
		PATH_SUFFIXES include FFInterface/include)
		
	LIST(APPEND FFMPEG_INCLUDE_DIR ${AVCODEC_INCLUDE_DIR} 
		${AVFORMAT_INCLUDE_DIR} ${AVUTIL_INCLUDE_DIR} ${SWSCALE_INCLUDE_DIR})
	LIST(REMOVE_DUPLICATES FFMPEG_INCLUDE_DIR)

	find_library(AVCODEC_LIBRARY
		NAMES avcodec  
		PATHS ${FFMPEG_ROOT_DIR} 
		PATH_SUFFIXES lib lib64 FFInterface/lib)
	find_library(AVFORMAT_LIBRARY 
		NAMES avformat  
		PATHS ${FFMPEG_ROOT_DIR} 
		PATH_SUFFIXES lib lib64 FFInterface/lib)
	find_library(SWSCALE_LIBRARY 
		NAMES swscale  
		PATHS ${FFMPEG_ROOT_DIR} 
		PATH_SUFFIXES lib lib64 FFInterface/lib)
	find_library(AVUTIL_LIBRARY 
		NAMES avutil
		PATHS ${FFMPEG_ROOT_DIR} 
		PATH_SUFFIXES lib lib64 FFInterface/lib)		
	find_library(SWRESAMPLE_LIBRARY 
		NAMES swresample
		PATHS ${FFMPEG_ROOT_DIR} 
		PATH_SUFFIXES lib lib64 FFInterface/lib)
	LIST(APPEND FFMPEG_LIBRARY ${AVCODEC_LIBRARY} ${AVFORMAT_LIBRARY}
		${SWSCALE_LIBRARY} ${AVUTIL_LIBRARY} ${SWRESAMPLE_LIBRARY})

	include(FindPackageHandleStandardArgs)
	find_package_handle_standard_args(FFMPEG
		FOUND_VAR FFMPEG_FOUND
		REQUIRED_VARS FFMPEG_INCLUDE_DIR FFMPEG_LIBRARY)

	if(FFMPEG_FOUND)
	  set(FFMPEG_INCLUDE_DIRS ${FFMPEG_INCLUDE_DIR})
	  set(FFMPEG_LIBRARIES ${FFMPEG_LIBRARY})
	  if(NOT FFMPEG_FIND_QUIETLY)
		message(STATUS "Found FFMPEG    (include: ${FFMPEG_INCLUDE_DIRS}, library: ${FFMPEG_LIBRARIES})")
	  endif(NOT FFMPEG_FIND_QUIETLY)
	  mark_as_advanced(AVCODEC_INCLUDE_DIR AVFORMAT_INCLUDE_DIR AVUTIL_INCLUDE_DIR SWSCALE_INCLUDE_DIR
		AVCODEC_LIBRARY AVFORMAT_LIBRARY SWSCALE_LIBRARY AVUTIL_LIBRARY SWRESAMPLE_LIBRARY
		FFMPEG_INCLUDE_DIR FFMPEG_LIBRARY)
	endif()
endif()

