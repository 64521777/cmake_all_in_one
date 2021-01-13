# - Try to find CothinkingSDK
#
# The following variables are optionally searched for defaults
#  CothinkingSDK_ROOT_DIR:            Base directory where all CothinkingSDK components are found
#
# The following are set after configuration is done:
#  CothinkingSDK_FOUND
#  CothinkingSDK_INCLUDE_DIRS
#  CothinkingSDK_LIBRARIES
#  CothinkingSDK_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

set(CothinkingSDK_ROOT_DIR "" CACHE PATH "Folder contains CothinkingSDK")

# We are testing only a couple of files in the include directories
IF( CMAKE_HOST_SYSTEM_NAME MATCHES ".*ubuntu.*" ) 
    find_path(CothinkingSDK_INCLUDE_DIR mcv_facesdk.h
        PATHS ${CothinkingSDK_ROOT_DIR}
		PATH_SUFFIXES include)

	find_library(FACESDK_LIBRARY
		NAMES facesdk  
		PATHS ${FFMPEG_ROOT_DIR} 
		PATH_SUFFIXES lib lib64 FaceSDK)
	find_library(FACEVERIFY_LIBRARY 
		NAMES faceverify  
		PATHS ${FFMPEG_ROOT_DIR} 
		PATH_SUFFIXES lib lib64 FaceSDK)
	LIST(APPEND CothinkingSDK_LIBRARY 
		${FACESDK_LIBRARY} ${FACEVERIFY_LIBRARY})

endif()

find_package_handle_standard_args(CothinkingSDK 
	FOUND_VAR CothinkingSDK_FOUND
	REQUIRED_VARS CothinkingSDK_INCLUDE_DIR CothinkingSDK_LIBRARY)

if(CothinkingSDK_FOUND)
    set(CothinkingSDK_INCLUDE_DIRS ${CothinkingSDK_INCLUDE_DIR})
    set(CothinkingSDK_LIBRARIES ${CothinkingSDK_LIBRARY})
    if(NOT CothinkingSDK_FIND_QUIETLY)
        message(STATUS "Found CothinkingSDK  (include: ${CothinkingSDK_INCLUDE_DIRS}, library: ${CothinkingSDK_LIBRARIES})")
    endif(NOT CothinkingSDK_FIND_QUIETLY)
    mark_as_advanced(CothinkingSDK_LIBRARY_DEBUG CothinkingSDK_LIBRARY_RELEASE
                     CothinkingSDK_LIBRARY CothinkingSDK_INCLUDE_DIR CothinkingSDK_ROOT_DIR)
endif()
