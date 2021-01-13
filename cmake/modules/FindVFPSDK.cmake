# - Try to find VFPSDK
#
# The following variables are optionally searched for defaults
#  VFPSDK_ROOT_DIR:            Base directory where all VFPSDK components are found
#
# The following are set after configuration is done:
#  VFPSDK_FOUND
#  VFPSDK_INCLUDE_DIRS
#  VFPSDK_LIBRARIES
#  VFPSDK_LIBRARY_DIRS

include(FindPackageHandleStandardArgs)
include(ConfigDepLibPath)

set(VFPSDK_ROOT_DIR "" CACHE PATH "Folder contains VFPSDK")

# vfpsdk depend on vlfeat, CommonSDK, DevCommon
find_package(CommonSDK QUIET)
find_package(DevCommon QUIET)

set(DEP_LIBRARY DevCommon CommonSDK Vlfeat)
ConfigDepLibPath(DEPS DEP_LIBRARY)

find_path(VFPSDK_INCLUDE_DIR VFPSDK/SmartVisionVFPSDK.h
    PATHS ${VFPSDK_ROOT_DIR}
    PATH_SUFFIXES include source)


if(MSVC)
    find_library(VFPSDK_LIBRARY_RELEASE
        NAMES vfpsdk
        PATHS ${VFPSDK_ROOT_DIR}
        PATH_SUFFIXES Release)
    
    if( (NOT VFPSDK_LIBRARY_RELEASE) AND VFPSDK_INCLUDE_DIR)
		set(VFPSDK_LIBRARY_RELEASE ${SMART_LIB_OUTPUT_DIR}/Release/vfpsdk.lib)
	endif()

    find_library(VFPSDK_LIBRARY_DEBUG
        NAMES vfpsdk
        PATHS ${VFPSDK_ROOT_DIR}
        PATH_SUFFIXES Debug)
        
    if( (NOT VFPSDK_LIBRARY_DEBUG) AND VFPSDK_INCLUDE_DIR)
		set(VFPSDK_LIBRARY_DEBUG ${SMART_LIB_OUTPUT_DIR}/Debug/vfpsdk.lib)
	endif()
        
        
    if(VFPSDK_LIBRARY_RELEASE AND VFPSDK_LIBRARY_DEBUG)
        set(VFPSDK_LIBRARY optimized ${VFPSDK_LIBRARY_RELEASE} debug ${VFPSDK_LIBRARY_DEBUG})
    endif()
else()
	find_library(VFPSDK_LIBRARY libvfpsdk.a libvfpsdk.so 
        PATHS ${VFPSDK_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
        
    if( (NOT VFPSDK_LIBRARY) AND Vlfeat_INCLUDE_DIR)
		set(VFPSDK_LIBRARY ${SMART_LIB_OUTPUT_DIR}/libvfpsdk.a)
	endif()
endif()

find_package_handle_standard_args(VFPSDK 
    FOUND_VAR VFPSDK_FOUND
    REQUIRED_VARS VFPSDK_INCLUDE_DIR VFPSDK_LIBRARY)


if(VFPSDK_FOUND)
    set(VFPSDK_INCLUDE_DIRS ${VFPSDK_INCLUDE_DIR} ${DEPS_INCLUDE_DIRS})
    set(VFPSDK_LIBRARIES ${VFPSDK_LIBRARY} ${DEPS_LIBS})
    if(NOT VFPSDK_FIND_QUIETLY)
        message(STATUS "Found VFPSDK  (include: ${VFPSDK_INCLUDE_DIRS}, library: ${VFPSDK_LIBRARIES})")
    endif(NOT VFPSDK_FIND_QUIETLY)
    mark_as_advanced(VFPSDK_LIBRARY_DEBUG VFPSDK_LIBRARY_RELEASE
                     VFPSDK_LIBRARY VFPSDK_INCLUDE_DIR VFPSDK_ROOT_DIR)
endif()

