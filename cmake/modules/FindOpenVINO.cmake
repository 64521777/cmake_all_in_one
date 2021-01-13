# - Try to find OpenVINO
#
# The following variables are optionally searched for defaults
#  OpenVINO_ROOT_DIR:            Base directory where all OpenVINO components are found
#
# The following are set after configuration is done:
#  OpenVINO_FOUND
#  OpenVINO_INCLUDE_DIRS
#  OpenVINO_LIBRARIES
#  OpenVINO_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

# Set IE Directory
if(WIN32)
	set(INTEL_OPENVINO_DIR "C:/Program Files (x86)/IntelSWTools/openvino")
else()
    set(INTEL_OPENVINO_DIR "/opt/intel/openvino")
endif()

# 配置库cmake文件的路径
set(InferenceEngine_DIR ${INTEL_OPENVINO_DIR}/deployment_tools/inference_engine/share)


if(DEFINED ENV{NGRAPH_ROOT})
	find_package(dlib)
	set(ngraph_DIR $ENV{VCPKG_ROOT}/cmake)
	set(NGRAPH_INCLUDE_DIRS $ENV{VCPKG_ROOT}/include)
else()
	set(ngraph_DIR ${INTEL_OPENVINO_DIR}/deployment_tools/ngraph/cmake)
	set(NGRAPH_INCLUDE_DIRS ${INTEL_OPENVINO_DIR}/deployment_tools/ngraph/include)
endif()

if (IE_NOT_FOUND_MESSAGE)
    find_package(InferenceEngine QUIET)
	find_package(ngraph QUIET)
else()
    find_package(InferenceEngine REQUIRED)
	find_package(ngraph REQUIRED)
endif()

if (InferenceEngine_FOUND)
	set(OpenVINO_FOUND 1)
	set(OpenVINO_LIBRARIES ${InferenceEngine_LIBRARIES} ${NGRAPH_LIBRARIES})
	set(OpenVINO_INCLUDE_DIRS ${InferenceEngine_INCLUDE_DIRS} ${NGRAPH_INCLUDE_DIRS})
	message(STATUS "openvino found: ${InferenceEngine_INCLUDE_DIRS}")
else()
	message(STATUS "openvino not found")
endif()


