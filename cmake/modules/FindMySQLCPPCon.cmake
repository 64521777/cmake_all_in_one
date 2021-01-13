# - Try to find MySQLCPPCon
#
# The following variables are optionally searched for defaults
#  MySQLCPPCon_ROOT_DIR:            Base directory where all MySQLCPPCon components are found
#
# The following are set after configuration is done:
#  MySQLCPPCon_FOUND
#  MySQLCPPCon_INCLUDE_DIRS
#  MySQLCPPCon_LIBRARIES
#  MySQLCPPCon_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

set(MySQLCPPCon_ROOT_DIR "" CACHE PATH "Folder contains MySQLCPPCon")

if(DEFINED ENV{MySQLCPPCon_ROOT})
    set(MySQLCPPCon_ROOT_DIR $ENV{MySQLCPPCon_ROOT})
endif()

find_path(MySQLCPPCon_INCLUDE_DIR mysql_connection.h
    PATHS ${MySQLCPPCon_ROOT_DIR}
    PATH_SUFFIXES include include/jdbc)

find_library(MySQLCPPCon_LIBRARY mysqlcppconn
    PATHS ${MySQLCPPCon_ROOT_DIR}
    PATH_SUFFIXES lib lib64 lib/opt)

find_package_handle_standard_args(MySQLCPPCon 
	FOUND_VAR MySQLCPPCon_FOUND
	REQUIRED_VARS MySQLCPPCon_INCLUDE_DIR MySQLCPPCon_LIBRARY)

if(MySQLCPPCon_FOUND)
  set(MySQLCPPCon_INCLUDE_DIRS ${MySQLCPPCon_INCLUDE_DIR})
  set(MySQLCPPCon_LIBRARIES ${MySQLCPPCon_LIBRARY})
  if (NOT MySQLCPPCon_FIND_QUIETLY)
      message(STATUS "Found MySQLCPPCon    (include: ${MySQLCPPCon_INCLUDE_DIRS}, library: ${MySQLCPPCon_LIBRARIES})")
  endif(NOT MySQLCPPCon_FIND_QUIETLY)
  mark_as_advanced(MySQLCPPCon_ROOT_DIR MySQLCPPCon_LIBRARY_RELEASE MySQLCPPCon_LIBRARY_DEBUG
                                 MySQLCPPCon_LIBRARY MySQLCPPCon_INCLUDE_DIR)
endif()
