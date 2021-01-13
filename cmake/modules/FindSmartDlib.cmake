# - Try to find dlib
#
# The following variables are optionally searched for defaults
#  Dlib_ROOT_DIR:            Base directory where all dlib components are found
#
# The following are set after configuration is done:
#  Dlib_FOUND
#  DLib_INCLUDE_DIRS
#  DLib_LIBRARIES
#  DLib_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(dlib)
	if ( ${dlib_FOUND} )
		set(Dlib_FOUND 1)
		set(Dlib_LIBRARY dlib::dlib)
		message(STATUS "vcpkg find dlib")
	endif()
endif()

if(DLib_FOUND)
  set(Dlib_INCLUDE_DIRS ${Dlib_INCLUDE_DIR})
  set(Dlib_LIBRARIES ${Dlib_LIBRARY})
endif()
