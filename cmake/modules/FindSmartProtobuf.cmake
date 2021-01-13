# - Try to find protobuf
#
# The following variables are optionally searched for defaults
#  Protobuf_ROOT_DIR:            Base directory where all Protobuf components are found
#
# The following are set after configuration is done:
#  Protobuf_FOUND
#  Protobuf_INCLUDE_DIRS
#  Protobuf_LIBRARIES
#  Protobuf_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(Protobuf)
	if ( ${Protobuf_FOUND} )
		message(STATUS "vcpkg find protobuf")
	endif()
else()

	set(Protobuf_ROOT_DIR "" CACHE PATH "Folder contains Google Protobuf")
	message(STATUS "try to direct find protobuf")

	if(WIN32)
		find_path(Protobuf_INCLUDE_DIR google/protobuf/message.h
			PATHS ${Protobuf_ROOT_DIR}
			PATH_SUFFIXES include)
	else()
		find_path(Protobuf_INCLUDE_DIR google/protobuf/message.h
			PATHS ${Protobuf_ROOT_DIR}
			PATH_SUFFIXES include)
	endif()

	if(MSVC)
		find_library(Protobuf_LIBRARY_RELEASE libprotobuf protobuf
			PATHS ${Protobuf_ROOT_DIR}
			PATH_SUFFIXES lib lib/Relase Release)

		find_library(Protobuf_LIBRARY_DEBUG libprotobufd protobufd protobuf
			PATHS ${Protobuf_ROOT_DIR}
			PATH_SUFFIXES lib lib/Debug Debug)

		set(Protobuf_LIBRARY optimized ${Protobuf_LIBRARY_RELEASE} debug ${Protobuf_LIBRARY_DEBUG})
	else()
		find_library(Protobuf_LIBRARY protobuf
			PATHS ${Protobuf_ROOT_DIR}
			PATH_SUFFIXES lib lib64)
	endif()

	find_package_handle_standard_args(Protobuf 
		FOUND_VAR Protobuf_FOUND
		REQUIRED_VARS Protobuf_INCLUDE_DIR Protobuf_LIBRARY)

	if(Protobuf_FOUND)
	  set(Protobuf_INCLUDE_DIRS ${Protobuf_INCLUDE_DIR})
	  set(Protobuf_LIBRARIES ${Protobuf_LIBRARY})
	  if (NOT Protobuf_FIND_QUIETLY)
		  message(STATUS "Found Protobuf    (include: ${Protobuf_INCLUDE_DIRS}, library: ${Protobuf_LIBRARIES})")
	  endif(NOT Protobuf_FIND_QUIETLY)
	  mark_as_advanced(Protobuf_ROOT_DIR Protobuf_LIBRARY_RELEASE Protobuf_LIBRARY_DEBUG
									 Protobuf_LIBRARY Protobuf_INCLUDE_DIR)
	endif()
endif()
