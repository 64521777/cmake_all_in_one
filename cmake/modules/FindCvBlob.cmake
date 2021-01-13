# - Try to find CvBlob
#
# The following variables are optionally searched for defaults
#  CvBlob_ROOT_DIR:            Base directory where all CvBlob components are found
#
# The following are set after configuration is done:
#  CvBlob_FOUND
#  CvBlob_INCLUDE_DIRS
#  CvBlob_LIBRARIES
#  CvBlob_LIBRARYRARY_DIRS

# cvblob depend on opencv
include(FindPackageHandleStandardArgs)

set(CvBlob_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" CACHE PATH "Folder contains CvBlob")

if(WIN32)
    find_path(CvBlob_INCLUDE_DIR cvblob/Blob.h
        PATHS ${CvBlob_ROOT_DIR}
		PATH_SUFFIXES include)
else()
    find_path(CvBlob_INCLUDE_DIR cvblob/Blob.h
        PATHS ${CvBlob_ROOT_DIR}
		PATH_SUFFIXES include)
endif()

if(MSVC)
    find_library(CvBlob_LIBRARY_RELEASE
        NAMES libcvblob cvblob
        PATHS ${CvBlob_ROOT_DIR}
        PATH_SUFFIXES Release)
        
    if( (NOT CvBlob_LIBRARY_RELEASE) AND CvBlob_INCLUDE_DIR)
		set(CvBlob_LIBRARY_RELEASE ${SMART_LIB_OUTPUT_DIR}/Release/cvblob.lib)
	endif()

    find_library(CvBlob_LIBRARY_DEBUG
        NAMES libcvblobd cvblobd cvblob
        PATHS ${CvBlob_ROOT_DIR}
        PATH_SUFFIXES Debug)
        
    if( (NOT CvBlob_LIBRARY_DEBUG) AND CvBlob_INCLUDE_DIR)
		set(CvBlob_LIBRARY_DEBUG ${SMART_LIB_OUTPUT_DIR}/Debug/cvblob.lib)
	endif()
    
    
	if( CvBlob_LIBRARY_RELEASE AND CvBlob_LIBRARY_DEBUG )
		set(CvBlob_LIBRARY optimized ${CvBlob_LIBRARY_RELEASE} debug ${CvBlob_LIBRARY_DEBUG})
	endif()
else()
	find_library(CvBlob_LIBRARY cvblob
        PATHS ${CvBlob_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
endif()

find_package_handle_standard_args(CvBlob 
	FOUND_VAR CvBlob_FOUND
	REQUIRED_VARS CvBlob_INCLUDE_DIR CvBlob_LIBRARY OpenCV_FOUND)

if(CvBlob_FOUND)
    set(CvBlob_INCLUDE_DIRS ${CvBlob_INCLUDE_DIR} ${OpenCV_INCLUDE_DIRS})
    set(CvBlob_LIBRARIES ${CvBlob_LIBRARY} ${OpenCV_LIBS})
    if(NOT CvBlob_FIND_QUIETLY)
        message(STATUS "Found CvBlob  (include: ${CvBlob_INCLUDE_DIRS}, library: ${CvBlob_LIBRARIES})")
    endif(NOT CvBlob_FIND_QUIETLY)
    mark_as_advanced(CvBlob_LIBRARY_DEBUG CvBlob_LIBRARY_RELEASE
                     CvBlob_LIBRARY CvBlob_INCLUDE_DIR CvBlob_ROOT_DIR)
endif()

