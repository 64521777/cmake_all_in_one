# - Try to find Tesseract
#
# The following variables are optionally searched for defaults
#  Tesseract_ROOT_DIR:            Base directory where all Tesseract components are found
#
# The following are set after configuration is done:
#  Tesseract_FOUND
#  Tesseract_INCLUDE_DIRS
#  Tesseract_LIBRARIES
#  Tesseract_LIBRARYRARY_DIRS
include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(Tesseract)
	if (Tesseract_FOUND)
		set(Tesseract_LIBRARY libtesseract)
		message(STATUS "vcpkg find Tesseract")
	endif()
endif()


if(NOT Tesseract_FOUND)
	set(Tesseract_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" CACHE PATH "Folder contains Tesseract")

	# Tesseract depend on lept
	find_package(Leptonica QUIET)

	find_path(Tesseract_INCLUDE_DIR tesseract/baseapi.h
		PATHS ${Tesseract_ROOT_DIR}
		PATH_SUFFIXES include)

	if(MSVC)
		find_library(Tesseract_LIBRARY_RELEASE
			NAMES tesseract
			PATHS ${Tesseract_ROOT_DIR}
			PATH_SUFFIXES Release)

		find_library(Tesseract_LIBRARY_DEBUG
			NAMES tesseract
			PATHS ${Tesseract_ROOT_DIR}
			PATH_SUFFIXES Debug)

		set(Tesseract_LIBRARY optimized ${Tesseract_LIBRARY_RELEASE} debug ${Tesseract_LIBRARY_DEBUG})
	else()	
		find_library(Tesseract_LIBRARY tesseract
			PATHS ${Tesseract_ROOT_DIR}
			PATH_SUFFIXES lib lib64)
	endif()

	find_package_handle_standard_args(Tesseract 
		FOUND_VAR Tesseract_FOUND
		REQUIRED_VARS Tesseract_INCLUDE_DIR Tesseract_LIBRARY Leptonica_FOUND)

endif()
		
if(Tesseract_FOUND)
    set(Tesseract_INCLUDE_DIRS ${Tesseract_INCLUDE_DIR} ${Leptonica_INCLUDE_DIRS})
    set(Tesseract_LIBRARIES ${Tesseract_LIBRARY} ${Leptonica_LIBRARIES})

    if(NOT Tesseract_FIND_QUIETLY)
    message(STATUS "Found Tesseract  (include: ${Tesseract_INCLUDE_DIRS}, library: ${Tesseract_LIBRARIES})")
    endif(NOT Tesseract_FIND_QUIETLY)
    mark_as_advanced(Tesseract_LIBRARY_DEBUG Tesseract_LIBRARY_RELEASE
                     Tesseract_LIBRARY Tesseract_INCLUDE_DIR Tesseract_ROOT_DIR)
endif()

