# - Try to find LevelDB
#
# The following variables are optionally searched for defaults
#  LevelDB_ROOT_DIR:            Base directory where all LevelDB components are found
#
# The following are set after configuration is done:
#  LevelDB_FOUND
#  LevelDB_INCLUDE_DIRS
#  LevelDB_LIBRARIES
#  LevelDB_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(leveldb)
	if ( ${leveldb_FOUND} )
		set(LevelDB_FOUND 1)
		set(LevelDB_LIBRARY leveldb::leveldb)
		message(STATUS "vcpkg find leveldb")
	endif()
endif()

if(NOT LevelDB_FOUND)

	set(LevelDB_ROOT_DIR "" CACHE PATH "Folder contains LevelDB")

	# We are testing only a couple of files in the include directories
	if(WIN32)
		find_path(LevelDB_INCLUDE_DIR leveldb/db.h
			PATHS ${LevelDB_ROOT_DIR}
			PATH_SUFFIXES include)
	else()
		find_path(LevelDB_INCLUDE_DIR leveldb/db.h
			PATHS ${LevelDB_ROOT_DIR}
			PATH_SUFFIXES include)
	endif()

	if(MSVC)
		find_library(LevelDB_LIBRARY_RELEASE
			NAMES libleveldb leveldb
			PATHS ${LevelDB_ROOT_DIR}
			PATH_SUFFIXES lib lib/Release Release)

		find_library(LevelDB_LIBRARY_DEBUG
			NAMES libleveldbd leveldbd leveldb
			PATHS ${LevelDB_ROOT_DIR}
			PATH_SUFFIXES lib lib/Debug Debug)

		set(LevelDB_LIBRARY optimized ${LevelDB_LIBRARY_RELEASE} debug ${LevelDB_LIBRARY_DEBUG})
	else()
		find_library(LevelDB_LIBRARY 
			NAMES leveldb
			PATHS ${LevelDB_ROOT_DIR}
			PATH_SUFFIXES lib lib64)
	endif()

	find_package_handle_standard_args(LevelDB 
		FOUND_VAR LevelDB_FOUND
		REQUIRED_VARS LevelDB_INCLUDE_DIR LevelDB_LIBRARY)
endif()

if(LevelDB_FOUND)
    set(LevelDB_INCLUDE_DIRS ${LevelDB_INCLUDE_DIR})
    set(LevelDB_LIBRARIES ${LevelDB_LIBRARY})
    if(NOT LevelDB_FIND_QUIETLY)
        message(STATUS "Found LevelDB  (include: ${LevelDB_INCLUDE_DIRS}, library: ${LevelDB_LIBRARIES})")
    endif(NOT LevelDB_FIND_QUIETLY)
    mark_as_advanced(LevelDB_LIBRARY_DEBUG LevelDB_LIBRARY_RELEASE
                     LevelDB_LIBRARY LevelDB_INCLUDE_DIR LevelDB_ROOT_DIR)
endif()
