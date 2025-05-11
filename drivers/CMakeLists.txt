# Drivers components

# Include the auto-generated complete source list (for headers and reference)
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/GODOT_DRIVERS_sourcelist.cmake)

# Include the platform-specific driver source list
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/GODOT_DRIVERS_PLATFORM_sourcelist.cmake)

# OpenGL ES 3 support
if(GLES3)
  list(APPEND DRIVERS_DEFINITIONS GLES3_ENABLED)
endif()

# Vulkan support
if(VULKAN)
  find_package(Vulkan)
  if(Vulkan_FOUND)
    list(APPEND DRIVERS_LIBS ${Vulkan_LIBRARIES})
    list(APPEND DRIVERS_INCLUDE_DIRS ${Vulkan_INCLUDE_DIRS})
    list(APPEND DRIVERS_DEFINITIONS VULKAN_ENABLED)
  endif()
endif()

# OpenGL 3 support
if(OPENGL3)
  find_package(OpenGL)
  if(OpenGL_FOUND)
    list(APPEND DRIVERS_LIBS ${OpenGL_LIBRARIES})
    list(APPEND DRIVERS_INCLUDE_DIRS ${OpenGL_INCLUDE_DIRS})
    list(APPEND DRIVERS_DEFINITIONS OPENGL3_ENABLED)
  endif()
endif()

# Platform-specific libraries and definitions
if(WIN32)
  # Windows-specific libraries
  list(APPEND DRIVERS_LIBS winmm dsound)
  
  # D3D12 support
  if(D3D12)
    find_package(D3D12 REQUIRED)
    list(APPEND DRIVERS_LIBS d3d12 dxgi dxguid)
    list(APPEND DRIVERS_DEFINITIONS D3D12_ENABLED)
  endif()
elseif(APPLE)
  # Apple-specific frameworks
  find_library(AUDIOUNIT_FRAMEWORK AudioUnit)
  find_library(COREAUDIO_FRAMEWORK CoreAudio)
  find_library(COREFOUNDATION_FRAMEWORK CoreFoundation)
  find_library(METAL_FRAMEWORK Metal)
  list(APPEND DRIVERS_LIBS ${AUDIOUNIT_FRAMEWORK} ${COREAUDIO_FRAMEWORK} ${COREFOUNDATION_FRAMEWORK} ${METAL_FRAMEWORK})
elseif(UNIX)
  # Unix/Linux-specific libraries
  
  # ALSA support
  find_package(ALSA)
  if(ALSA_FOUND)
    list(APPEND DRIVERS_LIBS ${ALSA_LIBRARIES})
    list(APPEND DRIVERS_DEFINITIONS ALSA_ENABLED)
  endif()
  
  # PulseAudio support
  if(PULSEAUDIO)
    find_package(PulseAudio)
    if(PULSEAUDIO_FOUND)
      list(APPEND DRIVERS_LIBS ${PULSEAUDIO_LIBRARIES})
      list(APPEND DRIVERS_DEFINITIONS PULSEAUDIO_ENABLED)
    endif()
  endif()
endif()

# Add the platform flags to our definitions
list(APPEND DRIVERS_DEFINITIONS ${GODOT_DRIVERS_PLATFORM_FLAGS})

# Create drivers library
# Use the platform-specific sources list instead of the complete list
add_library(godot_drivers STATIC ${GODOT_DRIVERS_ACTIVE_SOURCES})

# Include directories
target_include_directories(godot_drivers
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}
    ${DRIVERS_INCLUDE_DIRS}
)

# Compile definitions
target_compile_definitions(godot_drivers
  PUBLIC
    ${DRIVERS_DEFINITIONS}
)

# Link libraries
target_link_libraries(godot_drivers
  PUBLIC
    godot_core
    godot_platform
    ${DRIVERS_LIBS}
    ${GODOT_THIRDPARTY_LIBS}
)

# Install headers
install(
  FILES ${GODOT_DRIVERS_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/godot/drivers
) 