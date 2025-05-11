# Platform-specific build configuration

# Common sources for all platforms
set(PLATFORM_COMMON_SOURCES
  common/thread_posix.cpp
  common/mutex_posix.cpp
  common/semaphore_posix.cpp
  common/rw_lock_posix.cpp
)

# Platform detection and configuration
if(WIN32)
  set(PLATFORM_SOURCES
    ${PLATFORM_COMMON_SOURCES}
    windows/crash_handler_windows.cpp
    windows/godot_windows.cpp
    windows/joypad_windows.cpp
    windows/key_mapping_windows.cpp
    windows/os_windows.cpp
    windows/windows_terminal_logger.cpp
  )
  
  set(PLATFORM_DEFINITIONS
    WINDOWS_ENABLED
  )
  
  # DirectX dependencies
  if(D3D12)
    find_package(D3D12 REQUIRED)
    list(APPEND PLATFORM_LIBS d3d12 dxgi dxguid)
    list(APPEND PLATFORM_DEFINITIONS D3D12_ENABLED)
  endif()
  
  # Windows-specific libraries
  list(APPEND PLATFORM_LIBS
    winmm
    ws2_32
    dbghelp
    shlwapi
    version
  )
  
elseif(APPLE)
  # macOS/iOS platform
  if(IOS)
    set(PLATFORM_SOURCES
      ${PLATFORM_COMMON_SOURCES}
      ios/app_delegate_ios.mm
      ios/godot_ios.cpp
      ios/view_controller_ios.mm
      ios/os_ios.mm
      ios/gl_view_ios.mm
    )
    
    set(PLATFORM_DEFINITIONS
      UNIX_ENABLED
      APPLE_ENABLED
      IOS_ENABLED
    )
    
    # iOS frameworks
    find_library(UIKIT UIKit)
    find_library(FOUNDATION Foundation)
    find_library(GAMECONTROLLER GameController)
    find_library(COREGRAPHICS CoreGraphics)
    find_library(COREMEDIA CoreMedia)
    find_library(COREAUDIO CoreAudio)
    find_library(AVFOUNDATION AVFoundation)
    find_library(COREVIDEO CoreVideo)
    
    list(APPEND PLATFORM_LIBS
      ${UIKIT}
      ${FOUNDATION}
      ${GAMECONTROLLER}
      ${COREGRAPHICS}
      ${COREMEDIA}
      ${COREAUDIO}
      ${AVFOUNDATION}
      ${COREVIDEO}
    )
  else()
    # macOS
    set(PLATFORM_SOURCES
      ${PLATFORM_COMMON_SOURCES}
      macos/crash_handler_macos.mm
      macos/godot_macos.mm
      macos/joypad_macos.cpp
      macos/key_mapping_macos.mm
      macos/os_macos.mm
    )
    
    set(PLATFORM_DEFINITIONS
      UNIX_ENABLED
      APPLE_ENABLED
      MACOS_ENABLED
    )
    
    # macOS frameworks
    find_library(COCOA Cocoa)
    find_library(CARBON Carbon)
    find_library(IOKIT IOKit)
    find_library(FORCEFEEDBACK ForceFeedback)
    find_library(APPKIT AppKit)
    find_library(COREVIDEO CoreVideo)
    find_library(COREAUDIO CoreAudio)
    
    list(APPEND PLATFORM_LIBS
      ${COCOA}
      ${CARBON}
      ${IOKIT}
      ${FORCEFEEDBACK}
      ${APPKIT}
      ${COREVIDEO}
      ${COREAUDIO}
    )
  endif()
  
elseif(UNIX)
  # Linux and other Unix platforms
  set(PLATFORM_SOURCES
    ${PLATFORM_COMMON_SOURCES}
    linuxbsd/crash_handler_linuxbsd.cpp
    linuxbsd/joypad_linux.cpp
    linuxbsd/key_mapping_x11.cpp
    linuxbsd/os_linuxbsd.cpp
    linuxbsd/x11_window.cpp
  )
  
  set(PLATFORM_DEFINITIONS
    UNIX_ENABLED
    X11_ENABLED
  )
  
  # X11 dependencies
  find_package(X11 REQUIRED)
  list(APPEND PLATFORM_LIBS
    ${X11_LIBRARIES}
    ${X11_Xrandr_LIB}
    ${X11_Xcursor_LIB}
    ${X11_Xi_LIB}
  )
  
  # PulseAudio support
  if(PULSEAUDIO)
    find_package(PulseAudio)
    if(PULSEAUDIO_FOUND)
      list(APPEND PLATFORM_LIBS ${PULSEAUDIO_LIBRARY})
      list(APPEND PLATFORM_DEFINITIONS PULSEAUDIO_ENABLED)
    endif()
  endif()
  
  # ALSA
  find_package(ALSA)
  if(ALSA_FOUND)
    list(APPEND PLATFORM_LIBS ${ALSA_LIBRARIES})
    list(APPEND PLATFORM_DEFINITIONS ALSA_ENABLED)
  endif()
  
  # UDev for joypads
  find_package(UDev)
  if(UDEV_FOUND)
    list(APPEND PLATFORM_LIBS ${UDEV_LIBRARIES})
    list(APPEND PLATFORM_DEFINITIONS UDEV_ENABLED)
  endif()
  
  # Additional Unix libraries
  list(APPEND PLATFORM_LIBS
    dl
    pthread
    rt
  )
endif()

# Include the generated source list
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/GODOT_PLATFORM_sourcelist.cmake)

# Create library
add_library(godot_platform STATIC ${GODOT_PLATFORM_SOURCES})

# Platform-specific definitions
if(WIN32)
  list(APPEND PLATFORM_DEFINITIONS WINDOWS_ENABLED)
elseif(APPLE)
  list(APPEND PLATFORM_DEFINITIONS UNIX_ENABLED APPLE_ENABLED)
elseif(UNIX)
  list(APPEND PLATFORM_DEFINITIONS UNIX_ENABLED)
endif()

# Include directories
target_include_directories(godot_platform
  PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}
)

# Add definitions
target_compile_definitions(godot_platform
  PUBLIC
    ${PLATFORM_DEFINITIONS}
)

# Link dependencies
target_link_libraries(godot_platform
  PUBLIC
    godot_core
)

# Install headers
install(
  FILES ${GODOT_PLATFORM_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/godot/platform
)

# Platform-specific compile options
if(WIN32 AND MSVC)
  target_compile_options(godot_platform
    PRIVATE
      /wd4244
      /wd4305
  )
endif() 