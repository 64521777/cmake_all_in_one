# - Try to find infoware
#
# The following variables are optionally searched for defaults
#  INFOWARE_ROOT_DIR:            Base directory where all LMDB components are found
#
# The following are set after configuration is done:
#  Infoware_FOUND
#  Infoware_INCLUDE_DIRS
#  Infoware_LIBRARIES
#  Infoware_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(infoware)
	if (infoware_FOUND)
		set(Infoware_FOUND 1)
		set(Infoware_LIBRARY infoware)
		message(STATUS "vcpkg find infoware")
	endif()
endif()

if(Infoware_FOUND)
  set(Infoware_INCLUDE_DIRS ${Infoware_INCLUDE_DIR})
  set(Infoware_LIBRARIES ${Infoware_LIBRARY})
endif()
