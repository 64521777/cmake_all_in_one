# - Try to find BGS
#
# The following variables are optionally searched for defaults
#  BGS_ROOT_DIR:            Base directory where all BGS components are found
#
# The following are set after configuration is done:
#  BGS_FOUND
#  BGS_INCLUDE_DIRS
#  BGS_LIBRARIES
#  BGS_LIBRARYRARY_DIRS

# bgs depend on OpenCV, cvblob
# find_package(CvBlob QUIET)

include(FindPackageHandleStandardArgs)

set(BGS_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" CACHE PATH "Folder contains BGS")

find_path(BGS_INCLUDE_DIR package_bgs/algorithms/IBGS.h
	PATHS ${BGS_ROOT_DIR}
	PATH_SUFFIXES include BGS)

if(MSVC)
    find_library(BGS_LIBRARY_RELEASE libbgs bgs
        PATHS ${BGS_ROOT_DIR}
        PATH_SUFFIXES lib lib/Relase Release)
        
    if( (NOT BGS_LIBRARY_RELEASE) AND BGS_INCLUDE_DIR)
		set(BGS_LIBRARY_RELEASE ${SMART_LIB_OUTPUT_DIR}/Release/bgs.lib)
	endif()

    find_library(BGS_LIBRARY_DEBUG libbgsd bgsd bgs
        PATHS ${BGS_ROOT_DIR}
        PATH_SUFFIXES lib lib/Debug Debug)
    
    if( (NOT BGS_LIBRARY_DEBUG) AND BGS_INCLUDE_DIR)
		set(BGS_LIBRARY_DEBUG ${SMART_LIB_OUTPUT_DIR}/Debug/bgs.lib)
	endif()    

    if(BGS_LIBRARY_RELEASE AND BGS_LIBRARY_DEBUG)
        set(BGS_LIBRARY optimized ${BGS_LIBRARY_RELEASE} debug ${BGS_LIBRARY_DEBUG})
    endif()
else()
    find_library(BGS_LIBRARY libbgs.a libbgs.so
        PATHS ${BGS_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
endif()

find_package_handle_standard_args(BGS 
	FOUND_VAR BGS_FOUND
	REQUIRED_VARS BGS_INCLUDE_DIR BGS_LIBRARY OpenCV_FOUND)

if(BGS_FOUND)
    set(BGS_INCLUDE_DIRS ${BGS_INCLUDE_DIR} ${OpenCV_INCLUDE_DIRS})
    set(BGS_LIBRARIES ${BGS_LIBRARY} ${OpenCV_LIBS})
    if(NOT BGS_FIND_QUIETLY)
        message(STATUS "Found BGS  (include: ${BGS_INCLUDE_DIRS}, library: ${BGS_LIBRARIES})")
    endif(NOT BGS_FIND_QUIETLY)
    mark_as_advanced(BGS_LIBRARY_DEBUG BGS_LIBRARY_RELEASE
                     BGS_LIBRARY BGS_INCLUDE_DIR BGS_ROOT_DIR)
endif()

