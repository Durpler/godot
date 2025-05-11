# Godot servers components

# Include the generated source list
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/GODOT_SERVERS_sourcelist.cmake)

# Create library
add_library(godot_servers STATIC ${GODOT_SERVERS_SOURCES})

# Include directories
target_include_directories(godot_servers
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}
)

# Link dependencies
target_link_libraries(godot_servers
  PUBLIC
    godot_core
    godot_platform
    godot_drivers
)

# Install headers
install(
  FILES ${GODOT_SERVERS_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/godot/servers
) 