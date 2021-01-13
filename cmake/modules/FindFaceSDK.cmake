# - Try to find FaceSDK
#
# The following variables are optionally searched for defaults
#  FaceSDK_ROOT_DIR:            Base directory where all FaceSDK components are found
#
# The following are set after configuration is done:
#  FaceSDK_FOUND
#  FaceSDK_INCLUDE_DIRS
#  FaceSDK_LIBRARIES
#  FaceSDK_LIBRARYRARY_DIR
include(FindPackageHandleStandardArgs)
include(ConfigDepLibPath)

set(WITH_CW_FACE 0)
set(FaceSDK_ROOT_DIR "" CACHE PATH "Folder contains FaceSDK")

# FaceSDK depend on CommonSDK, CothinkingSDK, dlib, Caffe, OpenCV
find_package(CommonSDK QUIET)
find_package(CothinkingSDK QUIET)

set(DEP_LIBRARY CommonSDK CothinkingSDK dlib Caffe OpenCV)
ConfigDepLibPath(DEPS DEP_LIBRARY)

find_path(FaceSDK_INCLUDE_DIR SmartVisionFaceSDK.h
    PATHS ${FaceSDK_ROOT_DIR}
    PATH_SUFFIXES FaceSDK)


if(MSVC)
    find_library(FaceSDK_LIBRARY_RELEASE
        NAMES FaceSDK
        PATHS ${FaceSDK_ROOT_DIR}
        PATH_SUFFIXES Release)
        
    if( (NOT FaceSDK_LIBRARY_RELEASE) AND FaceSDK_INCLUDE_DIR)
		set(FaceSDK_LIBRARY_RELEASE ${SMART_LIB_OUTPUT_DIR}/Release/vfpsdk.lib)
	endif()

    find_library(FaceSDK_LIBRARY_DEBUG
        NAMES FaceSDK
        PATHS ${FaceSDK_ROOT_DIR}
        PATH_SUFFIXES Debug)
        
    if( (NOT FaceSDK_LIBRARY_DEBUG) AND FaceSDK_INCLUDE_DIR)
		set(FaceSDK_LIBRARY_DEBUG ${SMART_LIB_OUTPUT_DIR}/Release/vfpsdk.lib)
	endif()
    
    if(FaceSDK_LIBRARY_RELEASE AND FaceSDK_LIBRARY_DEBUG)
        set(FaceSDK_LIBRARY optimized ${FaceSDK_LIBRARY_RELEASE} debug ${FaceSDK_LIBRARY_DEBUG})
    endif()
else()
	find_library(FaceSDK_LIBRARY libFaceSDK.a libFaceSDK.so 
        PATHS ${FaceSDK_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
        
    #if( (NOT FaceSDK_LIBRARY) AND FaceSDK_INCLUDE_DIR)
	#	set(FaceSDK_LIBRARY ${SMART_LIB_OUTPUT_DIR}/libFaceSDK.a)
	#endif()
endif()

find_package_handle_standard_args(FaceSDK
    FOUND_VAR FaceSDK_FOUND
    REQUIRED_VARS FaceSDK_INCLUDE_DIR FaceSDK_LIBRARY)


if(FaceSDK_FOUND)
    set(FaceSDK_INCLUDE_DIRS ${FaceSDK_INCLUDE_DIR} ${DEPS_INCLUDE_DIRS})
    set(FaceSDK_LIBRARIES ${FaceSDK_LIBRARY} ${DEPS_LIBS})
    if(WITH_CW_FACE)
        set(FaceSDK_LIBRARIES ${FaceSDK_LIBRARIES} /opt/share/CW_Face/lib64/libCWFaceSDK.so)
    endif(WITH_CW_FACE)
    if(NOT FaceSDK_FIND_QUIETLY)
        message(STATUS "Found FaceSDK  (include: ${FaceSDK_INCLUDE_DIRS}, library: ${FaceSDK_LIBRARIES})")
    endif(NOT FaceSDK_FIND_QUIETLY)
    mark_as_advanced(FaceSDK_LIBRARY_DEBUG FaceSDK_LIBRARY_RELEASE
                     FaceSDK_LIBRARY FaceSDK_INCLUDE_DIR FaceSDK_ROOT_DIR)
endif()

