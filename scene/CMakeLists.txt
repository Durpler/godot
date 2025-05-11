# Scene system components

# Include shader compilation module
include(${CMAKE_SOURCE_DIR}/cmake/modules/ShaderCompilation.cmake)

# Include the generated source list
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/GODOT_SCENE_sourcelist.cmake)

# Scene sources
set(SCENE_SOURCES
  2d/animated_sprite_2d.cpp
  2d/area_2d.cpp
  2d/camera_2d.cpp
  2d/canvas_item.cpp
  2d/canvas_modulate.cpp
  2d/collision_object_2d.cpp
  2d/collision_polygon_2d.cpp
  2d/collision_shape_2d.cpp
  2d/cpu_particles_2d.cpp
  2d/gpu_particles_2d.cpp
  2d/joints/joint_2d.cpp
  2d/light_2d.cpp
  2d/line_2d.cpp
  2d/mesh_instance_2d.cpp
  2d/navigation_agent_2d.cpp
  2d/navigation_region_2d.cpp
  2d/node_2d.cpp
  2d/parallax_background.cpp
  2d/parallax_layer.cpp
  2d/path_2d.cpp
  2d/physics_body_2d.cpp
  2d/polygon_2d.cpp
  2d/sprite_2d.cpp
  2d/tile_map.cpp
  2d/tile_map_layer.cpp
  2d/tile_set.cpp
  2d/touch_screen_button.cpp
  
  3d/area_3d.cpp
  3d/bone_attachment_3d.cpp
  3d/camera_3d.cpp
  3d/collision_object_3d.cpp
  3d/collision_polygon_3d.cpp
  3d/collision_shape_3d.cpp
  3d/cpu_particles_3d.cpp
  3d/gpu_particles_3d.cpp
  3d/joints/joint_3d.cpp
  3d/light_3d.cpp
  3d/mesh_instance_3d.cpp
  3d/navigation_agent_3d.cpp
  3d/navigation_region_3d.cpp
  3d/node_3d.cpp
  3d/path_3d.cpp
  3d/physics_body_3d.cpp
  3d/ray_cast_3d.cpp
  3d/skeleton_3d.cpp
  3d/sprite_3d.cpp
  3d/vehicle_body_3d.cpp
  3d/visible_instance_3d.cpp
  3d/world_environment.cpp
  
  animation/animation_blend_space_1d.cpp
  animation/animation_blend_space_2d.cpp
  animation/animation_blend_tree.cpp
  animation/animation_mixer.cpp
  animation/animation_node.cpp
  animation/animation_node_state_machine.cpp
  animation/animation_player.cpp
  animation/animation_tree.cpp
  animation/tween.cpp
  
  audio/audio_stream_player.cpp
  audio/audio_stream_player_2d.cpp
  audio/audio_stream_player_3d.cpp
  
  gui/control.cpp
  gui/label.cpp
  gui/line_edit.cpp
  gui/margin_container.cpp
  gui/menu_button.cpp
  gui/nine_patch_rect.cpp
  gui/panel.cpp
  gui/panel_container.cpp
  gui/popup.cpp
  gui/popup_menu.cpp
  gui/progress_bar.cpp
  gui/rich_text_label.cpp
  gui/scroll_container.cpp
  gui/slider.cpp
  gui/spin_box.cpp
  gui/split_container.cpp
  gui/tab_container.cpp
  gui/text_edit.cpp
  gui/texture_button.cpp
  gui/texture_rect.cpp
  gui/tree.cpp
  gui/viewport_container.cpp
  
  main/node.cpp
  main/resource.cpp
  main/scene_tree.cpp
  main/viewport.cpp
  main/window.cpp
  
  resources/font.cpp
  resources/material.cpp
  resources/mesh.cpp
  resources/packed_scene.cpp
  resources/shader.cpp
  resources/skeleton.cpp
  resources/texture.cpp
  resources/theme.cpp
)

# Shader files to compile
set(SHADER_FILES
  shaders/canvas.glsl
  shaders/canvas_shadow.glsl
  shaders/cubemap_filter.glsl
  shaders/particles.glsl
  shaders/spatial.glsl
  shaders/spatial_shadow.glsl
)

# Create the scene library
add_library(godot_scene STATIC ${GODOT_SCENE_SOURCES})

# Include directories
target_include_directories(godot_scene
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}
)

# Compile shaders
compile_shaders(godot_scene 
                "${CMAKE_CURRENT_SOURCE_DIR}/shaders" 
                "${CMAKE_CURRENT_BINARY_DIR}/shaders/generated"
                ${SHADER_FILES})

# Add binary dir to include path to find generated shader headers
target_include_directories(godot_scene
  PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}
)

# Link dependencies
target_link_libraries(godot_scene
  PUBLIC
    godot_core
    godot_servers
    godot_platform
    ${GODOT_THIRDPARTY_LIBS}
)

# Install headers
install(
  FILES ${GODOT_SCENE_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/godot/scene
) 