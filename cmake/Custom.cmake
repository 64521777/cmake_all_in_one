#[[
    定义了一些常用的函数和宏
]]

#
# set variable to value if variable is not defined
#

function (set_ifndef variable value)
  if(NOT DEFINED ${variable})
    set(${variable} ${value} PARENT_SCOPE)
  endif()
endfunction()


#
# Print a message only if the `VERBOSE_OUTPUT` option is on
#

function(verbose_message content)
    if(${PROJECT_NAME}_VERBOSE_OUTPUT)
		message(STATUS ${content})
    endif()
endfunction()


#
# Define function "source_group_by_path with three mandatory arguments (PARENT_PATH, REGEX, GROUP, ...)
# to group source files in folders (e.g. for MSVC solutions).
#
# Example:
# source_group_by_path("${CMAKE_CURRENT_SOURCE_DIR}/src" "\\\\.h$|\\\\.inl$|\\\\.cpp$|\\\\.c$|\\\\.ui$|\\\\.qrc$" "Source Files" ${sources})
#

function(source_group_by_path PARENT_PATH REGEX GROUP)

    foreach (FILENAME ${ARGN})
        
        get_filename_component(FILEPATH "${FILENAME}" REALPATH)
        file(RELATIVE_PATH FILEPATH ${PARENT_PATH} ${FILEPATH})
        get_filename_component(FILEPATH "${FILEPATH}" DIRECTORY)

        string(REPLACE "/" "\\" FILEPATH "${FILEPATH}")

	source_group("${GROUP}\\${FILEPATH}" REGULAR_EXPRESSION "${REGEX}" FILES ${FILENAME})

    endforeach()

endfunction(source_group_by_path)

#
# Function that extract entries matching a given regex from a list.
# ${OUTPUT} will store the list of matching filenames.
#

function(list_extract OUTPUT REGEX)

    foreach(FILENAME ${ARGN})
        if(${FILENAME} MATCHES "${REGEX}")
            list(APPEND ${OUTPUT} ${FILENAME})
        endif()
    endforeach()

    set(${OUTPUT} ${${OUTPUT}} PARENT_SCOPE)

endfunction(list_extract)

#
# Function to link between sub-projects
#

function(add_dependent_subproject subproject_name)
    #if (NOT TARGET ${subproject_name}) # target unknown
    if(NOT PROJECT_${subproject_name}) # var unknown because we build only this subproject, ProjA must have been built AND installed
        find_package(${subproject_name} CONFIG REQUIRED)
    else () # we know the target thus we are doing a build from the top directory
        include_directories(../${subproject_name}/include)
    endif ()
endfunction(add_dependent_subproject)

#
# Add a target for formating the project using `clang-format` (i.e: cmake --build build --target clang-format)
#

function(add_clang_format_target)
    if(NOT ${PROJECT_NAME}_CLANG_FORMAT_BINARY)
			find_program(${PROJECT_NAME}_CLANG_FORMAT_BINARY clang-format)
    endif()

    if(${PROJECT_NAME}_CLANG_FORMAT_BINARY)
			if(${PROJECT_NAME}_BUILD_EXECUTABLE)
				add_custom_target(clang-format
						COMMAND ${${PROJECT_NAME}_CLANG_FORMAT_BINARY}
						-i $${CMAKE_CURRENT_LIST_DIR}/${exe_sources} ${CMAKE_CURRENT_LIST_DIR}/${headers})
			elseif(${PROJECT_NAME}_BUILD_HEADERS_ONLY)
				add_custom_target(clang-format
						COMMAND ${${PROJECT_NAME}_CLANG_FORMAT_BINARY}
						-i ${CMAKE_CURRENT_LIST_DIR}/${headers})
			else()
				add_custom_target(clang-format
						COMMAND ${${PROJECT_NAME}_CLANG_FORMAT_BINARY}
						-i ${CMAKE_CURRENT_LIST_DIR}/${sources} ${CMAKE_CURRENT_LIST_DIR}/${headers})
			endif()

			message(STATUS "Format the project using the `clang-format` target (i.e: cmake --build build --target clang-format).\n")
    endif()
endfunction()


#
# show current cmake variables
#

function(show_cmake_variables)
    # information of top project
    message(STATUS "CMAKE_PROJECT_NAME: ${CMAKE_PROJECT_NAME}")
    message(STATUS "CMAKE_PROJECT_VERSION: ${CMAKE_PROJECT_VERSION}")
    message(STATUS "CMAKE_SOURCE_DIR: ${CMAKE_SOURCE_DIR}")
    message(STATUS "CMAKE_BINARY_DIR: ${CMAKE_BINARY_DIR}")
    message(STATUS "CMAKE_RUNTIME_OUTPUT_DIRECTORY: ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
    message(STATUS "CMAKE_ARCHIVE_OUTPUT_DIRECTORY: ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
    message(STATUS "CMAKE_LIBRARY_OUTPUT_DIRECTORY: ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
    # information of current porject
    message(STATUS "PROJECT_NAME: ${PROJECT_NAME}")
    message(STATUS "PROJECT_SOURCE_DIR: ${PROJECT_SOURCE_DIR}")
    message(STATUS "PROJECT_BINARY_DIR: ${PROJECT_BINARY_DIR}")
    # information of current file
    message(STATUS "CMAKE_CURRENT_LIST_FILE: ${CMAKE_CURRENT_LIST_FILE}")
endfunction()