# Godot CMake Build System

This directory contains CMake configuration files for building Godot using CMake instead of SCons.

## Modular Source Lists

Godot has a large codebase with thousands of source files. To make it easier to maintain the CMake build system, we use a modular approach with separate source list files for each component.

### Source List Structure

Source lists are stored in the `cmake/source_lists/` directory with the following naming convention:

- `GODOT_CORE_sourcelist.cmake` - Core functionality
- `GODOT_DRIVERS_sourcelist.cmake` - Platform-specific and hardware drivers
- `GODOT_PLATFORM_sourcelist.cmake` - Platform abstraction
- `GODOT_SCENE_sourcelist.cmake` - Scene system
- `GODOT_SERVERS_sourcelist.cmake` - Server abstractions
- `GODOT_EDITOR_sourcelist.cmake` - Editor functionality
- `GODOT_MAIN_sourcelist.cmake` - Main executable functionality
- `GODOT_THIRDPARTY_*_sourcelist.cmake` - Third-party libraries

Each source list file defines three variables:
- `GODOT_*_SOURCES` - Contains source files (.cpp, .c, .mm, .m)
- `GODOT_*_HEADERS` - Contains header files (.h, .hpp)
- `GODOT_*_FILES` - Contains both source and header files

### Generating Source Lists

Use the provided PowerShell script to automatically generate source lists:

```
# Navigate to the root of the Godot repository
cd /path/to/godot

# Run the script
pwsh cmake/GenerateSourceLists.ps1
```

This script scans the repository and creates source list files for each component.

### Using Generated Source Lists

In your component CMakeLists.txt files, include the specific source list:

```cmake
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/GODOT_CORE_sourcelist.cmake)

# Then use the appropriate variable:
add_library(godot_core STATIC ${GODOT_CORE_SOURCES})
```

Alternatively, you can include all source lists at once:

```cmake
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/all_sourcelists.cmake)
```

## Component Structure

The CMake build system organizes Godot into the following components:

- `godot_core` - Core functionality
- `godot_drivers` - Platform-specific and hardware drivers
- `godot_platform` - Platform abstraction
- `godot_scene` - Scene system
- `godot_servers` - Server abstractions
- `godot_editor` - Editor functionality
- `godot_main` - Main executable functionality

Each component is built as a static library and then linked into the final executable.

## Third-Party Libraries

Third-party libraries are handled in `thirdparty/CMakeLists.txt`. The build system can either use system-provided libraries (when available) or compile the bundled versions.

To use system libraries, configure CMake with:

```
cmake -DUSE_SYSTEM_LIBS=ON ..
```

## Platform-Specific Configuration

Platform-specific build options are set in the root CMakeLists.txt. The build system detects the platform and configures appropriate compilation flags and libraries.

## Building Godot with CMake

```bash
# Create a build directory
mkdir -p build
cd build

# Configure
cmake ..

# Build
cmake --build . --config Release

# Install (optional)
cmake --install .
```

For more detailed information on building Godot, refer to the official documentation. 