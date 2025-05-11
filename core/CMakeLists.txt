# Include the generated source list
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/GODOT_CORE_sourcelist.cmake)

# Create library
add_library(godot_core STATIC ${GODOT_CORE_SOURCES})

# Include directories
target_include_directories(godot_core
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}
)

# Dependencies
target_link_libraries(godot_core
  PUBLIC
    godot_thirdparty_mbedtls
)

# Compile definitions
target_compile_definitions(godot_core
  PRIVATE
    $<$<PLATFORM_ID:Windows>:WINDOWS_ENABLED>
    $<$<PLATFORM_ID:Linux>:UNIX_ENABLED>
    $<$<PLATFORM_ID:Darwin>:UNIX_ENABLED APPLE_ENABLED>
)

# Install headers
install(
  FILES ${GODOT_CORE_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/godot/core
) 