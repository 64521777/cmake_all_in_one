#[[
    clang-tidy是一个基于clang的静态代码分析框架，支持C++/C/Objective-C。
    1、clang-tidy是基于AST的静态检查工具。因为它基于AST,所以要比基于正则表达式的静态检查工具更为精准，
        但是带来的缺点就是要比基于正则表达式的静态检查工具慢一点。
    2、clang-tidy不仅仅可以做静态检查，还可以做一些修复工作。
]]

# Function to register a target for clang-tidy
function(perform_clang_tidy check_target target)
    set(includes "$<TARGET_PROPERTY:${target},INCLUDE_DIRECTORIES>")

    add_custom_target(
        ${check_target}
        COMMAND
            ${clang_tidy_EXECUTABLE}
                -p\t${PROJECT_BINARY_DIR}
                ${ARGN}
                -checks=*
                "$<$<NOT:$<BOOL:${CMAKE_EXPORT_COMPILE_COMMANDS}>>:--\t$<$<BOOL:${includes}>:-I$<JOIN:${includes},\t-I>>>"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    
    set_target_properties(${check_target}
        PROPERTIES
        FOLDER "Maintenance"
        EXCLUDE_FROM_DEFAULT_BUILD 1
    )
    
    add_dependencies(${check_target} ${target})
endfunction()
