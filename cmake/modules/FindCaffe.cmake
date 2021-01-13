# - Try to find CAFFE
#
# The following variables are optionally searched for defaults
#  Caffe_ROOT_DIR:            Base directory where all CAFFE components are found
#
# The following are set after configuration is done:
#  Caffe_FOUND
#  Caffe_INCLUDE_DIRS
#  Caffe_LIBRARIES
#  Caffe_LIBRARYRARY_DIRS
#  CAFFE_HAS_CHECKED

include(FindPackageHandleStandardArgs)

# 防止重复打印消息和重复检查
option (USE_GPU "Use GPU" OFF)
set(CAFFE_HAS_CHECKED ON)
mark_as_advanced(CAFFE_HAS_CHECKED)
    
if(NOT DEFINED ENV{CAFFE_HOME})
    # 没有设置CAFFE_HOME环境变量，表示没有 CAFFE
    message(STATUS "not defined environment variable:CAFFE_HOME")
    # 设置 Caffe_FOUND 变量, 供 EnviromentCheck 使用
    set(Caffe_FOUND FALSE)
else()
    set(Caffe_ROOT_DIR "$ENV{CAFFE_HOME}" CACHE PATH "Folder contains CAFFE")
    #if(USE_GPU)
    #    set(Caffe_ROOT_DIR "$ENV{CAFFE_HOME}/distribute_gpu/" CACHE PATH "Folder contains CAFFE")
    #else(USE_GPU)
    #    set(Caffe_ROOT_DIR "$ENV{CAFFE_HOME}/distribute_cpu/" CACHE PATH "Folder contains CAFFE")
    #endif(USE_GPU)

    find_path(Caffe_INCLUDE_DIR caffe/caffe.hpp
        PATHS $ENV{CAFFE_HOME} ${Caffe_ROOT_DIR}
        PATH_SUFFIXES include )

    if(MSVC)
        find_library(Caffe_LIBRARY_RELEASE
            NAMES caffe
            PATHS $ENV{CAFFE_HOME} ${Caffe_ROOT_DIR}
            PATH_SUFFIXES Release)

        find_library(Caffe_LIBRARY_DEBUG
            NAMES caffe-d caffe
            PATHS $ENV{CAFFE_HOME} ${Caffe_ROOT_DIR}
            PATH_SUFFIXES Debug)

        set(Caffe_LIBRARY optimized ${Caffe_LIBRARY_RELEASE} debug ${Caffe_LIBRARY_DEBUG})
        
        find_library(CaffeProto_LIBRARY_RELEASE
            NAMES proto
            PATHS $ENV{CAFFE_HOME} ${Caffe_ROOT_DIR}
            PATH_SUFFIXES Release)

        find_library(CaffeProto_LIBRARY_DEBUG
            NAMES proto-d proto
            PATHS $ENV{CAFFE_HOME} ${Caffe_ROOT_DIR}
            PATH_SUFFIXES Debug)

        set(CaffeProto_LIBRARY optimized ${CaffeProto_LIBRARY_RELEASE} debug ${CaffeProto_LIBRARY_DEBUG})
    else()
        find_library(Caffe_LIBRARY caffe
            PATHS $ENV{CAFFE_HOME} ${Caffe_ROOT_DIR}
            PATH_SUFFIXES lib lib64)
    endif()

    find_package_handle_standard_args(Caffe
        FOUND_VAR Caffe_FOUND
        REQUIRED_VARS Caffe_INCLUDE_DIR Caffe_LIBRARY)

    if(Caffe_FOUND)
        set(Caffe_INCLUDE_DIRS ${Caffe_INCLUDE_DIR})
        if(MSVC)
            set(Caffe_LIBRARIES ${Caffe_LIBRARY} ${CaffeProto_LIBRARY} gflags.lib glog.lib caffehdf5_hl.lib caffehdf5.lib python35.lib libopenblas.dll.lib boost_python-vc140-mt-1_61.lib)
        else()
            set(Caffe_LIBRARIES ${Caffe_LIBRARY})
        endif()
        if(NOT Caffe_FIND_QUIETLY)
            message(STATUS "Found Caffe  (include: ${Caffe_INCLUDE_DIRS}, library: ${Caffe_LIBRARIES})")
        endif(NOT Caffe_FIND_QUIETLY)
        mark_as_advanced(CAFFE_LIBRARY_DEBUG CAFFE_LIBRARY_RELEASE
                         Caffe_LIBRARY Caffe_INCLUDE_DIR Caffe_ROOT_DIR)
    endif()
endif()


