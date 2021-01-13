# - Try to find RecognitionSDK
#
# The following variables are optionally searched for defaults
#  RecognitionSDK_ROOT_DIR:            Base directory where all RecognitionSDK components are found
#
# The following are set after configuration is done:
#  RecognitionSDK_FOUND
#  RecognitionSDK_INCLUDE_DIRS
#  RecognitionSDK_LIBRARIES
#  RecognitionSDK_LIBRARY_DIRS

include(FindPackageHandleStandardArgs)
include(ConfigDepLibPath)

set(RecognitionSDK_ROOT_DIR "" CACHE PATH "Folder contains RecognitionSDK")

# RecognitionSDK depend on vlfeat, CommonSDK, VideoAnalysisSDK
find_package(CommonSDK QUIET)

set(DEP_LIBRARY CommonSDK Caffe)
ConfigDepLibPath(DEPS DEP_LIBRARY)

find_path(RecognitionSDK_INCLUDE_DIR SmartVisionRecognitionSDK.h
    PATHS ${RecognitionSDK_ROOT_DIR}
    PATH_SUFFIXES RecognitionSDK)

if(MSVC)
    find_library(RecognitionSDK_LIBRARY_RELEASE
        NAMES RecognitionSDK
        PATHS ${RecognitionSDK_ROOT_DIR}
        PATH_SUFFIXES Release)
    
    if( (NOT RecognitionSDK_LIBRARY_RELEASE) AND RecognitionSDK_INCLUDE_DIR)
		set(RecognitionSDK_LIBRARY_RELEASE ${SMART_LIB_OUTPUT_DIR}/Release/RecognitionSDK.lib)
	endif()

    find_library(RecognitionSDK_LIBRARY_DEBUG
        NAMES RecognitionSDK
        PATHS ${RecognitionSDK_ROOT_DIR}
        PATH_SUFFIXES Debug)
        
    if( (NOT RecognitionSDK_LIBRARY_DEBUG) AND RecognitionSDK_INCLUDE_DIR)
		set(RecognitionSDK_LIBRARY_DEBUG ${SMART_LIB_OUTPUT_DIR}/Debug/RecognitionSDK.lib)
	endif()
        
        
    if(RecognitionSDK_LIBRARY_RELEASE AND RecognitionSDK_LIBRARY_DEBUG)
        set(RecognitionSDK_LIBRARY optimized ${RecognitionSDK_LIBRARY_RELEASE} debug ${RecognitionSDK_LIBRARY_DEBUG})
    endif()
else()
	find_library(RecognitionSDK_LIBRARY libRecognitionSDK.a libRecognitionSDK.so 
        PATHS ${RecognitionSDK_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
        
    if( (NOT RecognitionSDK_LIBRARY) AND Vlfeat_INCLUDE_DIR)
		set(RecognitionSDK_LIBRARY ${SMART_LIB_OUTPUT_DIR}/libRecognitionSDK.a)
	endif()
endif()

find_package_handle_standard_args(RecognitionSDK 
    FOUND_VAR RecognitionSDK_FOUND
    REQUIRED_VARS RecognitionSDK_INCLUDE_DIR RecognitionSDK_LIBRARY)


if(RecognitionSDK_FOUND)
    message("RecognitionSDK_INCLUDE_DIR: ${RecognitionSDK_INCLUDE_DIR}")
	set(RecognitionSDK_INCLUDE_DIRS ${RecognitionSDK_INCLUDE_DIR} ${RecognitionSDK_INCLUDE_DIR}/source ${DEPS_INCLUDE_DIRS})
	message("RecognitionSDK_INCLUDE_DIRS: ${RecognitionSDK_INCLUDE_DIRS}")
    set(RecognitionSDK_LIBRARIES ${RecognitionSDK_LIBRARY} ${DEPS_LIBS})
    if(NOT RecognitionSDK_FIND_QUIETLY)
        message(STATUS "Found RecognitionSDK  (include: ${RecognitionSDK_INCLUDE_DIRS}, library: ${RecognitionSDK_LIBRARIES})")
    endif(NOT RecognitionSDK_FIND_QUIETLY)
    mark_as_advanced(RecognitionSDK_LIBRARY_DEBUG RecognitionSDK_LIBRARY_RELEASE
                     RecognitionSDK_LIBRARY RecognitionSDK_INCLUDE_DIR RecognitionSDK_ROOT_DIR)
endif()

