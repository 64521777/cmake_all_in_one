#[[
  Doxygen： Generate documentation from source code
安装 
  Debian/Ubuntu: sudo apt-get install doxygen graphviz
  Windows: choco install doxygen.install graphviz -y
  MacOS: brew install doxygen graphviz
使用:
  Step 1: 创建配置文件; doxygen -g <config-file>
  Step 2: 运行 doxygen; doxygen <config-file>
  Step 3: Documenting the sources
]]

function(PrepareDocTarget)

  # Configure the doxygen config file with current settings:
  configure_file(documentation-config.doxygen.in ${CMAKE_CURRENT_BINARY_DIR}/documentation-config.doxygen @ONLY)

  # Set the name of the target : "doc" if it doesn't already exist and "doc<projectname>" if it does.
  # This way we make sure to have a single "doc" target. Either it is the one of the top directory or
  # it is the one of the subproject that we are compiling alone.
  set(DOC_TARGET_NAME "doc")
  if(TARGET doc)
    set(DOC_TARGET_NAME "doc${PROJECT_NAME}")
  endif()

  add_custom_target(${DOC_TARGET_NAME} ${TARGET_ALL}
      ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/documentation-config.doxygen
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      COMMENT "Generating API documentation using doxygen for ${PROJECT_NAME}" VERBATIM)

  set(INSTALL_DOC_DIR ${CMAKE_BINARY_DIR}/doc/${PROJECT_NAME}/html)
  file(MAKE_DIRECTORY ${INSTALL_DOC_DIR}) # needed for install

  install(DIRECTORY ${INSTALL_DOC_DIR} DESTINATION share/${PROJECT_NAME}-${VERSION_MAJOR} COMPONENT doc)

endfunction()


if(${PROJECT_NAME}_ENABLE_DOXYGEN)
    set(DOXYGEN_CALLER_GRAPH YES)
    set(DOXYGEN_CALL_GRAPH YES)
    set(DOXYGEN_EXTRACT_ALL YES)
    set(DOXYGEN_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/docs)

    find_package(Doxygen REQUIRED dot)
    doxygen_add_docs(doxygen-docs ${PROJECT_SOURCE_DIR})

    verbose_message("Doxygen has been setup and documentation is now available.")
endif()