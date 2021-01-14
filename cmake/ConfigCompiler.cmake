
#[[
    编译器配置
]]

# ---[complier options for picasso
set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)
SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -g")
SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -g")


if(NOT WIN32)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99")
  set(CMAKE_C_FLAGS "${CMAKE_CXX_FLAGS}  -fPIC")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-error=deprecated-declarations -Wno-deprecated-declarations")
else()
  add_definitions(-DGLOG_NO_ABBREVIATED_SEVERITIES)
  add_definitions(-DHAVE_STRUCT_TIMESPEC)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
  add_definitions(-DVL_DISABLE_SSE2)
  add_compile_options(/wd4267 /wd4819 /wd4244 /wd4350 /wd4251 /wd4275 /wd4838 /wd4010 /wd4305 /wd4005 /wd4146 /wd4018)
endif ()

if(USE_CPP11)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
else()
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
endif ()

if (ENABLE_GPROF)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -pg")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -pg")
endif ()


if (CPU AND NCNN)
    # ADD depend
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lpthread -lrt -lm")
endif()

if (ARM)
    # set ${CMAKE_C_FLAGS} and ${CMAKE_CXX_FLAGS}flag for cross-compiled process
    SET ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=armv8-a -fopenmp -lpthread -lrt -lm" )
endif(ARM)