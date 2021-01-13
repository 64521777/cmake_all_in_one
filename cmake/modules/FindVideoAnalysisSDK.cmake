# - Try to find VideoAnalysisSDK
#
# The following variables are optionally searched for defaults
#  VideoAnalysisSDK_ROOT_DIR:            Base directory where all VideoAnalysisSDK components are found
#
# The following are set after configuration is done:
#  VideoAnalysisSDK_FOUND
#  VideoAnalysisSDK_INCLUDE_DIRS
#  VideoAnalysisSDK_LIBRARIES
#  VideoAnalysisSDK_LIBRARY_DIRS

include(FindPackageHandleStandardArgs)
include(ConfigDepLibPath)

set(VideoAnalysisSDK_ROOT_DIR "" CACHE PATH "Folder contains VideoAnalysisSDK")

# vfp depend on vlfeat, CommonSDK, VideoAnalysisSDK
find_package(CommonSDK QUIET)
find_package(ImageAnalysisSDK QUIET)

set(DEP_LIBRARY ImageAnalysisSDK CommonSDK OpenCV)
ConfigDepLibPath(DEPS DEP_LIBRARY)

find_path(VideoAnalysisSDK_INCLUDE_DIR VideoAnalysisSDK/VideoAnalysisSDK.h
    PATHS ${VideoAnalysisSDK_ROOT_DIR}
    PATH_SUFFIXES include source)

if(MSVC)
    find_library(VideoAnalysisSDK_LIBRARY_RELEASE
        NAMES VideoAnalysisSDK
        PATHS ${VideoAnalysisSDK_ROOT_DIR}
        PATH_SUFFIXES Release)
    
    if( (NOT VideoAnalysisSDK_LIBRARY_RELEASE) AND VideoAnalysisSDK_INCLUDE_DIR)
		set(VideoAnalysisSDK_LIBRARY_RELEASE ${SMART_LIB_OUTPUT_DIR}/Release/VideoAnalysisSDK.lib)
	endif()

    find_library(VideoAnalysisSDK_LIBRARY_DEBUG
        NAMES VideoAnalysisSDK
        PATHS ${VideoAnalysisSDK_ROOT_DIR}
        PATH_SUFFIXES Debug)
    
    if( (NOT VideoAnalysisSDK_LIBRARY_DEBUG) AND VideoAnalysisSDK_INCLUDE_DIR)
		set(VideoAnalysisSDK_LIBRARY_DEBUG ${SMART_LIB_OUTPUT_DIR}/Debug/VideoAnalysisSDK.lib)
	endif()
    
	if(VideoAnalysisSDK_LIBRARY_RELEASE AND VideoAnalysisSDK_LIBRARY_DEBUG)
        set(VideoAnalysisSDK_LIBRARY optimized ${VideoAnalysisSDK_LIBRARY_RELEASE} debug ${VideoAnalysisSDK_LIBRARY_DEBUG})
	endif()
else()
	find_library(VideoAnalysisSDK_LIBRARY libVideoAnalysisSDK.a libVideoAnalysisSDK.so 
        PATHS ${VideoAnalysisSDK_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
        
    if( (NOT VideoAnalysisSDK_LIBRARY) AND VideoAnalysisSDK_INCLUDE_DIR)
		set(VideoAnalysisSDK_LIBRARY ${SMART_LIB_OUTPUT_DIR}/libVideoAnalysisSDK.a)
	endif()
endif()

find_package_handle_standard_args(VideoAnalysisSDK 
    FOUND_VAR VideoAnalysisSDK_FOUND
    REQUIRED_VARS VideoAnalysisSDK_INCLUDE_DIR VideoAnalysisSDK_LIBRARY)


if(VideoAnalysisSDK_FOUND)
    set(VideoAnalysisSDK_INCLUDE_DIRS ${VideoAnalysisSDK_INCLUDE_DIR} ${DEPS_INCLUDE_DIRS})
    set(VideoAnalysisSDK_LIBRARIES ${VideoAnalysisSDK_LIBRARY} ${DEPS_LIBS})
    if(NOT VideoAnalysisSDK_FIND_QUIETLY)
        message(STATUS "Found VideoAnalysisSDK  (include: ${VideoAnalysisSDK_INCLUDE_DIRS}, library: ${VideoAnalysisSDK_LIBRARIES})")
    endif(NOT VideoAnalysisSDK_FIND_QUIETLY)
    mark_as_advanced(VideoAnalysisSDK_LIBRARY_DEBUG VideoAnalysisSDK_LIBRARY_RELEASE
                     VideoAnalysisSDK_LIBRARY VideoAnalysisSDK_INCLUDE_DIR VideoAnalysisSDK_ROOT_DIR)
endif()

