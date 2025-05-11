# Godot Editor components
# Only built when TOOLS=ON

# Find PowerShell for resource embedding
if(WIN32)
  find_program(POWERSHELL_EXECUTABLE NAMES pwsh powershell)
else()
  find_program(POWERSHELL_EXECUTABLE NAMES pwsh)
endif()

if(NOT POWERSHELL_EXECUTABLE)
  message(FATAL_ERROR "PowerShell (pwsh) not found. Please install PowerShell Core for resource embedding.")
endif()

# Include the generated source list
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/GODOT_EDITOR_sourcelist.cmake)

# Create library
add_library(godot_editor STATIC ${GODOT_EDITOR_SOURCES})

# Include directories
target_include_directories(godot_editor
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}
)

# Link dependencies
target_link_libraries(godot_editor
  PUBLIC
    godot_core
    godot_scene
    godot_servers
    godot_platform
    godot_drivers
)

# Install headers
install(
  FILES ${GODOT_EDITOR_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/godot/editor
)

# Editor sources
set(EDITOR_SOURCES
  editor_atlas_packer.cpp
  editor_dock.cpp
  editor_export.cpp
  editor_file_server.cpp
  editor_file_system.cpp
  editor_inspector.cpp
  editor_interface.cpp
  editor_log.cpp
  editor_node.cpp
  editor_paths.cpp
  editor_plugin.cpp
  editor_properties.cpp
  editor_resource_picker.cpp
  editor_resource_preview.cpp
  editor_run.cpp
  editor_scale.cpp
  editor_settings.cpp
  editor_spin_slider.cpp
  editor_themes.cpp
  editor_translation_parser.cpp
  editor_undo_redo_manager.cpp
  editor_zoom_widget.cpp
  
  debugger/editor_debugger_node.cpp
  debugger/editor_debugger_server.cpp
  debugger/editor_visual_profiler.cpp
  
  export/editor_export_platform.cpp
  export/editor_export_platform_pc.cpp
  export/editor_export_platform_web.cpp
  
  filesystem_dock.cpp
  plugins/animation_player_editor_plugin.cpp
  plugins/canvas_item_editor_plugin.cpp
  plugins/editor_preview_plugins.cpp
  plugins/editor_resource_conversion_plugin.cpp
  plugins/gradient_editor_plugin.cpp
  plugins/input_event_editor_plugin.cpp
  plugins/material_editor_plugin.cpp
  plugins/mesh_editor_plugin.cpp
  plugins/mesh_instance_3d_editor_plugin.cpp
  plugins/node_3d_editor_plugin.cpp
  plugins/script_editor_plugin.cpp
  plugins/shader_editor_plugin.cpp
  plugins/shader_file_editor_plugin.cpp
  plugins/spatial_editor_plugin.cpp
  plugins/texture_editor_plugin.cpp
  plugins/texture_region_editor_plugin.cpp
  
  project_manager.cpp
  scene_tree_dock.cpp
  
  gui/editor_file_dialog.cpp
  gui/editor_menu_bar.cpp
  gui/editor_node_dock.cpp
  gui/editor_run_bar.cpp
  gui/project_settings_editor.cpp
)

# Create a list of resources to be embedded
set(EDITOR_RESOURCES
  fonts/doc_font.ttf
  fonts/editor_font.ttf
  icons/editor_icons.svg
  translations/editor_translations.pot
)

# Generate code to embed resources
set(EMBED_RESOURCES_SCRIPT "${CMAKE_SOURCE_DIR}/tools/cmake/embed_resources.ps1")
set(EMBEDDED_RESOURCES_CPP "${CMAKE_CURRENT_BINARY_DIR}/editor_embedded_resources.cpp")
set(EMBEDDED_RESOURCES_H "${CMAKE_CURRENT_BINARY_DIR}/editor_embedded_resources.h")

add_custom_command(
  OUTPUT ${EMBEDDED_RESOURCES_CPP} ${EMBEDDED_RESOURCES_H}
  COMMAND ${POWERSHELL_EXECUTABLE} -ExecutionPolicy Bypass -File ${EMBED_RESOURCES_SCRIPT}
          -ResourcesDir "${CMAKE_CURRENT_SOURCE_DIR}"
          -OutputCpp "${EMBEDDED_RESOURCES_CPP}"
          -OutputH "${EMBEDDED_RESOURCES_H}"
          -ResourcesList ${EDITOR_RESOURCES}
  DEPENDS ${EDITOR_RESOURCES} ${EMBED_RESOURCES_SCRIPT}
  COMMENT "Generating embedded resources for editor"
  VERBATIM
)

# Add the embedded resources to the sources
list(APPEND EDITOR_SOURCES ${EMBEDDED_RESOURCES_CPP} ${EMBEDDED_RESOURCES_H})

# Create the editor library
#add_library(godot_editor STATIC ${EDITOR_SOURCES})

# Include directories
target_include_directories(godot_editor
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}  # For embedded resources header
)

# Link dependencies
target_link_libraries(godot_editor
  PUBLIC
    godot_core
    godot_scene
    godot_servers
    ${GODOT_THIRDPARTY_LIBS}
) 