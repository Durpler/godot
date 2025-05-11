cmake_minimum_required(VERSION 3.16)

project(Godot VERSION 4.4.0
  DESCRIPTION "Godot Game Engine"
  HOMEPAGE_URL "https://godotengine.org"
  LANGUAGES C CXX)

# Include all generated source lists
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/all_sourcelists.cmake)

# Options
option(TOOLS "Build editor tools" ON)
option(TESTS "Build tests" OFF)
option(VULKAN "Enable Vulkan support" ON)
option(GLES3 "Enable OpenGL ES 3.0 support" ON)
option(OPENGL3 "Enable OpenGL 3.3 support" ON)
option(USE_SYSTEM_LIBS "Use system libraries instead of bundled ones when possible" OFF)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Platform detection
if(WIN32)
  add_compile_definitions(WINDOWS_ENABLED)
elseif(APPLE)
  add_compile_definitions(UNIX_ENABLED APPLE_ENABLED)
elseif(UNIX)
  add_compile_definitions(UNIX_ENABLED)
endif()

# Set common compilation flags
if(MSVC)
  add_compile_options(/W3 /MP)
else()
  add_compile_options(-Wall -Wextra)
endif()

# Define TOOLS if requested
if(TOOLS)
  add_compile_definitions(TOOLS_ENABLED)
endif()

# Define DEBUG if build type is Debug
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
  add_compile_definitions(DEBUG_ENABLED)
endif()

# Add subdirectories for components
add_subdirectory(thirdparty)
add_subdirectory(core)
add_subdirectory(drivers)
add_subdirectory(platform)
add_subdirectory(scene)
add_subdirectory(servers)

if(TOOLS)
  add_subdirectory(editor)
endif()

add_subdirectory(main)

# Main executable
add_executable(godot ${GODOT_MAIN_SOURCES})

# Link all components
target_link_libraries(godot
  PRIVATE
    godot_core
    godot_drivers
    godot_platform
    godot_scene
    godot_servers
)

if(TOOLS)
  target_link_libraries(godot PRIVATE godot_editor)
endif()

# Installation
include(GNUInstallDirs)

install(TARGETS godot
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  BUNDLE DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Print configuration summary
message(STATUS "Godot configuration:")
message(STATUS "  Version:        ${PROJECT_VERSION}")
message(STATUS "  Build type:     ${CMAKE_BUILD_TYPE}")
message(STATUS "  Tools:          ${TOOLS}")
message(STATUS "  Tests:          ${TESTS}")
message(STATUS "  Vulkan:         ${VULKAN}")
message(STATUS "  GLES3:          ${GLES3}")
message(STATUS "  OpenGL3:        ${OPENGL3}")
message(STATUS "  System libs:    ${USE_SYSTEM_LIBS}")
message(STATUS "  C++ Compiler:   ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "  C++ Standard:   ${CMAKE_CXX_STANDARD}")
message(STATUS "  Install prefix: ${CMAKE_INSTALL_PREFIX}") 