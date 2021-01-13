# 自动合并/配置依赖库的头文件目录和依赖库文件
# 定义如下两个变量
# DEPLIB_INCLUDE_DIRS
# DEPLIB_LIBS

# 配置系统库的依赖路径: 头文件查找路径, 库查找路径, 以及依赖库文件
# @param TARGETNAME: 自定义集合依赖库名称
# @param DepLibList: list 一组依赖库
macro(ConfigDepLibPath TARGETNAME DepLibList)
	set(${TARGETNAME}_INCLUDE_DIRS)
	set(${TARGETNAME}_LIBS)
	set(${TARGETNAME}_LIBRARY_DIRS)
	foreach(_var ${${DepLibList}})
#		message(STATUS "Add Lib: ${_var}")
		if(${_var}_FOUND)
            LIST(APPEND ${TARGETNAME}_INCLUDE_DIRS ${${_var}_INCLUDE_DIRS})
            LIST(APPEND ${TARGETNAME}_LIBRARY_DIRS ${${_var}_LIBRARY_DIRS})
            
            if(UNIX)
                # 去重，为了避免找不到定义，应该按最后出现的位置引入依赖库
                foreach(_varlib  ${${_var}_LIBRARIES})
                    LIST(FIND ${TARGETNAME}_LIBS ${_varlib} VARFOUND)
                    if(${VARFOUND} AND ${TARGETNAME}_LIBS)
                        LIST(REMOVE_ITEM ${TARGETNAME}_LIBS ${_varlib})
                    endif()
                    LIST(APPEND ${TARGETNAME}_LIBS ${_varlib})
                endforeach()
            else()
                # Link library type specifier "optimized" is followed by specifier ...
                # windows 因为区分 debug 和 release 版本，可以通过 optimized 指定链接的库
                # like set(CaffeProto_LIBRARY optimized ${CaffeProto_LIBRARY_RELEASE} debug ${CaffeProto_LIBRARY_DEBUG})
                LIST(APPEND ${TARGETNAME}_LIBS ${${_var}_LIBRARIES})
            endif()
			
		endif(${_var}_FOUND)
	endforeach()
    
	# cmake error: list sub-command REMOVE_DUPLICATES requires list to be present.
	if( ${TARGETNAME}_INCLUDE_DIRS )
		LIST(REMOVE_DUPLICATES ${TARGETNAME}_INCLUDE_DIRS)
    endif()
    
    if( ${TARGETNAME}_LIBRARY_DIRS )
		LIST(REMOVE_DUPLICATES ${TARGETNAME}_LIBRARY_DIRS)
    endif()
    
	# 依赖库列表去重的话，会将 optimized debug 去掉，
    # 这样 VS 就不能选择自动选择依赖库了
    # Linux 链接静态库循环链接时也不能移除重复库，否则可能会导致链接失败
    # 提示符号找不到, 因此要逆序删除，保留依赖关系
    #if( ${TARGETNAME}_LIBS )
    #    if(UNIX)  
    #        LIST(REMOVE_DUPLICATES ${TARGETNAME}_LIBS)
    #    endif(UNIX)
	#endif()
    
	#message(STATUS "${TARGETNAME}_INCLUDE_DIRS:" ${${TARGETNAME}_INCLUDE_DIRS})
	#message(STATUS "${TARGETNAME}_LIBS:" ${${TARGETNAME}_LIBS})
endmacro(ConfigDepLibPath)

