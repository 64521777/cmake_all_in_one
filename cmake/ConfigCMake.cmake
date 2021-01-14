
#[[
    cmake 工具的一些常用配置
]]

#
# Set policy if policy is available
#
function(set_policy POL VAL)

    if(POLICY ${POL})
        cmake_policy(SET ${POL} ${VAL})
    endif()

endfunction(set_policy)

# Set policies
set_policy(CMP0054 NEW) # ENABLE CMP0054: Only interpret if() arguments as variables or keywords when unquoted.
set_policy(CMP0042 NEW) # ENABLE CMP0042: MACOSX_RPATH is enabled by default.
set_policy(CMP0063 NEW) # ENABLE CMP0063: Honor visibility properties for all target types.
set_policy(CMP0077 NEW) # ENABLE CMP0077: option() honors normal variables