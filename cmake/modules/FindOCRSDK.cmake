# - Try to find OCRSDK
#
# The following variables are optionally searched for defaults
#  OCRSDK_ROOT_DIR:            Base directory where all OCRSDK components are found
#
# The following are set after configuration is done:
#  OCRSDK_FOUND
#  OCRSDK_INCLUDE_DIRS
#  OCRSDK_LIBRARIES
#  OCRSDK_LIBRARYRARY_DIRS

# OCRSDK depend on CommonSDK, Tesseract(OCR), CCV(TextDetection), OpenCV


include(FindPackageHandleStandardArgs)
include(ConfigDepLibPath)

set(OCRSDK_ROOT_DIR "" CACHE PATH "Folder contains OCRSDK")

find_package(CommonSDK QUIET)

set(DEP_LIBRARY CommonSDK Tesseract CCV OpenCV)
ConfigDepLibPath(DEPS DEP_LIBRARY)


find_path(OCRSDK_INCLUDE_DIR OCRSDK/SmartVisionOCRSDK.h
    PATHS ${OCRSDK_ROOT_DIR}
    PATH_SUFFIXES include)


if(MSVC)
    find_library(OCRSDK_LIBRARY_RELEASE
        NAMES ocrsdk
        PATHS ${OCRSDK_ROOT_DIR}
        PATH_SUFFIXES Release)
    
    if( (NOT OCRSDK_LIBRARY_RELEASE) AND OCRSDK_INCLUDE_DIR)
		set(OCRSDK_LIBRARY_RELEASE ${SMART_LIB_OUTPUT_DIR}/Release/OCRSDK.lib)
	endif()

    find_library(OCRSDK_LIBRARY_DEBUG
        NAMES ocrsdk
        PATHS ${OCRSDK_ROOT_DIR}
        PATH_SUFFIXES Debug)
    
    if( (NOT OCRSDK_LIBRARY_DEBUG) AND OCRSDK_INCLUDE_DIR)
		set(OCRSDK_LIBRARY_DEBUG ${SMART_LIB_OUTPUT_DIR}/Release/OCRSDK.lib)
	endif()
 
    if(OCRSDK_LIBRARY_RELEASE AND OCRSDK_LIBRARY_DEBUG)
        set(OCRSDK_LIBRARY optimized ${OCRSDK_LIBRARY_RELEASE} debug ${OCRSDK_LIBRARY_DEBUG})
    endif()
else()
	find_library(OCRSDK_LIBRARY libocrsdk.a libocrsdk.so 
        PATHS ${OCRSDK_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
    
    if( (NOT OCRSDK_LIBRARY) AND OCRSDK_INCLUDE_DIR)
		set(OCRSDK_LIBRARY ${SMART_LIB_OUTPUT_DIR}/libocrsdk.a)
	endif()  
endif()

find_package_handle_standard_args(OCRSDK 
    FOUND_VAR OCRSDK_FOUND
    REQUIRED_VARS OCRSDK_INCLUDE_DIR OCRSDK_LIBRARY)


if(OCRSDK_FOUND)
    set(OCRSDK_INCLUDE_DIRS ${OCRSDK_INCLUDE_DIR} ${DEPS_INCLUDE_DIRS})
    set(OCRSDK_LIBRARIES ${OCRSDK_LIBRARY} ${DEPS_LIBS})
    if(NOT OCRSDK_FIND_QUIETLY)
        message(STATUS "Found OCRSDK  (include: ${OCRSDK_INCLUDE_DIRS}, library: ${OCRSDK_LIBRARIES})")
    endif(NOT OCRSDK_FIND_QUIETLY)
    mark_as_advanced(OCRSDK_LIBRARY_DEBUG OCRSDK_LIBRARY_RELEASE
                     OCRSDK_LIBRARY OCRSDK_INCLUDE_DIR OCRSDK_ROOT_DIR)
endif()

