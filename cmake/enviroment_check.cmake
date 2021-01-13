# 自动检查依赖库是否找得到，生成 enviroment_config.h

# check 3rd Blibraries: QUIET, REQUIRED
# 检查程序所有可能的依赖项，然后通过宏控制程序的生成
find_package(OpenCV)
find_package(CUDA)

# dnn inference engine
find_package(OpenVINO)
find_package(TensorRT)

message(STATUS  "OpenCV:" ${OpenCV_FOUND} "; Libs:" ${OpenCV_LIBRARIES})
message(STATUS  "CUDA:" ${CUDA_FOUND} "; Libs:" ${CUDA_LIBRARIES})

# dnn inference engine
message(STATUS  "OpenVINO:" ${OpenVINO_FOUND} "; Libs:" ${OpenVINO_LIBRARIES})
message(STATUS  "TensorRT:" ${TensorRT_FOUND} "; Libs:" ${TensorRT_LIBRARIES})


# 检查第三方库的配置情况，用于控制程序功能, 检查文件是否存在避免重复更新
if(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/EnviromentConfig.h")
message(STATUS "EnviromentConfig.h Exists, Skip Generate!")
else()
configure_file(
	"${CMAKE_CURRENT_LIST_DIR}/EnviromentConfig.h.in"
	${CMAKE_CURRENT_BINARY_DIR}/EnviromentConfig.h
)
endif()