# - Try to find Glog
#
# The following variables are optionally searched for defaults
#  Glog_ROOT_DIR:            Base directory where all Glog components are found
#
# The following are set after configuration is done:
#  Glog_FOUND
#  Glog_INCLUDE_DIRS
#  Glog_LIBRARIES
#  Glog_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(glog)
	if (glog_FOUND)
		set(Glog_FOUND 1)
		set(Glog_LIBRARY glog::glog)
		message(STATUS "vcpkg find glog")
	endif()
endif()

if(NOT Glog_FOUND)
	set(Glog_ROOT_DIR "" CACHE PATH "Folder contains Google Glog")
	
	message(STATUS "try to direct find glog")

	if(WIN32)
		find_path(Glog_INCLUDE_DIR glog/logging.h
			PATHS ${Glog_ROOT_DIR}
			PATH_SUFFIXES include src/windows)
	else()
		find_path(Glog_INCLUDE_DIR glog/logging.h
			PATHS ${Glog_ROOT_DIR}
			PATH_SUFFIXES include)
	endif()

	if(MSVC)
		find_library(Glog_LIBRARY_RELEASE libglog glog
			PATHS ${Glog_ROOT_DIR}
			PATH_SUFFIXES lib lib/Relase Release)

		find_library(Glog_LIBRARY_DEBUG libglogd glogd glog
			PATHS ${Glog_ROOT_DIR}
			PATH_SUFFIXES lib lib/Debug Debug)

		set(Glog_LIBRARY optimized ${Glog_LIBRARY_RELEASE} debug ${Glog_LIBRARY_DEBUG})
	else()
		find_library(Glog_LIBRARY glog
			PATHS ${Glog_ROOT_DIR}
			PATH_SUFFIXES lib lib64)
	endif()

	find_package_handle_standard_args(Glog 
		FOUND_VAR Glog_FOUND
		REQUIRED_VARS Glog_INCLUDE_DIR Glog_LIBRARY)
endif()
		
if(Glog_FOUND)
  set(Glog_INCLUDE_DIRS ${Glog_INCLUDE_DIR})
  set(Glog_LIBRARIES ${Glog_LIBRARY})
  if (NOT Glog_FIND_QUIETLY)
      message(STATUS "Found Glog    (include: ${Glog_INCLUDE_DIRS}, library: ${Glog_LIBRARIES})")
  endif(NOT Glog_FIND_QUIETLY)
  mark_as_advanced(Glog_ROOT_DIR Glog_LIBRARY_RELEASE Glog_LIBRARY_DEBUG
                                 Glog_LIBRARY Glog_INCLUDE_DIR)
endif()
