
# set(CMAKE_CXX_STANDARD 11) 


# CMake useful variables
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib") 
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")

# -- create virtual doc target for all sub project's doc target
if(${PROJECT_NAME}_ENABLE_DOXYGEN)
    # Target doc definition
    # The challenge here is that the sub projects must all define a custom target but with different names to avoid
    # conflicts. We also want to be able to issue "make doc" from the top dir while being able to issue "make doc"
    # in the subdirs *when* we compile only a subproject.
    # We define as well a function AddDocTarget in cmake/DoxygenTarget.cmake
    add_custom_target(doc) # DEPENDS docProjA docProjB) Note: with CMake 3.X the DEPENDS would work
    ADD_DEPENDENCIES(doc docProjA docProjB)
endif()


# -- from https://github.com/filipdutescu/modern-cpp-template cmake/Doxygen.cmake --
# auto generate doc from code to doc dir
if(${PROJECT_NAME}_ENABLE_DOXYGEN)
    set(DOXYGEN_CALLER_GRAPH YES)
    set(DOXYGEN_CALL_GRAPH YES)
    set(DOXYGEN_EXTRACT_ALL YES)
    set(DOXYGEN_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/docs)

    find_package(Doxygen REQUIRED dot)
    doxygen_add_docs(doxygen-docs ${PROJECT_SOURCE_DIR})

    verbose_message("Doxygen has been setup and documentation is now available.")
endif()


#
# Generate export header if specified
#
if(${PROJECT_NAME}_GENERATE_EXPORT_HEADER)
    include(GenerateExportHeader)
    generate_export_header(${PROJECT_NAME})
    install(
        FILES
        ${PROJECT_BINARY_DIR}/${PROJECT_NAME}_export.h 
        DESTINATION
        include
    )
    message(STATUS "Generated the export header `${PROJECT_NAME_LOWERCASE}_export.h` and installed it.")
endif()

set(WriterCompilerDetectionHeaderFound NOTFOUND)
# This module is only available with CMake >=3.1, so check whether it could be found
# BUT in CMake 3.1 this module doesn't recognize AppleClang as compiler, so just use it as of CMake 3.2
if (${CMAKE_VERSION} VERSION_GREATER "3.2")
    include(WriteCompilerDetectionHeader OPTIONAL RESULT_VARIABLE WriterCompilerDetectionHeaderFound)
endif()