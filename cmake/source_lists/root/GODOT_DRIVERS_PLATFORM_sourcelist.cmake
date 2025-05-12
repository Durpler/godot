# Platform-dependent driver source lists for Godot (root-relative paths)
# This file organizes driver source files by platform

# Windows drivers
set(GODOT_DRIVERS_WINDOWS_SOURCES
  drivers/d3d12/d3d12_hooks.cpp
  drivers/d3d12/d3d12ma.cpp
  drivers/d3d12/dxil_hash.cpp
  drivers/d3d12/rendering_context_driver_d3d12.cpp
  drivers/d3d12/rendering_device_driver_d3d12.cpp
  drivers/wasapi/audio_driver_wasapi.cpp
  drivers/windows/dir_access_windows.cpp
  drivers/windows/file_access_windows_pipe.cpp
  drivers/windows/file_access_windows.cpp
  drivers/windows/ip_windows.cpp
  drivers/windows/net_socket_winsock.cpp
  drivers/windows/thread_windows.cpp
  drivers/winmidi/midi_driver_winmidi.cpp
  drivers/xaudio2/audio_driver_xaudio2.cpp
)

# macOS drivers
set(GODOT_DRIVERS_MACOS_SOURCES
  drivers/apple/joypad_apple.mm
  drivers/apple/thread_apple.cpp
  drivers/coreaudio/audio_driver_coreaudio.mm
  drivers/coremidi/midi_driver_coremidi.mm
  drivers/metal/metal_device_properties.mm
  drivers/metal/metal_objects.mm
  drivers/metal/pixel_formats.mm
  drivers/metal/rendering_context_driver_metal.mm
  drivers/metal/rendering_device_driver_metal.mm
)

# iOS drivers
set(GODOT_DRIVERS_IOS_SOURCES
  drivers/apple/joypad_apple.mm
  drivers/apple/thread_apple.cpp
  drivers/coreaudio/audio_driver_coreaudio.mm
  drivers/coremidi/midi_driver_coremidi.mm
  drivers/metal/metal_device_properties.mm
  drivers/metal/metal_objects.mm
  drivers/metal/pixel_formats.mm
  drivers/metal/rendering_context_driver_metal.mm
  drivers/metal/rendering_device_driver_metal.mm
)

# Linux/Unix drivers
set(GODOT_DRIVERS_UNIX_SOURCES
  drivers/alsa/asound-so_wrap.c
  drivers/alsa/audio_driver_alsa.cpp
  drivers/alsamidi/midi_driver_alsamidi.cpp
  drivers/pulseaudio/audio_driver_pulseaudio.cpp
  drivers/pulseaudio/pulse-so_wrap.c
  drivers/unix/dir_access_unix.cpp
  drivers/unix/file_access_unix_pipe.cpp
  drivers/unix/file_access_unix.cpp
  drivers/unix/ip_unix.cpp
  drivers/unix/net_socket_unix.cpp
  drivers/unix/os_unix.cpp
  drivers/unix/syslog_logger.cpp
  drivers/unix/thread_posix.cpp
)

# Common drivers for all platforms drivers
set(GODOT_DRIVERS_COMMON_SOURCES
  drivers/gles3/effects/copy_effects.cpp
  drivers/gles3/effects/cubemap_filter.cpp
  drivers/gles3/effects/feed_effects.cpp
  drivers/gles3/effects/glow.cpp
  drivers/gles3/effects/post_effects.cpp
  drivers/gles3/environment/fog.cpp
  drivers/gles3/environment/gi.cpp
  drivers/gles3/rasterizer_canvas_gles3.cpp
  drivers/gles3/rasterizer_gles3.cpp
  drivers/gles3/rasterizer_scene_gles3.cpp
  drivers/gles3/shader_gles3.cpp
  drivers/gles3/storage/config.cpp
  drivers/gles3/storage/light_storage.cpp
  drivers/gles3/storage/material_storage.cpp
  drivers/gles3/storage/mesh_storage.cpp
  drivers/gles3/storage/particles_storage.cpp
  drivers/gles3/storage/render_scene_buffers_gles3.cpp
  drivers/gles3/storage/texture_storage.cpp
  drivers/gles3/storage/utilities.cpp
  drivers/png/image_loader_png.cpp
  drivers/png/png_driver_common.cpp
  drivers/png/resource_saver_png.cpp
)

# Vulkan drivers (cross-platform) drivers
set(GODOT_DRIVERS_VULKAN_SOURCES
  drivers/vulkan/rendering_context_driver_vulkan.cpp
  drivers/vulkan/rendering_device_driver_vulkan.cpp
  drivers/vulkan/vulkan_hooks.cpp
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
