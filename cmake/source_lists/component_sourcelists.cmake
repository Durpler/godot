# Include all generated source lists for component-level use
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/component/GODOT_CORE_sourcelist.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/component/GODOT_DRIVERS_sourcelist.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/component/GODOT_PLATFORM_sourcelist.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/component/GODOT_SCENE_sourcelist.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/component/GODOT_SERVERS_sourcelist.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/component/GODOT_EDITOR_sourcelist.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/component/GODOT_MAIN_sourcelist.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/component/GODOT_THIRDPARTY_MBEDTLS_sourcelist.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/component/GODOT_THIRDPARTY_FREETYPE_sourcelist.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/component/GODOT_THIRDPARTY_ZLIB_sourcelist.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/component/GODOT_DRIVERS_PLATFORM_sourcelist.cmake)

# Usage: Include this file in component CMakeLists.txt to get component-relative paths
# Example: include(${CMAKE_SOURCE_DIR}/cmake/source_lists/component_sourcelists.cmake)
