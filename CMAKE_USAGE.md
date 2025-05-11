# Godot Engine CMake Build System

This document provides instructions for building Godot Engine using the new CMake build system.

## Prerequisites

- CMake 3.16 or newer
- A C++17 compliant compiler (GCC 9+, Clang 10+, MSVC 2019+)
- Development packages for required libraries (X11, OpenGL, etc.)

## Quick Start

### Building on Linux

```bash
# Create a build directory
mkdir -p build
cd build

# Configure the build
cmake ..

# Build the engine
cmake --build . -j$(nproc)

# Run the editor
./bin/godot
```

### Building on Windows with Visual Studio

```cmd
# Create a build directory
mkdir build
cd build

# Configure the build for Visual Studio
cmake .. -G "Visual Studio 16 2019" -A x64

# Build with Visual Studio
cmake --build . --config Release

# Run the editor
.\bin\Release\godot.exe
```

### Building on macOS

```bash
# Create a build directory
mkdir -p build
cd build

# Configure the build
cmake ..

# Build the engine
cmake --build . -j$(sysctl -n hw.logicalcpu)

# Run the editor
./bin/godot
```

## Build Options

The following CMake options can be used to customize the build:

| Option | Description | Default |
|--------|-------------|---------|
| `TOOLS` | Build editor tools | ON |
| `TESTS` | Build unit tests | OFF |
| `VULKAN` | Build with Vulkan support | ON |
| `OPENGL3` | Build with OpenGL 3 support | ON |
| `GLES3` | Build with GLES3 support | ON |
| `D3D12` | Build with DirectX 12 support | OFF |
| `MINGW_STATIC` | Link MinGW libraries statically | OFF |
| `PULSEAUDIO` | Build with PulseAudio support | ON |
| `USE_CLANG` | Use Clang compiler instead of GCC | OFF |
| `USE_SYSTEM_LIBS` | Use system libraries when available | OFF |

Options can be set via the command line with `-D`:

```bash
cmake .. -DTOOLS=OFF -DTESTS=ON
```

## Modules

Modules can be enabled or disabled using the following options:

| Option | Description | Default |
|--------|-------------|---------|
| `MODULE_MONO_ENABLED` | Enable Mono/.NET support | OFF |
| `MODULE_GDSCRIPT_ENABLED` | Enable GDScript | ON |
| `MODULE_MBEDTLS_ENABLED` | Enable mbedTLS | ON |
| `MODULE_FREETYPE_ENABLED` | Enable FreeType | ON |

Additional modules are automatically detected and enabled if present.

## Advanced Configuration

### Custom Compiler Flags

You can add custom compiler flags using the `CMAKE_CXX_FLAGS` variable:

```bash
cmake .. -DCMAKE_CXX_FLAGS="-Wall -Wextra -pedantic"
```

### Cross-Compiling

For cross-compiling, you'll need to provide a toolchain file:

```bash
cmake .. -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchains/android.toolchain.cmake
```

## Troubleshooting

### Missing Dependencies

If CMake fails to find a dependency, you can specify its location manually:

```bash
cmake .. -DVULKAN_SDK_PATH=/path/to/vulkan/sdk
```

### Build Errors

1. Make sure you have all the required development packages installed
2. Check that your compiler supports C++17
3. Try clearing the CMake cache and reconfiguring:

```bash
rm -rf build/*
cd build
cmake ..
```

## Comparing with SCons

The CMake build system aims to provide feature parity with the SCons build system. Here's a comparison of common tasks:

| Task | SCons | CMake |
|------|-------|-------|
| Debug build | `scons target=debug` | `cmake -DCMAKE_BUILD_TYPE=Debug ..` |
| Release build | `scons target=release` | `cmake -DCMAKE_BUILD_TYPE=Release ..` |
| Disable editor | `scons tools=no` | `cmake -DTOOLS=OFF ..` |
| Custom modules | `scons custom_modules=path/to/modules` | `cmake -DCUSTOM_MODULES_PATH=path/to/modules ..` |
| Android build | `scons platform=android` | `cmake -DTARGET_PLATFORM=android ..` |

## Contributing

If you encounter issues or have suggestions for improving the CMake build system, please file an issue or submit a pull request to the Godot repository. 