# - Try to find CommonSDK
#
# The following variables are optionally searched for defaults
#  CommonSDK_ROOT_DIR:            Base directory where all CommonSDK components are found
#
# The following are set after configuration is done:
#  CommonSDK_FOUND
#  CommonSDK_INCLUDE_DIRS
#  CommonSDK_LIBRARIES
#  CommonSDK_LIBRARYRARY_DIRS

set(CommonSDK_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" CACHE PATH "Folder contains CommonSDK")

include(FindPackageHandleStandardArgs)
include(ConfigDepLibPath)


# CommonSDK depend on FreeImage, OpenCV, pthread, FFMPEG,
# Caffe, Boost, protobuf, glog, levelDB, lmdb, xmlrpc, etc

set(DEP_LIBRARY FreeImage OpenCV Pthread FFMPEG Protobuf Glog LevelDB LMDB XmlRpc Boost CryptoPP Caffe ET199)
ConfigDepLibPath(DEPS DEP_LIBRARY)

find_path(CommonSDK_INCLUDE_DIR util/stdheader.h
	PATHS ${CommonSDK_ROOT_DIR}
	PATH_SUFFIXES include source)

if(MSVC)
    find_library(CommonSDK_LIBRARY_RELEASE
        NAMES libCommonSDK CommonSDK
        PATHS ${CommonSDK_ROOT_DIR}
        PATH_SUFFIXES Release)
        
    if( (NOT CommonSDK_LIBRARY_RELEASE) AND CommonSDK_INCLUDE_DIR)
		set(CommonSDK_LIBRARY_RELEASE ${SMART_LIB_OUTPUT_DIR}/Release/CommonSDK.lib)
	endif()

    find_library(CommonSDK_LIBRARY_DEBUG
        NAMES libCommonSDKd CommonSDKd libCommonSDK CommonSDK
        PATHS ${CommonSDK_ROOT_DIR}
        PATH_SUFFIXES Debug)
        
    if( (NOT CommonSDK_LIBRARY_DEBUG) AND CommonSDK_INCLUDE_DIR)
		set(CommonSDK_LIBRARY_DEBUG ${SMART_LIB_OUTPUT_DIR}/Debug/CommonSDK.lib)
	endif()    
        
	if( CommonSDK_LIBRARY_RELEASE AND CommonSDK_LIBRARY_DEBUG )
		set(CommonSDK_LIBRARY optimized ${CommonSDK_LIBRARY_RELEASE} debug ${CommonSDK_LIBRARY_DEBUG})
	endif()
else()
	find_library(CommonSDK_LIBRARY libCommonSDK.a libCommonSDK.so
        PATHS ${CommonSDK_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
        
    if( (NOT CommonSDK_LIBRARY) AND CommonSDK_INCLUDE_DIR)
		set(CommonSDK_LIBRARY ${SMART_LIB_OUTPUT_DIR}/libCommonSDK.a)
	endif()    
    
endif()

find_package_handle_standard_args(CommonSDK 
	FOUND_VAR CommonSDK_FOUND
	REQUIRED_VARS CommonSDK_INCLUDE_DIR CommonSDK_LIBRARY)

if(CommonSDK_FOUND)
    set(CommonSDK_INCLUDE_DIRS ${CommonSDK_INCLUDE_DIR} ${DEPS_INCLUDE_DIRS})
	
	# 利用性能计数器pdh读取cpu,内存,磁盘性能
	if(MSVC)
        set(CommonSDK_LIBRARIES ${CommonSDK_LIBRARY} ${DEPS_LIBS}  pdh)
    else(MSVC)
        set(CommonSDK_LIBRARIES ${CommonSDK_LIBRARY} ${DEPS_LIBS})
    endif(MSVC)
	
    if(NOT CommonSDK_FIND_QUIETLY)
        message(STATUS "Found CommonSDK  (include: ${CommonSDK_INCLUDE_DIRS}, library: ${CommonSDK_LIBRARIES})")
    endif(NOT CommonSDK_FIND_QUIETLY)
    mark_as_advanced(CommonSDK_LIBRARY_DEBUG CommonSDK_LIBRARY_RELEASE
                     CommonSDK_LIBRARY CommonSDK_INCLUDE_DIR CommonSDK_ROOT_DIR)
endif()

