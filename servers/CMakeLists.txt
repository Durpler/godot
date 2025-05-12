# Godot servers components

# Include the generated source list
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/GODOT_SERVERS_sourcelist.cmake)

# Include shader compilation module
include(${CMAKE_SOURCE_DIR}/cmake/ShaderCompilation.cmake)

# Create library
add_library(godot_servers STATIC ${GODOT_SERVERS_SOURCES})

# Include directories
target_include_directories(godot_servers
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}  # For generated files
)

# Link dependencies
target_link_libraries(godot_servers
  PUBLIC
    godot_core
    godot_platform
    godot_drivers
)

# Compile rendering shaders
compile_shader_directory(godot_servers "rendering/shaders" "servers/rendering/generated")

# Compile additional shader directories as needed
# Example:
# compile_shader_directory(godot_servers "other_shaders" "servers/other/generated")

# Install headers
install(
  FILES ${GODOT_SERVERS_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/godot/servers
) 