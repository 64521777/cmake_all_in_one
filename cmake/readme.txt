来源 OpenVINO 的 cmake 模块
api_validator

clang_format
    ClangFormat 入门教程(https://www.cnblogs.com/liuyunbin/p/11538267.html)
    简介
        ClangFormat 是一个规范代码的工具
        ClangFormat 支持的语言有：C/C++/Java/JavaScript/Objective-C/Protobuf/C#
        ClangFormat 支持的规范有：LLVM，Google，Chromium，Mozilla 和 WebKit
    安装
        sudo apt install clang-format
    使用
        预览规范后的代码
        $ clang-format main.cc
        直接在原文件上规范代码
        $ clang-format -i main.cc
        显示指明代码规范，默认为 LLVM
        $ clang-format -style=google main.cc
        将代码规范配置信息写入文件 .clang-format
        $ clang-format -dump-config > .clang-format
        使用自定义代码规范，规范位于当前目录或任一父目录的文件 .clang-format 或 _clang-format 中（如果未找到文件，使用默认代码规范）
        $ clang-format -style=file main.cc
coverage
    代码覆盖度检查：要想保持测试的完整性，需要将gtest与lcov配合使用，方能更好地测试源码的质量。
    gcov是一个测试代码覆盖率的程序，正确地使用它搭配GCC可以分析、帮助你将代码写得更高效。帮助你优化程序。类似于一个profiling tool，使用gcov或者gprof，可以收集到一些基础的性能统计数据。
    lcov 是GCC 测试覆盖率的前端图形展示工具。它通过收集多个源文件的 行、函数和分支的代码覆盖信息（程序执行之后生成gcda、gcno文件，上面的链接有讲） 并且将收集后的信息生成HTML页面。
cpplint
    cpplint是Google使用 python 语言开发的一个C++代码风格检查工具，如果是遵循google code style的，可以使用cpplint作为代码规范的一个检查工具。
    安装与使用
        pip install cpplint
        cpplint [OPTIONS] files
cross_compile
    交叉编译
download
    下载脚本
shellcheck
    在Linux/Unix平台下编写Bash的时候，shellcheck是一款不错的工具。当编译大量的Bash代码的，常常会花掉大量的时间，然而通过shellcheck你可以提前知道脚本的语法问题，shellcheck也会给出纠错提示。
    `shellcheck myscript`
	
来源 TensorRT 的 cmake 模块	
toolchains

自定义模块
modules

代码块

1. CMake>=3.0的时候支持多行注释，以#[[开始进行块注释，并且在块注释的一端与]]结束。

2.  Enable package managers, add after project command
include(package/Conan.cmake)
include(package/Vcpkg.cmake)

3. 检查当前项目是否是顶层项目
# only activate tools for top level project
if(NOT PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
  return()
endif()

# Make sure we tell the topdir CMakeLists that we exist (if build from topdir)
get_directory_property(hasParent PARENT_DIRECTORY)
if(hasParent)
    set(PROJECT_${PROJECT_NAME} true PARENT_SCOPE)
endif()


# Set the compiler standard for the target
add_executable(target ${sources})
target_compile_features(target PUBLIC cxx_std_17)

# Setup code coverage if enabled
if (${CMAKE_PROJECT_NAME}_ENABLE_CODE_COVERAGE)
  target_compile_options(${CMAKE_PROJECT_NAME} PUBLIC -O0 -g -fprofile-arcs -ftest-coverage)
  target_link_options(${CMAKE_PROJECT_NAME} PUBLIC -fprofile-arcs -ftest-coverage)
  verbose_message("Code coverage is enabled and provided with GCC.")
endif()


# Find all headers and implementation files
include(cmake/SourcesAndHeaders.cmake)

if(${PROJECT_NAME}_BUILD_EXECUTABLE)
  add_executable(${PROJECT_NAME} ${exe_sources})
  add_library(${PROJECT_NAME}_LIB ${headers} ${sources})
elseif(${PROJECT_NAME}_BUILD_HEADERS_ONLY)
  add_library(${PROJECT_NAME} INTERFACE)
else()
  add_library(
    ${PROJECT_NAME}
    ${headers}
    ${sources}
  )
endif()
