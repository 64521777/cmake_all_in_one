# - Try to find DevCommon
#
# The following variables are optionally searched for defaults
#  DevCommon_ROOT_DIR:            Base directory where all DevCommon components are found
#
# The following are set after configuration is done:
#  DevCommon_FOUND
#  DevCommon_INCLUDE_DIRS
#  DevCommon_LIBRARIES
#  DevCommon_LIBRARYRARY_DIRS

set(DevCommon_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" CACHE PATH "Folder contains DevCommon")

include(FindPackageHandleStandardArgs)
include(ConfigDepLibPath)

# DevCommon depend on FreeImage, OpenCV, pthread, FFMPEG,
# Caffe, Boost, protobuf, glog, levelDB, lmdb, xmlrpc, etc
find_package(CommonSDK QUIET)

set(DEP_LIBRARY ZeroMQ CZeroMQ Protobuf XmlRpc CryptoPP Caffe ET199 BGS OpenVINO TensorRT CommonSDK)
ConfigDepLibPath(DEPS DEP_LIBRARY)

find_path(DevCommon_INCLUDE_DIR source/DevCommonSDKConfig.h
	PATHS ${DevCommon_ROOT_DIR}
	PATH_SUFFIXES include Common)

if(MSVC)
    find_library(DevCommon_LIBRARY_RELEASE
        NAMES libDevCommon DevCommon
        PATHS ${DevCommon_ROOT_DIR}
        PATH_SUFFIXES Release)
        
    if( (NOT DevCommon_LIBRARY_RELEASE) AND DevCommon_INCLUDE_DIR)
		set(DevCommon_LIBRARY_RELEASE ${SMART_LIB_OUTPUT_DIR}/Release/DevCommon.lib)
	endif()

    find_library(DevCommon_LIBRARY_DEBUG
        NAMES libDevCommond DevCommond libDevCommon DevCommon
        PATHS ${DevCommon_ROOT_DIR}
        PATH_SUFFIXES Debug)
        
    if( (NOT DevCommon_LIBRARY_DEBUG) AND DevCommon_INCLUDE_DIR)
		set(DevCommon_LIBRARY_DEBUG ${SMART_LIB_OUTPUT_DIR}/Debug/DevCommon.lib)
	endif()    
        
	if( DevCommon_LIBRARY_RELEASE AND DevCommon_LIBRARY_DEBUG )
		set(DevCommon_LIBRARY optimized ${DevCommon_LIBRARY_RELEASE} debug ${DevCommon_LIBRARY_DEBUG})
	endif()
else()
	find_library(DevCommon_LIBRARY libDevCommon.a libDevCommon.so
        PATHS ${DevCommon_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
        
    if( (NOT DevCommon_LIBRARY) AND DevCommon_INCLUDE_DIR)
		set(DevCommon_LIBRARY ${SMART_LIB_OUTPUT_DIR}/libDevCommon.a)
	endif()    
    
endif()

find_package_handle_standard_args(DevCommon 
	FOUND_VAR DevCommon_FOUND
	REQUIRED_VARS DevCommon_INCLUDE_DIR DevCommon_LIBRARY)

if(DevCommon_FOUND)
    set(DevCommon_INCLUDE_DIRS ${DevCommon_INCLUDE_DIR} ${DevCommon_INCLUDE_DIR}/source ${DEPS_INCLUDE_DIRS})
    set(DevCommon_LIBRARIES ${DevCommon_LIBRARY} ${DEPS_LIBS})
	
    if(NOT DevCommon_FIND_QUIETLY)
        message(STATUS "Found DevCommon  (include: ${DevCommon_INCLUDE_DIRS}, library: ${DevCommon_LIBRARIES})")
    endif(NOT DevCommon_FIND_QUIETLY)
    mark_as_advanced(DevCommon_LIBRARY_DEBUG DevCommon_LIBRARY_RELEASE
                     DevCommon_LIBRARY DevCommon_INCLUDE_DIR DevCommon_ROOT_DIR)
endif()

