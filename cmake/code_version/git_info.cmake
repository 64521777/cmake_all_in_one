#[[
    获取当前代码的 git 仓库的信息
git 命令:
    获取分支名：
        git rev-parse --abbrev-ref HEAD
        git symbolic-ref --short -q HEAD
    获取当前版本提交序号：(类似SVN的全局版本号revision)
        git rev-list --count HEAD
    获取当前版本哈希值：
        git rev-parse --short HEAD
    获取当前代码改动的文件
        git status -s -uno
Usage:
    get_git_hash(GIT_HASH)
    get_git_branch(GIT_BRANCH)
	
    # 写入头文件宏定义的版本字符串，日期和 Hash
    file(WRITE ${PROJECT_BINARY_DIR}/repo_version.h
        "#define REPO_VERSION \"${GIT_REPO_VERSION}\"\n#define REPO_DATE \"${GIT_REPO_DATE}\"\n#define REPO_HASH \"${GIT_REPO_HASH}\"\n"
    )
]]


if(NOT GIT_FOUND)
    find_package(Git QUIET)     # 查找Git，QUIET静默方式不报错
endif()

# get_git_branch: 获取 git 分支
function(get_git_branch ROOT_CODE_DIR VAR)  
    if(GIT_FOUND)
        execute_process(                        # 执行一个子进程
            COMMAND ${GIT_EXECUTABLE} symbolic-ref --short -q HEAD  # 命令
            OUTPUT_VARIABLE GIT_BRANCH        # 输出字符串存入变量
            OUTPUT_STRIP_TRAILING_WHITESPACE    # 删除字符串尾的换行符
            ERROR_QUIET                         # 对执行错误静默
            WORKING_DIRECTORY                   # 执行路径
                ${ROOT_CODE_DIR}
        )
    endif()
    set (${VAR} ${GIT_BRANCH} PARENT_SCOPE)
endfunction()


# 生成版本描述字符串类似 TAG-X-gHASH
function(get_git_description ROOT_CODE_DIR VAR)  
    if(GIT_FOUND)
        execute_process(
            COMMAND ${GIT_EXECUTABLE} describe --abbrev=6 --dirty --always --tags
            OUTPUT_VARIABLE GIT_DESCRIPTION    
            OUTPUT_STRIP_TRAILING_WHITESPACE    
            ERROR_QUIET                         
            WORKING_DIRECTORY ${ROOT_CODE_DIR}
        )
    endif()
	set (${VAR} ${GIT_DESCRIPTION} PARENT_SCOPE)
endfunction()

# get_git_date: 获取最新 commit 日期，YYYY-MM-DD [GIT_DATE]
function(get_git_date ROOT_CODE_DIR VAR)   
    if(GIT_FOUND)
        execute_process(
            COMMAND ${GIT_EXECUTABLE} log -1 --format=%cd --date=short
            OUTPUT_VARIABLE GIT_DATE       
            OUTPUT_STRIP_TRAILING_WHITESPACE    
            ERROR_QUIET                         
            WORKING_DIRECTORY ${ROOT_CODE_DIR}
        )
    endif()
	set (${VAR} ${GIT_DATE} PARENT_SCOPE)
endfunction()

# get_git_hash: 获取最新 commit Hash [GIT_COMMIT_HASH]
function(get_git_hash ROOT_CODE_DIR VAR)   
    if(GIT_FOUND)
        execute_process(                      # 执行一个子进程
            COMMAND ${GIT_EXECUTABLE} log -1 --pretty=format:%h # 命令
            OUTPUT_VARIABLE GIT_COMMIT_HASH        # 输出字符串存入变量
            OUTPUT_STRIP_TRAILING_WHITESPACE    # 删除字符串尾的换行符
            ERROR_QUIET                         # 对执行错误静默
            WORKING_DIRECTORY                   # 执行路径
                ${ROOT_CODE_DIR}
        )
    endif()
	set (${VAR} ${GIT_COMMIT_HASH} PARENT_SCOPE)
endfunction()

# get_git_modified: 获取当前代码改动的文件
function(get_git_modified ROOT_CODE_DIR VAR)   
    if(GIT_FOUND)
        execute_process(                      # 执行一个子进程
            COMMAND ${GIT_EXECUTABLE} status -s -uno # 命令
            OUTPUT_VARIABLE GIT_MODIFIED       # 输出字符串存入变量
            OUTPUT_STRIP_TRAILING_WHITESPACE    # 删除字符串尾的换行符
            ERROR_QUIET                         # 对执行错误静默
            WORKING_DIRECTORY                   # 执行路径
                ${ROOT_CODE_DIR}
        )
        # 替换多余的换行和M 字符，只保留 ; 分隔的修改的文件列表
        string(REGEX REPLACE "([ \n]+)" ";" GIT_MODIFIED ${GIT_MODIFIED})
        string(REPLACE "M;" ";" GIT_MODIFIED "${GIT_MODIFIED}")
		#string(MAKE_C_IDENTIFIER ${GIT_MODIFIED} GIT_MODIFIED)
    endif()
    set (${VAR} ${GIT_MODIFIED} PARENT_SCOPE)
endfunction()

