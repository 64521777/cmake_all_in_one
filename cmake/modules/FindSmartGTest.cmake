# - Try to find gtest
#
# The following variables are optionally searched for defaults
#  GTest_ROOT_DIR:            Base directory where all GTest components are found
#
# The following are set after configuration is done:
#  GTest_FOUND
#  GTest_INCLUDE_DIRS
#  GTest_LIBRARIES
#  GTest_LIBRARYRARY_DIRS

include(FindPackageHandleStandardArgs)

if(DEFINED ENV{VCPKG_ROOT})
	find_package(gtest)
	if ( ${gtest_FOUND} )
		set(GTest_FOUND 1)
		set(GTest_LIBRARY GTest::gtest GTest::gtest_main GTest::gmock GTest::gmock_main)
		message(STATUS "vcpkg find gtest")
	endif()
endif()

if(GTest_FOUND)
  set(GTest_INCLUDE_DIRS ${GTest_INCLUDE_DIR})
  set(GTest_LIBRARIES ${GTest_LIBRARY})
endif()
