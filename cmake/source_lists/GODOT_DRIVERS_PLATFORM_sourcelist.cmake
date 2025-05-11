
# Windows drivers
set(GODOT_DRIVERS_WINDOWS_SOURCES
  d3d12/d3d12_hooks.cpp
  d3d12/d3d12ma.cpp
  d3d12/dxil_hash.cpp
  d3d12/rendering_context_driver_d3d12.cpp
  d3d12/rendering_device_driver_d3d12.cpp
  wasapi/audio_driver_wasapi.cpp
  windows/dir_access_windows.cpp
  windows/file_access_windows_pipe.cpp
  windows/file_access_windows.cpp
  windows/ip_windows.cpp
  windows/net_socket_winsock.cpp
  windows/thread_windows.cpp
  winmidi/midi_driver_winmidi.cpp
  xaudio2/audio_driver_xaudio2.cpp
)

# macOS drivers
set(GODOT_DRIVERS_MACOS_SOURCES
  apple/joypad_apple.mm
  apple/thread_apple.cpp
  coreaudio/audio_driver_coreaudio.mm
  coremidi/midi_driver_coremidi.mm
  metal/metal_device_properties.mm
  metal/metal_objects.mm
  metal/pixel_formats.mm
  metal/rendering_context_driver_metal.mm
  metal/rendering_device_driver_metal.mm
)

# iOS drivers
set(GODOT_DRIVERS_IOS_SOURCES
  apple/joypad_apple.mm
  apple/thread_apple.cpp
  coreaudio/audio_driver_coreaudio.mm
  coremidi/midi_driver_coremidi.mm
  metal/metal_device_properties.mm
  metal/metal_objects.mm
  metal/pixel_formats.mm
  metal/rendering_context_driver_metal.mm
  metal/rendering_device_driver_metal.mm
)

# Linux/Unix drivers
set(GODOT_DRIVERS_UNIX_SOURCES
  alsa/asound-so_wrap.c
  alsa/audio_driver_alsa.cpp
  alsamidi/midi_driver_alsamidi.cpp
  pulseaudio/audio_driver_pulseaudio.cpp
  pulseaudio/pulse-so_wrap.c
  unix/dir_access_unix.cpp
  unix/file_access_unix_pipe.cpp
  unix/file_access_unix.cpp
  unix/ip_unix.cpp
  unix/net_socket_unix.cpp
  unix/os_unix.cpp
  unix/syslog_logger.cpp
  unix/thread_posix.cpp
)

# Common drivers for all platforms drivers
set(GODOT_DRIVERS_COMMON_SOURCES
  gles3/effects/copy_effects.cpp
  gles3/effects/cubemap_filter.cpp
  gles3/effects/feed_effects.cpp
  gles3/effects/glow.cpp
  gles3/effects/post_effects.cpp
  gles3/environment/fog.cpp
  gles3/environment/gi.cpp
  gles3/rasterizer_canvas_gles3.cpp
  gles3/rasterizer_gles3.cpp
  gles3/rasterizer_scene_gles3.cpp
  gles3/shader_gles3.cpp
  gles3/storage/config.cpp
  gles3/storage/light_storage.cpp
  gles3/storage/material_storage.cpp
  gles3/storage/mesh_storage.cpp
  gles3/storage/particles_storage.cpp
  gles3/storage/render_scene_buffers_gles3.cpp
  gles3/storage/texture_storage.cpp
  gles3/storage/utilities.cpp
  png/image_loader_png.cpp
  png/png_driver_common.cpp
  png/resource_saver_png.cpp
)

# Vulkan drivers (cross-platform) drivers
set(GODOT_DRIVERS_VULKAN_SOURCES
  vulkan/rendering_context_driver_vulkan.cpp
  vulkan/rendering_device_driver_vulkan.cpp
  vulkan/vulkan_hooks.cpp
)

# Add platform flags to help with CMake conditionals
set(GODOT_DRIVERS_PLATFORM_FLAGS)

# Auto-detect which platform-specific sources to use by default
if(WIN32)
  list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES ${GODOT_DRIVERS_WINDOWS_SOURCES})
  list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS WINDOWS_ENABLED)
elseif(APPLE)
  if(IOS)
    list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES ${GODOT_DRIVERS_IOS_SOURCES})
    list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS APPLE_ENABLED IOS_ENABLED)
  else()
    list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES ${GODOT_DRIVERS_MACOS_SOURCES})
    list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS APPLE_ENABLED MACOS_ENABLED)
  endif()
elseif(UNIX)
  list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES ${GODOT_DRIVERS_UNIX_SOURCES})
  list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS UNIX_ENABLED)
endif()

# Always include common sources
list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES ${GODOT_DRIVERS_COMMON_SOURCES})

# Include Vulkan if enabled
if(VULKAN)
  list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES ${GODOT_DRIVERS_VULKAN_SOURCES})
  list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS VULKAN_ENABLED)
endif()

# Include GLES3 flag if enabled
if(GLES3)
  list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS GLES3_ENABLED)
endif()

# Set the final list that can be used in CMakeLists.txt
set(GODOT_DRIVERS_ACTIVE_SOURCES ${GODOT_DRIVERS_PLATFORM_SOURCES})
