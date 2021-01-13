# - Try to find LMDB
#
# The following variables are optionally searched for defaults
#  LMDB_ROOT_DIR:            Base directory where all LMDB components are found
#
# The following are set after configuration is done:
#  LMDB_FOUND
#  LMDB_INCLUDE_DIRS
#  LMDB_LIBRARIES
#  LMDB_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(lmdb)
	if (lmdb_FOUND)
		set(LMDB_FOUND 1)
		set(LMDB_LIBRARY lmdb)
		message(STATUS "vcpkg find lmdb")
	endif()
endif()

if(NOT LMDB_FOUND)
	set(LMDB_ROOT_DIR "" CACHE PATH "Folder contains LMDB")
	
	message(STATUS "try to direct find lmdb")

	# We are testing only a couple of files in the include directories
	if(WIN32)
		find_path(LMDB_INCLUDE_DIR lmdb/lmdb.h lmdb.h
			PATHS ${LMDB_ROOT_DIR}
			PATH_SUFFIXES include)
	else()
		find_path(LMDB_INCLUDE_DIR lmdb/lmdb.h lmdb.h
			PATHS ${LMDB_ROOT_DIR}
			PATH_SUFFIXES include)
	endif()

	if(MSVC)
		find_library(LMDB_LIBRARY_RELEASE
			NAMES liblmdb lmdb
			PATHS ${LMDB_ROOT_DIR}
			PATH_SUFFIXES lib lib/Release Release)

		find_library(LMDB_LIBRARY_DEBUG
			NAMES liblmdbd lmdbd lmdb
			PATHS ${LMDB_ROOT_DIR}
			PATH_SUFFIXES lib lib/Debug Debug)

		set(LMDB_LIBRARY optimized ${LMDB_LIBRARY_RELEASE} debug ${LMDB_LIBRARY_DEBUG})
	else()
		find_library(LMDB_LIBRARY 
			NAMES lmdb
			PATHS ${LMDB_ROOT_DIR}
			PATH_SUFFIXES lib lib64)
	endif()

	find_package_handle_standard_args(LMDB 
		FOUND_VAR LMDB_FOUND
		REQUIRED_VARS LMDB_INCLUDE_DIR LMDB_LIBRARY)
endif()

if(LMDB_FOUND)
	# lmdb 无法解析的外部符号 NtCreateSection，该符号在函数 mdb_env_map 中被引用
	# lmdb depend on ntdll under windows
    set(LMDB_INCLUDE_DIRS ${LMDB_INCLUDE_DIR})
	if(WIN32)
        set(LMDB_LIBRARIES ${LMDB_LIBRARY} ntdll)
    else(WIN32)
        set(LMDB_LIBRARIES ${LMDB_LIBRARY})
    endif(WIN32)
    
    if(NOT LMDB_FIND_QUIETLY)
        message(STATUS "Found LMDB  (include: ${LMDB_INCLUDE_DIRS}, library: ${LMDB_LIBRARIES})")
    endif(NOT LMDB_FIND_QUIETLY)
    mark_as_advanced(LMDB_LIBRARY_DEBUG LMDB_LIBRARY_RELEASE
                     LMDB_LIBRARY LMDB_INCLUDE_DIR LMDB_ROOT_DIR)
endif()
