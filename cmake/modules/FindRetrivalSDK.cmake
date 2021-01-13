# - Try to find RetrivalSDK
#
# The following variables are optionally searched for defaults
#  RetrivalSDK_ROOT_DIR:            Base directory where all RetrivalSDK components are found
#
# The following are set after configuration is done:
#  RetrivalSDK_FOUND
#  RetrivalSDK_INCLUDE_DIRS
#  RetrivalSDK_LIBRARIES
#  RetrivalSDK_LIBRARY_DIRS

include(FindPackageHandleStandardArgs)
include(ConfigDepLibPath)

set(RetrivalSDK_ROOT_DIR "" CACHE PATH "Folder contains RetrivalSDK")

# RetrivalSDK depend on vlfeat, CommonSDK, VideoAnalysisSDK
find_package(CommonSDK QUIET)
find_package(VFPSDK QUIET)

set(DEP_LIBRARY VFPSDK CommonSDK)
ConfigDepLibPath(DEPS DEP_LIBRARY)

find_path(RetrivalSDK_INCLUDE_DIR RetrivalSDK/RetrivalSDK.h
    PATHS ${RetrivalSDK_ROOT_DIR}
    PATH_SUFFIXES include source)


if(MSVC)
    find_library(RetrivalSDK_LIBRARY_RELEASE
        NAMES RetrivalSDK
        PATHS ${RetrivalSDK_ROOT_DIR}
        PATH_SUFFIXES Release)
    
    if( (NOT RetrivalSDK_LIBRARY_RELEASE) AND RetrivalSDK_INCLUDE_DIR)
		set(RetrivalSDK_LIBRARY_RELEASE ${SMART_LIB_OUTPUT_DIR}/Release/RetrivalSDK.lib)
	endif()

    find_library(RetrivalSDK_LIBRARY_DEBUG
        NAMES RetrivalSDK
        PATHS ${RetrivalSDK_ROOT_DIR}
        PATH_SUFFIXES Debug)
        
    if( (NOT RetrivalSDK_LIBRARY_DEBUG) AND RetrivalSDK_INCLUDE_DIR)
		set(RetrivalSDK_LIBRARY_DEBUG ${SMART_LIB_OUTPUT_DIR}/Debug/RetrivalSDK.lib)
	endif()
        
        
    if(RetrivalSDK_LIBRARY_RELEASE AND RetrivalSDK_LIBRARY_DEBUG)
        set(RetrivalSDK_LIBRARY optimized ${RetrivalSDK_LIBRARY_RELEASE} debug ${RetrivalSDK_LIBRARY_DEBUG})
    endif()
else()
	find_library(RetrivalSDK_LIBRARY libRetrivalSDK.a libRetrivalSDK.so 
        PATHS ${RetrivalSDK_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
        
    if( (NOT RetrivalSDK_LIBRARY) AND Vlfeat_INCLUDE_DIR)
		set(RetrivalSDK_LIBRARY ${SMART_LIB_OUTPUT_DIR}/libRetrivalSDK.a)
	endif()
endif()

find_package_handle_standard_args(RetrivalSDK 
    FOUND_VAR RetrivalSDK_FOUND
    REQUIRED_VARS RetrivalSDK_INCLUDE_DIR RetrivalSDK_LIBRARY)


if(RetrivalSDK_FOUND)
    set(RetrivalSDK_INCLUDE_DIRS ${RetrivalSDK_INCLUDE_DIR} ${DEPS_INCLUDE_DIRS})
    set(RetrivalSDK_LIBRARIES ${RetrivalSDK_LIBRARY} ${DEPS_LIBS})
    if(NOT RetrivalSDK_FIND_QUIETLY)
        message(STATUS "Found RetrivalSDK  (include: ${RetrivalSDK_INCLUDE_DIRS}, library: ${RetrivalSDK_LIBRARIES})")
    endif(NOT RetrivalSDK_FIND_QUIETLY)
    mark_as_advanced(RetrivalSDK_LIBRARY_DEBUG RetrivalSDK_LIBRARY_RELEASE
                     RetrivalSDK_LIBRARY RetrivalSDK_INCLUDE_DIR RetrivalSDK_ROOT_DIR)
endif()

