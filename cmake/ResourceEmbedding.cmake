# ResourceEmbedding.cmake
# CMake module for embedding binary resources in C++ header files

# Function to embed a single resource
function(embed_resource TARGET_NAME RESOURCE_PATH OUTPUT_PATH VARIABLE_NAME)
  # Get the absolute path to the resource
  set(RESOURCE_ABSOLUTE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${RESOURCE_PATH}")
  
  # Create the output directory if it doesn't exist
  get_filename_component(OUTPUT_DIR "${OUTPUT_PATH}" DIRECTORY)
  file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${OUTPUT_DIR}")
  
  # Full path to output file
  set(OUTPUT_ABSOLUTE_PATH "${CMAKE_CURRENT_BINARY_DIR}/${OUTPUT_PATH}")
  
  # Create the resource compiler command
  if(WIN32)
    set(COMPILER_COMMAND "pwsh")
    set(COMPILER_ARGS
      "-ExecutionPolicy" "Bypass"
      "-File" "${CMAKE_SOURCE_DIR}/cmake/scripts/EmbedResource.ps1"
      "-ResourcePath" "${RESOURCE_ABSOLUTE_PATH}"
      "-OutputPath" "${OUTPUT_ABSOLUTE_PATH}"
      "-VariableName" "${VARIABLE_NAME}"
    )
  else()
    set(COMPILER_COMMAND "${PYTHON_EXECUTABLE}")
    set(COMPILER_ARGS
      "${CMAKE_SOURCE_DIR}/cmake/scripts/embed_resource.py"
      "${RESOURCE_ABSOLUTE_PATH}"
      "${OUTPUT_ABSOLUTE_PATH}"
      "${VARIABLE_NAME}"
    )
  endif()
  
  # Add custom command to embed the resource
  add_custom_command(
    OUTPUT ${OUTPUT_ABSOLUTE_PATH}
    COMMAND ${COMPILER_COMMAND} ${COMPILER_ARGS}
    DEPENDS ${RESOURCE_ABSOLUTE_PATH}
    COMMENT "Embedding resource: ${RESOURCE_PATH}"
  )
  
  # Add the embedded resource to the target
  target_sources(${TARGET_NAME} PRIVATE ${OUTPUT_ABSOLUTE_PATH})
  
  # Add the binary directory to the include path
  target_include_directories(${TARGET_NAME} PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
endfunction()

# Function to embed all resources in a directory
function(embed_resources TARGET_NAME RESOURCE_DIR OUTPUT_DIR)
  # Find all files in the resource directory
  file(GLOB_RECURSE RESOURCE_FILES "${CMAKE_CURRENT_SOURCE_DIR}/${RESOURCE_DIR}/*.*")
  
  foreach(RESOURCE_FILE ${RESOURCE_FILES})
    # Get the relative path from the resource directory
    file(RELATIVE_PATH RESOURCE_REL_PATH "${CMAKE_CURRENT_SOURCE_DIR}/${RESOURCE_DIR}" "${RESOURCE_FILE}")
    
    # Generate variable name from the relative path
    string(REPLACE "/" "_" VARIABLE_NAME "${RESOURCE_REL_PATH}")
    string(REPLACE "." "_" VARIABLE_NAME "${VARIABLE_NAME}")
    string(REPLACE "-" "_" VARIABLE_NAME "${VARIABLE_NAME}")
    string(REPLACE " " "_" VARIABLE_NAME "${VARIABLE_NAME}")
    
    # Set the output file path
    set(OUTPUT_PATH "${OUTPUT_DIR}/${RESOURCE_REL_PATH}.gen.h")
    
    # Embed the resource
    embed_resource(${TARGET_NAME} "${RESOURCE_DIR}/${RESOURCE_REL_PATH}" "${OUTPUT_PATH}" "${VARIABLE_NAME}")
  endforeach()
endfunction()

# Function to set up editor resources
function(setup_godot_editor_resources)
  # Embed editor icons
  embed_resources(godot_editor "editor/icons" "editor/generated")
  
  # Embed editor fonts
  embed_resources(godot_editor "editor/fonts" "editor/generated")
  
  # Additional resource directories can be added here
endfunction() 