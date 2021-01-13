# - Try to find GMock
#
# The following variables are optionally searched for defaults
#  GMock_ROOT_DIR:            Base directory where all GMock components are found
#
# The following are set after configuration is done:
#  GMock_FOUND
#  GMock_INCLUDE_DIRS
#  GMock_LIBRARIES
#  GMock_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(gtest)
	if ( ${gtest_FOUND} )
		set(GMock_FOUND 1)
		set(GMock_LIBRARY GTest::gmock GTest::gmock_main)
		message(STATUS "vcpkg find gmock")
	endif()
endif()


if(NOT GTest_FOUND)

	set(GMock_ROOT_DIR "" CACHE PATH "Folder contains Google GMock")

	find_path(GMock_INCLUDE_DIR gmock/gmock.h
		PATHS ${GMock_ROOT_DIR}
		PATH_SUFFIXES include)

	find_library(GMock_LIBRARY gmock
		PATHS ${GMock_ROOT_DIR}
		PATH_SUFFIXES lib lib64)

	find_package_handle_standard_args(GMock 
		FOUND_VAR GMock_FOUND
		REQUIRED_VARS GMock_INCLUDE_DIR GMock_LIBRARY)
endif()

if(GMock_FOUND)
  set(GMock_INCLUDE_DIRS ${GMock_INCLUDE_DIR})
  set(GMock_LIBRARIES ${GMock_LIBRARY})
  if (NOT GMock_FIND_QUIETLY)
      message(STATUS "Found GMock    (include: ${GMock_INCLUDE_DIRS}, library: ${GMock_LIBRARIES})")
  endif(NOT GMock_FIND_QUIETLY)
  mark_as_advanced(GMock_ROOT_DIR GMock_LIBRARY_RELEASE GMock_LIBRARY_DEBUG
                                 GMock_LIBRARY GMock_INCLUDE_DIR)
endif()
