# - Try to find CryptoPP
#
# The following variables are optionally searched for defaults
#  CryptoPP_ROOT_DIR:            Base directory where all CryptoPP components are found
#
# The following are set after configuration is done:
#  CryptoPP_FOUND
#  CryptoPP_INCLUDE_DIRS
#  CryptoPP_LIBRARIES
#  CryptoPP_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(cryptopp)
	if ( ${cryptopp_FOUND} )
		set(CryptoPP_FOUND 1)
		set(CryptoPP_LIBRARY cryptopp-static)
		message(STATUS "vcpkg find cryptopp")
	endif()
endif()

if(NOT CryptoPP_FOUND)
	
	message(STATUS "user define find cryptopp")
	set(CryptoPP_ROOT_DIR "" CACHE PATH "Folder contains Google CryptoPP")

	if(WIN32)
		find_path(CryptoPP_INCLUDE_DIR cryptopp/cryptlib.h
			PATHS ${CryptoPP_ROOT_DIR}
			PATH_SUFFIXES include)
	else()
		find_path(CryptoPP_INCLUDE_DIR cryptopp/cryptlib.h
			PATHS ${CryptoPP_ROOT_DIR}
			PATH_SUFFIXES include)
	endif()

	if(MSVC)
		find_library(CryptoPP_LIBRARY_RELEASE cryptlib
			PATHS ${CryptoPP_ROOT_DIR}
			PATH_SUFFIXES lib lib/Relase Release)

		find_library(CryptoPP_LIBRARY_DEBUG cryptlibd
			PATHS ${CryptoPP_ROOT_DIR}
			PATH_SUFFIXES lib lib/Debug Debug)
		
		if(CryptoPP_LIBRARY_RELEASE AND CryptoPP_LIBRARY_DEBUG)
			set(CryptoPP_LIBRARY optimized ${CryptoPP_LIBRARY_RELEASE} debug ${CryptoPP_LIBRARY_DEBUG})
		endif()
	else()
		find_library(CryptoPP_LIBRARY cryptopp
			PATHS ${CryptoPP_ROOT_DIR}
			PATH_SUFFIXES lib lib64)
	endif()

	find_package_handle_standard_args(CryptoPP 
		FOUND_VAR CryptoPP_FOUND
		REQUIRED_VARS CryptoPP_INCLUDE_DIR CryptoPP_LIBRARY)

endif()

if(CryptoPP_FOUND)
  set(CryptoPP_INCLUDE_DIRS ${CryptoPP_INCLUDE_DIR})
  set(CryptoPP_LIBRARIES ${CryptoPP_LIBRARY})
  if (NOT CryptoPP_FIND_QUIETLY)
	  message(STATUS "Found CryptoPP    (include: ${CryptoPP_INCLUDE_DIRS}, library: ${CryptoPP_LIBRARIES})")
  endif(NOT CryptoPP_FIND_QUIETLY)
  mark_as_advanced(CryptoPP_ROOT_DIR CryptoPP_LIBRARY_RELEASE CryptoPP_LIBRARY_DEBUG
								 CryptoPP_LIBRARY CryptoPP_INCLUDE_DIR)
endif()
