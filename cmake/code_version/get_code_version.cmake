
function(get_code_version_simple VAR)
    set (VCS_REVISION "-1")

    if(EXISTS "${CMAKE_SOURCE_DIR}/.git")
        ## Git (and its revision)
        find_package(Git QUIET) # if we don't find git or FindGit.cmake is not on the system we ignore it.

        ## GetGitRevisionDescription module to retreive branch and revision information from Git
        ## Starting with Git 1.9 the module will be part of official cMake distribution, until then it has to be part of the application
        ## The Git module will trigger a reconfiguration for each pull that will bring a new revision on the local repository

        if(GIT_FOUND)
            include(GetGitRevisionDescription)
            get_git_head_revision(GIT_REFSPEC GIT_SHA1)
            message(STATUS "GIT branch ${GIT_REFSPEC}")
            message(STATUS "GIT revision ${GIT_SHA1}")
            set (VCS_REVISION ${GIT_SHA1})
        else(GIT_FOUND)
            message(STATUS "git-NOT-FOUND, get code info failed")
        endif(GIT_FOUND)

    elseif(EXISTS "${CMAKE_SOURCE_DIR}/.svn")

        # SVN (and its revision)
        include(FindSubversion)

        if(Subversion_FOUND)
            Subversion_WC_INFO(${CMAKE_SOURCE_DIR} MY)
            SET(VCS_REVISION "${MY_WC_REVISION}")
        else(Subversion_FOUND)
            message(STATUS "svn-NOT-FOUND, get code info failed")
        endif(Subversion_FOUND)
        
    endif()

    set (${VAR} ${VCS_REVISION} PARENT_SCOPE)
endfunction()


function(get_code_version ROOT_CODE_DIR VAR)
    set (VCS_REVISION "-1")

    if(EXISTS "${ROOT_CODE_DIR}/.git")
		
        ## Git (and its revision)
        find_package(Git QUIET) # if we don't find git or FindGit.cmake is not on the system we ignore it.
		
        message(STATUS "Find CodeInfo by Git: ${GIT_FOUND}")

        if(GIT_FOUND)
            include(${CMAKE_CURRENT_LIST_DIR}/code_version/git_info.cmake)
            get_git_branch(${ROOT_CODE_DIR} GIT_BRANCH)
            get_git_hash(${ROOT_CODE_DIR} GIT_HASH)
            get_git_date(${ROOT_CODE_DIR} GIT_DATE)
            get_git_modified(${ROOT_CODE_DIR} GIT_MODIFIED)
            message(STATUS "GIT Status: ${GIT_BRANCH} ${GIT_DATE} ${GIT_HASH} ${GIT_MODIFIED}")
            set (VCS_REVISION ${GIT_BRANCH}_${GIT_DATE}_${GIT_HASH}_[${GIT_MODIFIED}])
        else(GIT_FOUND)
            message(STATUS "git-NOT-FOUND, get code info failed")
        endif(GIT_FOUND)

    elseif(EXISTS "${ROOT_CODE_DIR}/.svn")

        # SVN (and its revision)
        include(FindSubversion)
		
        message(STATUS "Find CodeInfo by Svn: ${Subversion_FOUND}")

        if(Subversion_FOUND)
            Subversion_WC_INFO(${ROOT_CODE_DIR} MY)
            SET(VCS_REVISION "${MY_WC_REVISION}")
        else(Subversion_FOUND)
            message(STATUS "svn-NOT-FOUND, get code info failed")
        endif(Subversion_FOUND)
        
    endif()
	
        message(STATUS "Find CodeInfo None: ${ROOT_CODE_DIR}")

    set (${VAR} ${VCS_REVISION} PARENT_SCOPE)
endfunction()