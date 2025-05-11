# Android CMake toolchain file for Godot Engine
# Based on the Android NDK toolchain file

# Basic configuration
set(CMAKE_SYSTEM_NAME Android)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR ${ANDROID_ABI})

# Default Android ABI if not specified
if(NOT DEFINED ANDROID_ABI)
    set(ANDROID_ABI "arm64-v8a" CACHE STRING "Android ABI")
endif()

# Default Android platform if not specified
if(NOT DEFINED ANDROID_PLATFORM)
    set(ANDROID_PLATFORM "android-21" CACHE STRING "Android platform version")
endif()

# Require NDK to be set by user
if(NOT DEFINED ANDROID_NDK)
    message(FATAL_ERROR "ANDROID_NDK must be specified. Please set it to the path of your Android NDK installation.")
endif()

# Check NDK exists
if(NOT EXISTS "${ANDROID_NDK}")
    message(FATAL_ERROR "ANDROID_NDK path does not exist: ${ANDROID_NDK}")
endif()

# Check minimum supported platform
string(REPLACE "android-" "" ANDROID_PLATFORM_LEVEL ${ANDROID_PLATFORM})
if(ANDROID_PLATFORM_LEVEL LESS 21)
    message(FATAL_ERROR "Minimum supported Android platform is android-21 (Android 5.0)")
endif()

# Set up the Android-specific variables
set(ANDROID_TOOLCHAIN clang)
set(ANDROID_STL c++_shared)

# Set up the Android NDK toolchain
include("${ANDROID_NDK}/build/cmake/android.toolchain.cmake")

# Add Godot-specific Android flags and definitions
add_definitions(-DANDROID_ENABLED -DMOBILE_ENABLED -DUNIX_ENABLED)

# Set output directories for Android
set(LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/android/libs/${ANDROID_ABI})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${LIBRARY_OUTPUT_DIRECTORY})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${LIBRARY_OUTPUT_DIRECTORY})

message(STATUS "Configured for Android build:")
message(STATUS "  - ABI: ${ANDROID_ABI}")
message(STATUS "  - Platform: ${ANDROID_PLATFORM}")
message(STATUS "  - NDK: ${ANDROID_NDK}")
message(STATUS "  - Toolchain: ${ANDROID_TOOLCHAIN}")
message(STATUS "  - STL: ${ANDROID_STL}")
message(STATUS "  - Output: ${LIBRARY_OUTPUT_DIRECTORY}") 