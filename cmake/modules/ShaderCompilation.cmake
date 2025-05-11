# Shader compilation module for Godot Engine
# Provides functions to compile GLSL shaders into C++ headers

# Find PowerShell for cross-platform shader builds
if(WIN32)
  find_program(POWERSHELL_EXECUTABLE NAMES pwsh powershell)
else()
  find_program(POWERSHELL_EXECUTABLE NAMES pwsh)
endif()

if(NOT POWERSHELL_EXECUTABLE)
  message(FATAL_ERROR "PowerShell (pwsh) not found. Please install PowerShell Core for shader compilation.")
endif()

# Get the path to the shader compilation script
set(SHADER_COMPILE_SCRIPT "${CMAKE_SOURCE_DIR}/tools/cmake/compile_shaders.ps1")

# Function to compile a shader to a C++ header
# Arguments:
#   TARGET_NAME - The name of the target to add the dependency to
#   SHADER_FILE - The input shader file
#   HEADER_FILE - The output header file
#   HEADER_VARIABLE - The variable name to use in the header file
function(compile_shader TARGET_NAME SHADER_FILE HEADER_FILE HEADER_VARIABLE)
  # Get the absolute paths
  get_filename_component(SHADER_FILE_ABS ${SHADER_FILE} ABSOLUTE)
  get_filename_component(HEADER_FILE_ABS ${HEADER_FILE} ABSOLUTE)
  
  # Create the directory for the output file if it doesn't exist
  get_filename_component(HEADER_DIR ${HEADER_FILE_ABS} DIRECTORY)
  file(MAKE_DIRECTORY ${HEADER_DIR})
  
  # Add the custom command to generate the header file
  add_custom_command(
    OUTPUT ${HEADER_FILE_ABS}
    COMMAND ${POWERSHELL_EXECUTABLE} -ExecutionPolicy Bypass -File ${SHADER_COMPILE_SCRIPT}
            -ShaderFile ${SHADER_FILE_ABS}
            -HeaderFile ${HEADER_FILE_ABS}
            -VariableName ${HEADER_VARIABLE}
    DEPENDS ${SHADER_FILE_ABS} ${SHADER_COMPILE_SCRIPT}
    COMMENT "Compiling shader ${SHADER_FILE} to ${HEADER_FILE}"
    VERBATIM
  )
  
  # Add the generated header to the source list of the specified target
  target_sources(${TARGET_NAME} PRIVATE ${HEADER_FILE_ABS})
endfunction()

# Function to compile multiple shaders at once
# Arguments:
#   TARGET_NAME - The name of the target to add the dependencies to
#   SHADER_DIR - The directory containing the shader files
#   OUTPUT_DIR - The directory to output the header files to
#   SHADER_FILES - List of shader files to compile (relative to SHADER_DIR)
function(compile_shaders TARGET_NAME SHADER_DIR OUTPUT_DIR)
  foreach(SHADER_FILE ${ARGN})
    # Get the filename without extension
    get_filename_component(SHADER_NAME ${SHADER_FILE} NAME_WE)
    
    # Set the output header file path
    set(HEADER_FILE "${OUTPUT_DIR}/${SHADER_NAME}.glsl.gen.h")
    
    # Set the variable name (convert to uppercase and replace dots with underscores)
    string(MAKE_C_IDENTIFIER "${SHADER_NAME}" HEADER_VARIABLE)
    string(TOUPPER "${HEADER_VARIABLE}_GLSL" HEADER_VARIABLE)
    
    # Compile the shader
    compile_shader(${TARGET_NAME} "${SHADER_DIR}/${SHADER_FILE}" "${HEADER_FILE}" "${HEADER_VARIABLE}")
  endforeach()
endfunction() 