# - Try to find DataCenterSDK
#
# The following variables are optionally searched for defaults
#  DataCenterSDK_ROOT_DIR:            Base directory where all DataCenterSDK components are found
#
# The following are set after configuration is done:
#  DataCenterSDK_FOUND
#  DataCenterSDK_INCLUDE_DIRS
#  DataCenterSDK_LIBRARIES
#  DataCenterSDK_LIBRARY_DIRS

include(FindPackageHandleStandardArgs)
include(ConfigDepLibPath)

set(DataCenterSDK_ROOT_DIR "" CACHE PATH "Folder contains DataCenterSDK")

# DataCenterSDK depend on vlfeat, CommonSDK, VideoAnalysisSDK
find_package(Caffe QUIET)
find_package(CommonSDK QUIET)

set(DEP_LIBRARY CommonSDK Caffe MySQLCPPCon)
ConfigDepLibPath(DEPS DEP_LIBRARY)

find_path(DataCenterSDK_INCLUDE_DIR DataCenterSDK/DataCenterSDK.h
    PATHS ${DataCenterSDK_ROOT_DIR}
    PATH_SUFFIXES include source)


if(MSVC)
    find_library(DataCenterSDK_LIBRARY_RELEASE
        NAMES DataCenterSDK
        PATHS ${DataCenterSDK_ROOT_DIR}
        PATH_SUFFIXES Release)
    
    if( (NOT DataCenterSDK_LIBRARY_RELEASE) AND DataCenterSDK_INCLUDE_DIR)
		set(DataCenterSDK_LIBRARY_RELEASE ${SMART_LIB_OUTPUT_DIR}/Release/DataCenterSDK.lib)
	endif()

    find_library(DataCenterSDK_LIBRARY_DEBUG
        NAMES DataCenterSDK
        PATHS ${DataCenterSDK_ROOT_DIR}
        PATH_SUFFIXES Debug)
        
    if( (NOT DataCenterSDK_LIBRARY_DEBUG) AND DataCenterSDK_INCLUDE_DIR)
		set(DataCenterSDK_LIBRARY_DEBUG ${SMART_LIB_OUTPUT_DIR}/Debug/DataCenterSDK.lib)
	endif()
        
        
    if(RDataCenterSDK_LIBRARY_RELEASE AND DataCenterSDK_LIBRARY_DEBUG)
        set(DataCenterSDK_LIBRARY optimized ${DataCenterSDK_LIBRARY_RELEASE} debug ${DataCenterSDK_LIBRARY_DEBUG})
    endif()
else()
	find_library(DataCenterSDK_LIBRARY libDataCenterSDK.a libDataCenterSDK.so 
        PATHS ${DataCenterSDK_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
        
    if( (NOT DataCenterSDK_LIBRARY) AND Vlfeat_INCLUDE_DIR)
		set(DataCenterSDK_LIBRARY ${SMART_LIB_OUTPUT_DIR}/libDataCenterSDK.a)
	endif()
endif()

find_package_handle_standard_args(DataCenterSDK 
    FOUND_VAR DataCenterSDK_FOUND
    REQUIRED_VARS DataCenterSDK_INCLUDE_DIR DataCenterSDK_LIBRARY)


if(DataCenterSDK_FOUND)
    set(DataCenterSDK_INCLUDE_DIRS ${DataCenterSDK_INCLUDE_DIR} ${DEPS_INCLUDE_DIRS})
    set(DataCenterSDK_LIBRARIES ${DataCenterSDK_LIBRARY} ${DEPS_LIBS})
    if(NOT DataCenterSDK_FIND_QUIETLY)
        message(STATUS "Found DataCenterSDK  (include: ${DataCenterSDK_INCLUDE_DIRS}, library: ${DataCenterSDK_LIBRARIES})")
    endif(NOT DataCenterSDK_FIND_QUIETLY)
    mark_as_advanced(DataCenterSDK_LIBRARY_DEBUG DataCenterSDK_LIBRARY_RELEASE
                     DataCenterSDK_LIBRARY DataCenterSDK_INCLUDE_DIR DataCenterSDK_ROOT_DIR)
endif()

