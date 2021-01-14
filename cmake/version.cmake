# 
# Project description and (meta) information
# 

if(EXISTS "${CMAKE_CURRENT_BINARY_DIR}/Version.h")
return()
endif()

# Get git revision

include(code_version/get_code_version)

SET(ROOT_CODE_DIR "E:/workspace/smartvision")

get_code_version(${ROOT_CODE_DIR} GIT_REV)

# Meta information about the project
set(META_PROJECT_NAME        "picasso")
set(META_PROJECT_DESCRIPTION "CMake Project Template")
set(META_AUTHOR_ORGANIZATION "CG Internals GmbH")
set(META_AUTHOR_DOMAIN       "https://github.com/cginternals/cmake-init/")
set(META_AUTHOR_MAINTAINER   "opensource@cginternals.com")
set(META_VERSION_MAJOR       "2")
set(META_VERSION_MINOR       "0")
set(META_VERSION_PATCH       "0")
set(META_VERSION_REVISION    "${GIT_REV}")
set(META_VERSION             "${META_VERSION_MAJOR}.${META_VERSION_MINOR}.${META_VERSION_PATCH}")
set(META_NAME_VERSION        "${META_PROJECT_NAME} v${META_VERSION} (${META_VERSION_REVISION})")
set(META_CMAKE_INIT_SHA      "${GIT_REV}")

string(MAKE_C_IDENTIFIER ${META_PROJECT_NAME} META_PROJECT_ID)
string(TOUPPER ${META_PROJECT_ID} META_PROJECT_ID)

# Create version file
file(WRITE "${PROJECT_BINARY_DIR}/VERSION" "${META_NAME_VERSION}")

# Produce the final Version.h using template Version.h.in and substituting variables.
# We don't want to polute our source tree with it, thus putting it in binary tree.
configure_file(
    "${CMAKE_CURRENT_LIST_DIR}/Version.h.in" 
    "${CMAKE_CURRENT_BINARY_DIR}/Version.h" 
    @ONLY)


#[[
# [可选] 安装命令
install(
  FILES
    ${CMAKE_CURRENT_BINARY_DIR}/include/${PROJECT_NAME_LOWERCASE}/version.hpp
  DESTINATION
    include/${PROJECT_NAME_LOWERCASE}
)
]]

# picasso used version definition
#SET(Major 2 CACHE STRING "major version")
#SET(Minor 0 CACHE STRING "minor version")
#SET(Patch 01 CACHE STRING "patch version")

string(TIMESTAMP Build "%y%m%d")
set(SDK_VER_NO "${Major}.${Minor}.${Patch}.${Build}" CACHE STRING "code logical version")
add_definitions(-DSDK_VER_NO="${SDK_VER_NO}")

