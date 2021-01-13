# - Try to find ArcsoftSDK
#
# The following variables are optionally searched for defaults
#  ArcsoftSDK_ROOT_DIR:            Base directory where all ArcsoftSDK components are found
#
# The following are set after configuration is done:
#  ArcsoftSDK_FOUND
#  ArcsoftSDK_INCLUDE_DIRS
#  ArcsoftSDK_LIBRARIES
#  ArcsoftSDK_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

#set(ArcsoftSDK_ROOT_DIR "/usr/local/include" CACHE PATH "Folder contains /usr/local")

message("ArcsoftSDK_ROOT_DIR: ${ArcsoftSDK_ROOT_DIR}")

if(WIN32)
    find_path(ArcsoftSDK_INCLUDE_DIR arcsoft_fsdk_face_detection.h
        PATHS ${ArcsoftSDK_ROOT_DIR}
		PATH_SUFFIXES Arcsoft)
else()
    find_path(ArcsoftSDK_INCLUDE_DIR arcsoft_fsdk_face_detection.h
        PATHS ${ArcsoftSDK_ROOT_DIR}
		PATH_SUFFIXES Arcsoft)
endif()

if(MSVC)
    find_library(ArcsoftSDK_LIBRARY_RELEASE libarcsoft_fsdk_face_detection.so libarcsoft_fsdk_face_recognition.so
        PATHS ${ArcsoftSDK_ROOT_DIR}
        PATH_SUFFIXES lib lib/Relase Release)

    find_library(ArcsoftSDK_LIBRARY_DEBUG libarcsoft_fsdk_face_detection.so libarcsoft_fsdk_face_recognition.so
        PATHS ${ArcsoftSDK_ROOT_DIR}
        PATH_SUFFIXES lib lib/Debug Debug)
	
	if(ArcsoftSDK_LIBRARY_RELEASE AND ArcsoftSDK_LIBRARY_DEBUG)
		set(ArcsoftSDK_LIBRARY optimized ${ArcsoftSDK_LIBRARY_RELEASE} debug ${ArcsoftSDK_LIBRARY_DEBUG})
	endif()
else()
    find_library(ArcsoftSDK_LIBRARY libarcsoft_fsdk_face_detection.so
        PATHS ${ArcsoftSDK_ROOT_DIR}
        PATH_SUFFIXES lib lib64)
endif()

find_package_handle_standard_args(ArcsoftSDK 
	FOUND_VAR ArcsoftSDK_FOUND
	REQUIRED_VARS ArcsoftSDK_INCLUDE_DIR ArcsoftSDK_LIBRARY)

# list(APPEND DEPS_LIBS /usr/local/lib/libarcsoft_fsdk_face_detection.so /usr/local/lib/libarcsoft_fsdk_face_recognition.so /usr/local/lib/libarcsoft_fsdk_gender_estimation.so
#     /usr/local/lib/libarcsoft_fsdk_age_estimation.so /usr/local/lib/libarcsoft_face.so /usr/local/lib/libarcsoft_face_engine.so)

# libarcsoft_fsdk_face_detection.so 
# libarcsoft_fsdk_face_recognition.so 
# libarcsoft_fsdk_gender_estimation.so
# libarcsoft_fsdk_age_estimation.so

if(ArcsoftSDK_FOUND)
  set(ArcsoftSDK_INCLUDE_DIRS ${ArcsoftSDK_INCLUDE_DIR})
  set(ArcsoftSDK_LIBRARIES ${ArcsoftSDK_LIBRARY} /usr/local/lib/libarcsoft_fsdk_face_recognition.so)
  if (NOT ArcsoftSDK_FIND_QUIETLY)
      message(STATUS "Found ArcsoftSDK    (include: ${ArcsoftSDK_INCLUDE_DIRS}, library: ${ArcsoftSDK_LIBRARIES})")
  endif(NOT ArcsoftSDK_FIND_QUIETLY)
  mark_as_advanced(ArcsoftSDK_ROOT_DIR ArcsoftSDK_LIBRARY_RELEASE ArcsoftSDK_LIBRARY_DEBUG
                                 ArcsoftSDK_LIBRARY ArcsoftSDK_INCLUDE_DIR)
endif()
