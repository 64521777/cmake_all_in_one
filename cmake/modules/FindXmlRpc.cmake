# - Try to find XmlRpc
#
# The following variables are optionally searched for defaults
#  XmlRpc_ROOT_DIR:            Base directory where all XmlRpc components are found
#
# The following are set after configuration is done:
#  XmlRpc_FOUND
#  XmlRpc_INCLUDE_DIRS
#  XmlRpc_LIBRARIES
#  XmlRpc_LIBRARYRARY_DIRS
include(FindPackageHandleStandardArgs)

set(XmlRpc_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}" CACHE PATH "Folder contains XmlRpc")

find_path(XmlRpc_INCLUDE_DIR xmlrpc/XmlRpc.h
	PATHS ${XmlRpc_ROOT_DIR}
	PATH_SUFFIXES include)

if(MSVC)
    find_library(XmlRpc_LIBRARY_RELEASE
        NAMES libxmlrpc xmlrpc
        PATHS ${XmlRpc_ROOT_DIR}
        PATH_SUFFIXES Release)
		
	if( (NOT XmlRpc_LIBRARY_RELEASE) AND XmlRpc_INCLUDE_DIR)
		set(XmlRpc_LIBRARY_RELEASE ${SMART_LIB_OUTPUT_DIR}/Release/xmlrpc.lib)
	endif()

    find_library(XmlRpc_LIBRARY_DEBUG
        NAMES libxmlrpcd xmlrpcd libxmlrpc xmlrpc
        PATHS ${XmlRpc_ROOT_DIR}
        PATH_SUFFIXES Debug)
	
	if( (NOT XmlRpc_LIBRARY_DEBUG) AND XmlRpc_INCLUDE_DIR)
		set(XmlRpc_LIBRARY_DEBUG ${SMART_LIB_OUTPUT_DIR}/Debug/xmlrpc.lib)
	endif()

	if( XmlRpc_LIBRARY_RELEASE AND XmlRpc_LIBRARY_DEBUG )
		set(XmlRpc_LIBRARY optimized ${XmlRpc_LIBRARY_RELEASE} debug ${XmlRpc_LIBRARY_DEBUG})
	endif()
else()
	find_library(XmlRpc_LIBRARY libxmlrpc.a libxmlrpc.so
        PATHS ${XmlRpc_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
		
	#if( (NOT XmlRpc_LIBRARY) AND XmlRpc_INCLUDE_DIR)
	#	set(XmlRpc_LIBRARY ${SMART_LIB_OUTPUT_DIR}/libxmlrpc.a)
	#endif()
endif()

find_package_handle_standard_args(XmlRpc 
	FOUND_VAR XmlRpc_FOUND
	REQUIRED_VARS XmlRpc_INCLUDE_DIR XmlRpc_LIBRARY)

if(XmlRpc_FOUND)
    set(XmlRpc_INCLUDE_DIRS ${XmlRpc_INCLUDE_DIR})
    # XmlRpc depend on WS2_32 under windows
    if(MSVC)
        set(XmlRpc_LIBRARIES ${XmlRpc_LIBRARY}  WS2_32)
    else(MSVC)
        set(XmlRpc_LIBRARIES ${XmlRpc_LIBRARY})
    endif(MSVC)
    if(NOT XmlRpc_FIND_QUIETLY)
        message(STATUS "Found XmlRpc  (include: ${XmlRpc_INCLUDE_DIRS}, library: ${XmlRpc_LIBRARIES})")
    endif(NOT XmlRpc_FIND_QUIETLY)
    mark_as_advanced(XmlRpc_LIBRARY_DEBUG XmlRpc_LIBRARY_RELEASE
                     XmlRpc_LIBRARY XmlRpc_INCLUDE_DIR XmlRpc_ROOT_DIR)
endif()

