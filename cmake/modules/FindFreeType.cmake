# - Try to find FreeType
#
# The following variables are optionally searched for defaults
#  FreeType_ROOT_DIR:            Base directory where all FreeType components are found
#
# The following are set after configuration is done:
#  FreeType_FOUND
#  FreeType_INCLUDE_DIRS
#  FreeType_LIBRARIES
#  FreeType_LIBRARYRARY_DIRS
include(FindPackageHandleStandardArgs)

set(FreeType_ROOT_DIR "" CACHE PATH "Folder contains FreeType")


find_path(FreeType_INCLUDE_DIR freetype.h
    PATHS ${FreeType_ROOT_DIR}
    PATH_SUFFIXES include freetype2 freetype)

if(MSVC)
    find_library(FreeType_LIBRARY_RELEASE
        NAMES freetype
        PATHS ${FreeType_ROOT_DIR}
        PATH_SUFFIXES Release FreeType)

    find_library(FreeType_LIBRARY_DEBUG
        NAMES freetyped freetype
        PATHS ${FreeType_ROOT_DIR}
        PATH_SUFFIXES Debug FreeType)

    set(FreeType_LIBRARY optimized ${FreeType_LIBRARY_RELEASE} debug ${FreeType_LIBRARY_DEBUG})
else()
	find_library(FreeType_LIBRARY libfreetype.so 
        PATHS ${FreeType_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
endif()

find_package_handle_standard_args(FreeType 
	FOUND_VAR FreeType_FOUND
	REQUIRED_VARS FreeType_INCLUDE_DIR FreeType_LIBRARY)

if(FreeType_FOUND)
    set(FreeType_INCLUDE_DIRS ${FreeType_INCLUDE_DIR})
    set(FreeType_LIBRARIES ${FreeType_LIBRARY})
    if(NOT FreeType_FIND_QUIETLY)
        message(STATUS "Found FreeType (include: ${FreeType_INCLUDE_DIRS}, library: ${FreeType_LIBRARIES})")
    endif(NOT FreeType_FIND_QUIETLY)
    mark_as_advanced(FreeType_LIBRARY_DEBUG FreeType_LIBRARY_RELEASE
                     FreeType_LIBRARY FreeType_INCLUDE_DIR FreeType_ROOT_DIR)
endif()

