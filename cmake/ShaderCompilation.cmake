# ShaderCompilation.cmake
# CMake module for compiling GLSL shaders to header files in Godot

# Define a function to compile GLSL shaders
function(compile_shader TARGET_NAME SHADER_FILE OUTPUT_FILE)
  # Get the shader type from the file extension
  get_filename_component(SHADER_EXT ${SHADER_FILE} EXT)
  string(REPLACE "." "" SHADER_TYPE ${SHADER_EXT})
  
  # Create the shader compiler command
  if(WIN32)
    set(COMPILER_COMMAND "pwsh")
    set(COMPILER_ARGS
      "-ExecutionPolicy" "Bypass"
      "-File" "${CMAKE_SOURCE_DIR}/cmake/scripts/CompileShader.ps1"
      "-ShaderPath" "${CMAKE_CURRENT_SOURCE_DIR}/${SHADER_FILE}"
      "-OutputPath" "${CMAKE_CURRENT_BINARY_DIR}/${OUTPUT_FILE}"
      "-ShaderType" "${SHADER_TYPE}"
    )
  else()
    set(COMPILER_COMMAND "${PYTHON_EXECUTABLE}")
    set(COMPILER_ARGS
      "${CMAKE_SOURCE_DIR}/cmake/scripts/compile_shader.py"
      "${CMAKE_CURRENT_SOURCE_DIR}/${SHADER_FILE}"
      "${CMAKE_CURRENT_BINARY_DIR}/${OUTPUT_FILE}"
      "${SHADER_TYPE}"
    )
  endif()
  
  # Add custom command to compile the shader
  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${OUTPUT_FILE}
    COMMAND ${COMPILER_COMMAND} ${COMPILER_ARGS}
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${SHADER_FILE}
    COMMENT "Compiling shader: ${SHADER_FILE}"
  )
  
  # Add the compiled shader to the sources of the target
  target_sources(${TARGET_NAME} PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/${OUTPUT_FILE})
  
  # Add the binary directory to the include path
  target_include_directories(${TARGET_NAME} PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
endfunction()

# Function to compile all shaders in a directory
function(compile_shader_directory TARGET_NAME SHADER_DIR OUTPUT_DIR)
  # Create the output directory if it doesn't exist
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${OUTPUT_DIR})
  
  # Find all shader files in the directory
  file(GLOB SHADER_FILES 
    "${CMAKE_CURRENT_SOURCE_DIR}/${SHADER_DIR}/*.glsl"
    "${CMAKE_CURRENT_SOURCE_DIR}/${SHADER_DIR}/*.vert"
    "${CMAKE_CURRENT_SOURCE_DIR}/${SHADER_DIR}/*.frag"
    "${CMAKE_CURRENT_SOURCE_DIR}/${SHADER_DIR}/*.comp"
  )
  
  # Compile each shader
  foreach(SHADER_FILE ${SHADER_FILES})
    # Get the filename without path
    get_filename_component(SHADER_NAME ${SHADER_FILE} NAME_WE)
    get_filename_component(SHADER_EXT ${SHADER_FILE} EXT)
    
    # Convert relative path to just filename
    file(RELATIVE_PATH REL_SHADER_FILE "${CMAKE_CURRENT_SOURCE_DIR}/${SHADER_DIR}" "${SHADER_FILE}")
    
    # Set the output filename
    set(OUTPUT_FILE "${OUTPUT_DIR}/${SHADER_NAME}.glsl.gen.h")
    
    # Compile the shader
    compile_shader(${TARGET_NAME} "${SHADER_DIR}/${REL_SHADER_FILE}" "${OUTPUT_FILE}")
  endforeach()
endfunction()

# Function to set up shader compilation for Godot
function(setup_godot_shader_compilation)
  # Compile scene shaders
  compile_shader_directory(godot_scene "scene/shaders" "scene/generated")
  
  # Compile renderer shaders
  compile_shader_directory(godot_servers "servers/rendering/shaders" "servers/rendering/generated")
  
  # Additional shader directories can be added here
endfunction() 