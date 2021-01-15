GIT、CMAKE高效管理C++跨平台项目 ( https://www.jianshu.com/p/036a16a50e54?from=singlemessage )
  build     [编译目录]
  install   [部署目录]
  ----bin   [.exe、.dll、.so等]
  ----lib   [.lib、.a等]
  ----include [c++接口文件目录]
  doc       [项目文档目录]
  gtest     [项目测试目录]
  server    [项目名称]
  ----CMake [cmake plugin插件目录]
  ----CMakeLists.txt
  ----core  [依赖自己的库]
  ----log   [即将实现的库]
  --------CMakeLists.txt
  --------dependencies
  ------------thirdpj [依赖别人的不开源库目录]
  ----------------include
  ----------------lib
  --------external
  ------------jsoncpp [依赖别人的开源库目录]
  --------inc
  ------------private [功能文件h目录]
  ----------------stdafx.h   [预编译文件]
  ------------public  [接口文件h目录]
  ----------------log_public.h [接口文件]
  --------src         [实现文件cpp目录]

SERVER项目CMAKE
  #cmake要求最低版本
  cmake_minimum_required(VERSION 3.15.0)

  #建立项目
  project(server)

  #设置项目版本
  SET(SOVERSION 1)
  SET(VERSION 1.0.0)

  #设置项目依赖的cmake插件
  #cotire插件用于做c++预编译处理
  set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/CMake")
  include(cotire)

  #声明core库开关
  option(BUILD_CORE "Build core" ON)
  #声明core库编译成静态库或者动态库开关
  option(BUILD_CORE_STATIC "Build core static libraries" OFF)
  #声明log库开关
  option(BUILD_LOG "Build log" ON)
  #声明log库编译成静态库或者动态库开关
  option(BUILD_LOG_STATIC "Build log static libraries" OFF)

  #根据开关添加库
  if (BUILD_CORE)
      add_subdirectory(core)
  endif ()

  if (BUILD_LOG)
      add_subdirectory(log)
  endif ()

LOG库CMAKE

  #设置[实现文件cpp目录]
  file(GLOB SOURCES src/*.cpp)

  #根据项目声明开关设置生成静态库或者动态库
  if (BUILD_LOG_STATIC)
      add_library(log STATIC ${SOURCES})
  else ()
      add_library(log SHARED ${SOURCES})
  endif ()

  #add_definitions设置编辑编译FLAG，/D或-D 
  #如果是windows开发者，应该比较熟悉，就是配置__declspec(dllexport)和__declspec(dllimport)
  #如果是linux或其它平台均是空
  add_definitions(-DLOG_API=__DLL_EXPORT)
  add_definitions(-DCORE_API=__DLL_IMPORT)

 #设置不同平台编译参数
 if (WIN32)
        add_definitions(-D_CRT_SECURE_NO_WARNINGS)
    set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -std=c++11 /W4 /Od /DDEBUG /MDd")
    set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -std=c++11 /W4 /O2 /DNDEBUG /MD")
 else ()
    set(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -std=c++11 -O0 -W -Wall -g -ggdb")
    set(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -std=c++11 -rdynamic -O2 -W -Wall -DNDEBUG")
    target_link_libraries(log pthread)
 endif ()

  #设置[依赖别人的开源库目录]
  #注意:这个目录是git submodule来管理的
  add_subdirectory(external/jsoncpp)

  #设置[依赖自己的库]
  add_dependencies(log core)

  #设置链接的依赖库
  target_link_libraries(log core jsoncpp_lib)

  #target_link_directories用来设置[依赖别人的不开源库目录]，本项目没有只做展示
  #target_link_directories(log PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/dependencies/thirdpj/lib")

  #设置头文件引用，注意private引用和public引用
  #public引用就是目录里的头文件都是库接口文件
  target_include_directories(log 
      PRIVATE 
    "${CMAKE_CURRENT_SOURCE_DIR}/inc/private" #[功能文件h目录]，注意是private引用
    "${CMAKE_SOURCE_DIR}/include"
    "${CMAKE_CURRENT_SOURCE_DIR}/dependencies/thirdpj/include" #[依赖别人的不开源库目录]，注意是private引用
      PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/inc/public" #[接口文件h目录]，注意是public引用
  )

  #设置LOG库预编译头文件stdafx.h
  set_target_properties(log PROPERTIES
      SOVERSION ${SOVERSION}
      VERSION ${VERSION}
      COTIRE_CXX_PREFIX_HEADER_INIT "${CMAKE_CURRENT_SOURCE_DIR}/inc/private/stdafx.h"
  )
  cotire(log)

  #将LOG部署成第三方给别人使用
  #即设置[.exe、.dll、.so等]和[.lib、.a等]
  install(TARGETS log
      ARCHIVE DESTINATION lib/log
      LIBRARY DESTINATION lib/log
      RUNTIME DESTINATION bin
      COMPONENT library
  )

  #设置引用头文件[c++接口文件目录]
  file(GLOB INCLUDES inc/public/*.h inc/public/*.config)
  install(FILES ${INCLUDES} DESTINATION include/log)
  


This C++ project demonstrates the usage of CMake, boost's test, boost's option parsing and
Doxygen. It is not the simplest example ever because we want to show how to use them
in a proper non-minimalistic way. It also shows a way to structure the code and the other
type of files.

## Project description and aim

Our project is made of two subprojects : ProjA and ProjB. ProjB depends of ProjA.
The project produces 2 libraries (libProjA.so and libProjB.so) and 2 binaries linked against their
respective library (projArunner and projBrunner).
Packages for multiple platform should be produced : 1 single for ProjB and 3 different for ProjA
(libs, devel, doc).
We have tests for each project that should be runnable.

We want to be able to compile independently one or the other project or both at the same time.
When compiling ProjB independently we must have installed ProjA before, either from source or
from a package.

## Project structure and organisation

    The general structure is
    ├── cmake
    │   └── <all cmake macro files requested by more than one subproject>
    ├── CMakeLists.txt               # main CMakeLists.txt
    ├── ProjA
    │   ├── cmake
    │   │   ├── CPackConfig.cmake    # for Cpack
    │   │   └── ProjAConfig.cmake    # for subprojects interdependencies
    │   ├── CMakeLists.txt           # main CmakeLists.txt for ProjA
    │   ├── doc
    │   │   └── <Doxygen files and CMakeLists.txt>
    │   ├── include
    │   │   ├── CMakeLists.txt
    │   │   └── ProjA                # project subfolder to appear in includes (e.g. include <ProjA/World.h>)
    │   │       ├── CMakeLists.txt
    │   │       ├── Version.h.in     # template for the Version class
    │   │       └── World.h
    │   ├── src
    │   │   ├── CMakeLists.txt       # this is where we define the key targets for this subproject
    │   │   ├── main.cxx
    │   │   ├── Version.cxx
    │   │   └── World.cxx
    │   └── test
    │       ├── CMakeLists.txt
    │       └── testProjA.cxx
    ├── ProjB
    │   └── <same as ProjA>
    └── README

The headers and source files are split in each subproject. The headers are under a directory with
the name of the project. We want that users of our libraries write "include <ProjA/xxx.h>" and not
just "include <xxx.h>" to avoid conflicts.

## Requirements

* doxygen: http://www.stack.nl/~dimitri/doxygen/
* graphviz: http://www.graphviz.org/
* cmake > 2.8
* ccmake
* boost 1.58

## CMake

CMake (www.cmake.org) is the make tool we use in this project. 
Its config file is a plain text file called CMakeLists.txt. 
You will find a sample one right next to this README. It is commented heavily for reference.

#### The cmake way 
    
The commands to build the project would be:
``` 
    mkdir build_dir
    cd build_dir
    cmake .. 
    make 
    make install
```
Installation goes to /usr/local/ by default.
  
#### More advanced way 

To use it run `ccmake ..` in the top
directory of the project. Then turn on the options that you want by
going up and down with arrows, hitting "enter" to edit values and hitting
it again to exit edition. 
For example, you might want to enable building documentation for the
sample project. Then press "c" followed by "g" to generate a
makefile. It will bring you back to the terminal. Then type "make"
    
One can also pass parameters to cmake when configuring it using "-DMY_VARIABLE VALUE".
For example to build a debug version or a release version with debug symbols could look like : 
```
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
    cmake -DCMAKE_BUILD_TYPE=Debug ..
```

#### List of targets 

From the ./build or ./ProjX/build, one can call :
* make [-j<number_of_parallel_jobs>]
* make test
* make install
* make doc
* make package

Important note : to be able to compile ProjB alone, one must first make and install ProjA. 
Moreover, one must add to PATH and LD_LIBRARY_PATH the installation directory of ProjA.

## Docs (Doxygen)

There is a default doc target in the CMakeLists.txt, which is built
when you type "make doc". You must have doxygen
installed on your system for this to work. See source code
for hints on how to write doxygen comments.
You can customize the output by editing config files in the doc directory.

Documentation is placed in: BUILD_DIR/doc BUILD_DIR is the build in which you say "make".
After installation, it will go by default to /usr/local/share.

## Tests

There are 2 dummy tests defined in the CMakeLists.txt. The unit test
source is in the test directory.  To run the dummy test, do "make
test".

## Boost

We include boost in the CMakeLists.txt using find_package(Boost ...) and 
passing a list of components we intend to use, namely unit_test_framework 
and program_options. 
    
The former is to ease the development of unit tests and the latter is 
to help getting options for your binaries. See apps/hellorunner/main.cxx 
for an example. 
    
## SVN and Git

The project shows how to use Git or SVN revision number. In the main 
CMakeLists.txt we include one or the other by commenting and uncommenting
the corresponding lines. It will define a CMake variable
that will be used when generating libs/hello/Version.h.

GetGitRevisionDescription module has been added to the CMake folder in the 
"CMake" directory in order to retrieve branch and revision information
from Git repository. Starting with Git 1.9 the module will be part of 
official cMake distribution, until then it has to be part of the 
application.
    
## Packaging

CPack permits building packages based on CMake. One should add CPackConfig
as it is done in the last line of the CMakeLists.txt. CPackConfig.cmake 
is in cmake folder and contains the required variables.
If you do "make package" it will create a tarball, a .deb and an rpm. 

## Code formatting and beautifier

The file .clang-formatter contains a set of rules that one can use to adapt
the source code to coding conventions. Clang has a number of predefined
formatting rules but here we use a custom one. To use it one must first 
install clang. 
To run it on a single file and see the modified file content : 
    
    clang-format -style=file <source file> # from the top directory

To run it on all subdirectories and replace the content of the .cxx and .h
files with the modified content : 

    find . -name *.cxx -o -name *.h | xargs clang-format -style=file -i
    

## Remarks

CMake is cross-platforms. Thus there are commands that might be there 
only to be compatible with one or the other platforms. In this project
we focus on Linux and removed most of these specificities for sake 
of simplicity.
    

For any question, please contact:
Barthélémy von Haller (barthelemy_vonhaller@yahoo.fr)
