#[[ 
  Conan, the C/C++ Package Manager
    Conan是一个分散的包管理器，具有客户端 - 服务器架构。这意味着客户端可以从不同的服务器（“远程”）
  获取软件包以及上传软件包，类似于git远程控制器的“git”推拉模型。
  安装与更新
    pip install conan
    pip install --user --upgrade conan
  使用
    conan search poco --remote=conan-center
    conan info .
    conan install ...
]]


if(${PROJECT_NAME}_ENABLE_CONAN)
  #
  # Setup Conan requires and options here:
  #

  set(${PROJECT_NAME}_CONAN_REQUIRES "")
  set(${PROJECT_NAME}_CONAN_OPTIONS "")

  #
  # If `conan.cmake` (from https://github.com/conan-io/cmake-conan) does not exist, download it.
  #
  if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
    message(
      STATUS
        "Downloading conan.cmake from https://github.com/conan-io/cmake-conan..."
    )
    file(DOWNLOAD "https://github.com/conan-io/cmake-conan/raw/v0.15/conan.cmake"
      "${CMAKE_BINARY_DIR}/conan.cmake"
    )
    message(STATUS "Cmake-Conan downloaded succesfully.")
  endif()

  include(${CMAKE_BINARY_DIR}/conan.cmake)

  conan_add_remote(NAME bincrafters 
      URL
          https://api.bintray.com/conan/bincrafters/public-conan
  )

  conan_cmake_run(
    REQUIRES
      ${CONAN_REQUIRES}
    OPTIONS
      ${CONAN_OPTIONS}
    BASIC_SETUP
      CMAKE_TARGETS # Individual targets to link to
    BUILD
      missing
  )

  verbose_message("Conan is setup and all requires have been installed.")
endif()
