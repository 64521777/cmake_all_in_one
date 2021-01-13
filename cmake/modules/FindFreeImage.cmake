# - Try to find FreeImage
#
# The following variables are optionally searched for defaults
#  FreeImage_ROOT_DIR:            Base directory where all FreeImage components are found
#
# The following are set after configuration is done:
#  FreeImage_FOUND
#  FreeImage_INCLUDE_DIRS
#  FreeImage_LIBRARIES
#  FreeImage_LIBRARYRARY_DIRS
include(FindPackageHandleStandardArgs)

set(FreeImage_ROOT_DIR "" CACHE PATH "Folder contains FreeImage")

if(WIN32)
    find_path(FreeImage_INCLUDE_DIR FreeImage.h
        PATHS ${FreeImage_ROOT_DIR}
		PATH_SUFFIXES include FreeImage FreeImage/include)
else()
    find_path(FreeImage_INCLUDE_DIR FreeImage.h
        PATHS ${FreeImage_ROOT_DIR}
		PATH_SUFFIXES include FreeImage)
endif()

if(MSVC)
    find_library(FreeImage_LIBRARY_RELEASE
        NAMES FreeImage
        PATHS ${FreeImage_ROOT_DIR}
        PATH_SUFFIXES Release FreeImage)

    find_library(FreeImage_LIBRARY_DEBUG
        NAMES FreeImage FreeImageD
        PATHS ${FreeImage_ROOT_DIR}
        PATH_SUFFIXES Debug FreeImage)

    set(FreeImage_LIBRARY optimized ${FreeImage_LIBRARY_RELEASE} debug ${FreeImage_LIBRARY_DEBUG})
else()
	find_library(FreeImage_LIBRARY libfreeimage.so 
        PATHS ${FreeImage_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
endif()

find_package_handle_standard_args(FreeImage 
	FOUND_VAR FreeImage_FOUND
	REQUIRED_VARS FreeImage_INCLUDE_DIR FreeImage_LIBRARY)

if(FreeImage_FOUND)
    set(FreeImage_INCLUDE_DIRS ${FreeImage_INCLUDE_DIR})
    set(FreeImage_LIBRARIES ${FreeImage_LIBRARY})
    if(NOT FreeImage_FIND_QUIETLY)
        message(STATUS "Found FreeImage (include: ${FreeImage_INCLUDE_DIRS}, library: ${FreeImage_LIBRARIES})")
    endif(NOT FreeImage_FIND_QUIETLY)
    mark_as_advanced(FreeImage_LIBRARY_DEBUG FreeImage_LIBRARY_RELEASE
                     FreeImage_LIBRARY FreeImage_INCLUDE_DIR FreeImage_ROOT_DIR)
endif()

