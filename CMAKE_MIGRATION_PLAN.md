# Godot Engine CMake Migration Plan

## Overview

This document outlines the plan for migrating the Godot Engine build system from SCons to CMake. The goal is to replace the existing Python-based SCons build system with a more standard CMake-based approach, which has several advantages:

- Wider IDE integration and support
- Better caching and incremental builds
- More familiar to C++ developers
- Less dependency on Python for building
- Better cross-platform support

## Current Status

We have created CMakeLists.txt files for all major components:
- Root project configuration
- Core module
- Platform-specific code
- Drivers
- Third-party libraries with FreeType setup
- Modules system
- Scene system with shader compilation
- Servers
- Editor with resource embedding

The system can now successfully configure with CMake, but there are outstanding issues that need to be addressed before it can be fully functional.

## Migration Strategy

The migration follows these steps:

1. **Analysis Phase** (Completed)
   - Understand the current SCons build structure
   - Identify all build targets, dependencies, and flags
   - Map SCons build variables to CMake equivalents

2. **Basic Structure Implementation** (Completed)
   - Create root CMakeLists.txt with basic project structure
   - Define main build options and variables
   - Set up compiler and platform-specific flags

3. **Component Migration** (Completed)
   - Implement CMakeLists.txt for each major directory:
     - ✅ core: Basic implementation done
     - ✅ drivers: Basic implementation done
     - ✅ platform: Basic implementation done
     - ✅ thirdparty: Implementation done with FreeType setup
     - ✅ scene: Implemented with shader compilation
     - ✅ servers: Implementation done
     - ✅ editor: Implementation done with resource embedding
     - ✅ modules: Dynamic module detection implemented

4. **Custom Commands and Tools** (Completed)
   - ✅ Implement shader compilation system using PowerShell
   - ✅ Create resource embedding system using PowerShell
   - ✅ Set up CMake module for shader processing

5. **Platform-Specific Configurations** (In Progress)
   - ✅ Implement basic platform-specific build logic
   - ✅ Added Android toolchain file
   - ⬜ Handle iOS/Web platform peculiarities
   - ⬜ Configure for console platforms

6. **Third-Party Integration** (In Progress)
   - ✅ Fixed FreeType integration without CMakeLists.txt
   - ⬜ Set up proper integration for other third-party libraries
   - ⬜ Handle Vulkan and other external dependencies

7. **Build System Testing** (To Do)
   - ⬜ Test CMake builds on all supported platforms
   - ⬜ Compare build outputs with SCons
   - ⬜ Benchmark build times

8. **Documentation and Integration** (Partially Completed)
   - ✅ Create build usage documentation
   - ⬜ Provide migration guide for developers
   - ⬜ Update CI/CD pipelines

## Remaining Issues

### High Priority
- Test and fix build issues on different platforms
- Create CMake configurations for remaining third-party libraries
- Generate proper source file lists for all components
- Validate shader compilation system
- Verify resource embedding works correctly

### Medium Priority
- Implement export template generation
- Create configuration for console platforms
- Implement tests in CMake
- Set up CI/CD integration

### Low Priority
- Optimize build performance
- Create developer documentation
- Set up continuous benchmarking

## Fixes Implemented
- Fixed FreeType integration by creating minimal configuration files and directly compiling the library
- Fixed editor/main executable linking issue
- Reorganized subdirectory includes to ensure proper dependency ordering

## Implementation Notes

### Module System
The module system has been implemented to:
- Dynamically detect and include all modules
- Handle module dependencies
- Allow enabling/disabling modules through CMake options

### Cross-Compilation
- Android toolchain file has been created
- iOS toolchain file needs to be created
- Web platform support via Emscripten needs to be added

### Third-Party Libraries
- System libraries can be used when available
- Bundled libraries are used as fallback
- Flexible configuration maintained for customization
- FreeType now builds properly with minimal configuration files

## Testing Strategy
- First ensure CMake builds produce identical binaries to SCons
- Run extensive tests on all supported platforms
- Compare build performance and optimization

## Timeline
- Phase 1-3: Basic Structure and Component Migration (Completed)
- Phase 4: Custom Commands and Tools (Completed)
- Phase 5-6: Platform Support and Third-Party Integration (Current Focus)
- Phase 7-8: Testing and Documentation (Next Steps)

## Conclusion
The CMake migration is progressing well with most components implemented. The current focus is on properly integrating all third-party libraries and ensuring the build system works correctly across all platforms. Some manual configuration may be required for certain parts of the codebase where the automatic discovery doesn't work correctly. 