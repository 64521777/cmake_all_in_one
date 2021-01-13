# - Try to find Vlfeat
#
# The following variables are optionally searched for defaults
#  BGS_ROOT_DIR:            Base directory where all Vlfeat components are found
#
# The following are set after configuration is done:
#  Vlfeat_FOUND
#  Vlfeat_INCLUDE_DIRS
#  Vlfeat_LIBRARIES
#  Vlfeat_LIBRARYRARY_DIRS
include(FindPackageHandleStandardArgs)

set(Vlfeat_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" CACHE PATH "Folder contains Vlfeat")

# 优先查找编译代码目录
find_path(Vlfeat_INCLUDE_DIR vlfeat/sift.h
	PATHS ${Vlfeat_ROOT_DIR}
	PATH_SUFFIXES include)

# 优先查找编译输出目录
if(MSVC)
    find_library(Vlfeat_LIBRARY_RELEASE
        NAMES libvlfeat vlfeat
        PATHS ${Vlfeat_ROOT_DIR}
        PATH_SUFFIXES Release)
		
	if( (NOT Vlfeat_LIBRARY_RELEASE) AND Vlfeat_INCLUDE_DIR)
		set(Vlfeat_LIBRARY_RELEASE ${SMART_LIB_OUTPUT_DIR}/Release/vlfeat.lib)
	endif()

    find_library(Vlfeat_LIBRARY_DEBUG
        NAMES libvlfeatd vlfeatd vlfeat
        PATHS ${Vlfeat_ROOT_DIR}
        PATH_SUFFIXES Debug)
	
	if( (NOT Vlfeat_LIBRARY_DEBUG) AND Vlfeat_INCLUDE_DIR)
		set(Vlfeat_LIBRARY_DEBUG ${SMART_LIB_OUTPUT_DIR}/Debug/vlfeat.lib)
	endif()

    if(Vlfeat_LIBRARY_RELEASE AND Vlfeat_LIBRARY_DEBUG)
        set(Vlfeat_LIBRARY optimized ${Vlfeat_LIBRARY_RELEASE} debug ${Vlfeat_LIBRARY_DEBUG})
    endif()
else()
	find_library(Vlfeat_LIBRARY libvlfeat.a libvlfeat.so
        PATHS ${Vlfeat_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
		
	if( (NOT Vlfeat_LIBRARY) AND Vlfeat_INCLUDE_DIR)
		set(Vlfeat_LIBRARY ${SMART_LIB_OUTPUT_DIR}/libvlfeat.a)
	endif()
endif()

find_package_handle_standard_args(Vlfeat 
	FOUND_VAR Vlfeat_FOUND
	REQUIRED_VARS Vlfeat_INCLUDE_DIR Vlfeat_LIBRARY)

if(Vlfeat_FOUND)
    set(Vlfeat_INCLUDE_DIRS ${Vlfeat_INCLUDE_DIR})
    set(Vlfeat_LIBRARIES ${Vlfeat_LIBRARY})
    if(NOT Vlfeat_FIND_QUIETLY)
        message(STATUS "Found Vlfeat  (include: ${Vlfeat_INCLUDE_DIRS}, library: ${Vlfeat_LIBRARIES})")
    endif(NOT Vlfeat_FIND_QUIETLY)
    mark_as_advanced(Vlfeat_LIBRARY_DEBUG Vlfeat_LIBRARY_RELEASE
                     Vlfeat_LIBRARY Vlfeat_INCLUDE_DIR Vlfeat_ROOT_DIR)
endif()

