# @author  Barthélémy von Haller

#[[
    应该从顶级的CMakeLists.txt调用enable_testing. 将include(CTest)添加到您的顶级CMakeLists.txt.

    enable_testing()
    include(CTest)
]]

verbose_message("Adding tests under ${CMAKE_PROJECT_NAME}Tests...")

#
# Load the desired unit testing framework
# Currently supported: GoogleTest (and GoogleMock), Catch2.
#
set(${CMAKE_PROJECT_NAME}_USE_GTEST 1)
if(${CMAKE_PROJECT_NAME}_USE_GTEST)
    find_package(GTest REQUIRED)

    if(${CMAKE_PROJECT_NAME}_USE_GOOGLE_MOCK)
        set(GOOGLE_MOCK_LIBRARIES GTest::gmock GTest::gmock_main)
    endif()

    # ${GTEST_BOTH_LIBRARIES}
    set(TEST_LIBS GTest::GTest GTest::Main ${GOOGLE_MOCK_LIBRARIES})
elseif(${CMAKE_PROJECT_NAME}_USE_CATCH2)
    find_package(Catch2 REQUIRED)
    set(TEST_LIBS Catch2::Catch2)
else()
    message(FATAL_ERROR "Unknown testing library. Please setup your desired unit testing library by using `target_link_libraries`.")  
endif()

#
# Compile C++ tests (here only one, but it will grab whatever cxx is in the test directory)
#
file(GLOB_RECURSE TEST_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.cxx)

# Iterate over all tests found. For each, declare an executable and add it to the tests list.
set(ALL_TESTS)

foreach(FILE ${TEST_FILES})
    string(REGEX REPLACE "[./]" "_" NAME ${FILE}) # create exe name
    add_executable(${NAME} ${FILE})

    # link against our lib and gtest
    target_link_libraries(
        ${NAME} 
        PUBLIC
            ProjA 
            ${TEST_LIBS}
    ) 

    # Add the unit tests to CMake
    add_test(
        NAME ${NAME} 
        COMMAND ${NAME}
    ) 
endforeach(FILE ${TEST_FILES})

#install(TARGETS divider_tests DESTINATION bin)

verbose_message("Finished adding unit tests for ${CMAKE_PROJECT_NAME}.")