#!/usr/bin/env pwsh
# GenerateSourceLists.ps1
# Script to generate source lists for CMake files in Godot

# Create cmake directory if it doesn't exist
if (-not (Test-Path "cmake/source_lists")) {
    New-Item -ItemType Directory -Path "cmake/source_lists" -Force | Out-Null
}

if (-not (Test-Path "cmake/source_lists/component")) {
    New-Item -ItemType Directory -Path "cmake/source_lists/component" -Force | Out-Null
}

if (-not (Test-Path "cmake/source_lists/root")) {
    New-Item -ItemType Directory -Path "cmake/source_lists/root" -Force | Out-Null
}

# Helper function to generate a source list for a directory
function Generate-SourceList {
    param (
        [string]$directory,
        [string]$variableName,
        [string[]]$extensions = @("*.cpp", "*.c", "*.mm", "*.m", "*.h", "*.hpp"),
        [string[]]$excludeDirs = @()
    )

    Write-Output "Generating source list for $directory"

    # Create output files - one for component level, one for root level
    $componentOutputFile = "cmake/source_lists/component/${variableName}_sourcelist.cmake"
    $rootOutputFile = "cmake/source_lists/root/${variableName}_sourcelist.cmake"
    
    # Create or clear the output files
    Write-Output "# Generated source list for $directory (component-relative paths)" | Out-File -FilePath $componentOutputFile -Encoding utf8NoBOM
    Write-Output "# Generated source list for $directory (root-relative paths)" | Out-File -FilePath $rootOutputFile -Encoding utf8NoBOM

    $sourceFiles = @()
    $headerFiles = @()
    $rootSourceFiles = @()
    $rootHeaderFiles = @()
    
    # Extract the component name from the directory path
    $componentName = $directory.Split("/")[0]
    
    foreach ($ext in $extensions) {
        $files = Get-ChildItem -Path $directory -Filter $ext -Recurse |
                Where-Object { 
                    $include = $true
                    foreach ($excludeDir in $excludeDirs) {
                        if ($_.FullName -like "*\$excludeDir\*") {
                            $include = $false
                            break
                        }
                    }
                    $include 
                } |
                ForEach-Object { 
                    # Make the path relative to the component directory
                    $fullPath = $_.FullName.Replace("\", "/")
                    $componentRelativePath = $fullPath.Substring($fullPath.IndexOf("$componentName/") + $componentName.Length + 1)
                    
                    # Also create a root-relative path that includes the component name
                    $rootRelativePath = $fullPath.Substring($fullPath.IndexOf("$componentName/"))
                    
                    # Return both paths in a custom object
                    [PSCustomObject]@{
                        ComponentPath = $componentRelativePath
                        RootPath = $rootRelativePath
                    }
                }
                
        foreach ($file in $files) {
            if ($ext -like "*.h" -or $ext -like "*.hpp") {
                $headerFiles += $file.ComponentPath
                $rootHeaderFiles += $file.RootPath
            } else {
                $sourceFiles += $file.ComponentPath
                $rootSourceFiles += $file.RootPath
            }
        }
    }

    # Sort the files for consistency
    $sourceFiles = $sourceFiles | Sort-Object
    $headerFiles = $headerFiles | Sort-Object
    $rootSourceFiles = $rootSourceFiles | Sort-Object
    $rootHeaderFiles = $rootHeaderFiles | Sort-Object

    # COMPONENT LEVEL FILE

    # Write component-relative source files (for component CMakeLists.txt)
    Write-Output "# ${variableName}_SOURCES - Source files for $directory" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM
    Write-Output "set(${variableName}_SOURCES" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM

    foreach ($file in $sourceFiles) {
        Write-Output "  $file" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM
    }

    Write-Output ")" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM
    Write-Output "" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM

    # Write component-relative header files (for component CMakeLists.txt)
    Write-Output "# ${variableName}_HEADERS - Header files for $directory" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM
    Write-Output "set(${variableName}_HEADERS" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM

    foreach ($file in $headerFiles) {
        Write-Output "  $file" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM
    }

    Write-Output ")" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM
    Write-Output "" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM

    # Create component-relative ALL files variable (for component CMakeLists.txt)
    Write-Output "# ${variableName}_FILES - All files for $directory" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM
    Write-Output "set(${variableName}_FILES" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM
    Write-Output "  `${${variableName}_SOURCES}" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM
    Write-Output "  `${${variableName}_HEADERS}" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM
    Write-Output ")" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM

    # ROOT LEVEL FILE

    # Write root-relative source files (for root CMakeLists.txt)
    Write-Output "# ${variableName}_SOURCES - Source files for $directory" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
    Write-Output "set(${variableName}_SOURCES" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM

    foreach ($file in $rootSourceFiles) {
        Write-Output "  $file" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
    }

    Write-Output ")" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
    Write-Output "" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM

    # Write root-relative header files (for root CMakeLists.txt)
    Write-Output "# ${variableName}_HEADERS - Header files for $directory" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
    Write-Output "set(${variableName}_HEADERS" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM

    foreach ($file in $rootHeaderFiles) {
        Write-Output "  $file" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
    }

    Write-Output ")" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
    Write-Output "" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM

    # Create root-relative ALL files variable (for root CMakeLists.txt)
    Write-Output "# ${variableName}_FILES - All files for $directory" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
    Write-Output "set(${variableName}_FILES" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
    Write-Output "  `${${variableName}_SOURCES}" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
    Write-Output "  `${${variableName}_HEADERS}" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
    Write-Output ")" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
}

# Function to generate platform-specific drivers source list
function Generate-DriversSourceList {
    Write-Output "Generating platform-specific driver source lists..."

    # Create output files - one for component level, one for root level
    $componentOutputFile = "cmake/source_lists/component/GODOT_DRIVERS_PLATFORM_sourcelist.cmake"
    $rootOutputFile = "cmake/source_lists/root/GODOT_DRIVERS_PLATFORM_sourcelist.cmake"
    
    # Create or clear the output files
    Write-Output "# Platform-dependent driver source lists for Godot (component-relative paths)" | Out-File -FilePath $componentOutputFile -Encoding utf8NoBOM
    Write-Output "# This file organizes driver source files by platform" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM
    Write-Output "" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM

    Write-Output "# Platform-dependent driver source lists for Godot (root-relative paths)" | Out-File -FilePath $rootOutputFile -Encoding utf8NoBOM
    Write-Output "# This file organizes driver source files by platform" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
    Write-Output "" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM

    # Function to generate lists for a specific platform/subfolder
    function Generate-PlatformList {
        param (
            [string]$platform,
            [string]$displayName,
            [string[]]$folders
        )

        # Component level output
        Write-Output "# $displayName drivers" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM
        Write-Output "set(GODOT_DRIVERS_${platform}_SOURCES" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM

        # Root level output
        Write-Output "# $displayName drivers" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
        Write-Output "set(GODOT_DRIVERS_${platform}_SOURCES" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM

        $componentSourceFiles = @()
        $rootSourceFiles = @()

        foreach ($folder in $folders) {
            if (Test-Path "drivers/$folder") {
                # Create an array to hold all files
                $allFiles = @()
                
                # Add each type of file to the array
                $allFiles += @(Get-ChildItem -Path "drivers/$folder" -Filter "*.cpp" -Recurse)
                $allFiles += @(Get-ChildItem -Path "drivers/$folder" -Filter "*.c" -Recurse)
                $allFiles += @(Get-ChildItem -Path "drivers/$folder" -Filter "*.mm" -Recurse)
                $allFiles += @(Get-ChildItem -Path "drivers/$folder" -Filter "*.m" -Recurse)
                
                # Process each file
                foreach ($file in $allFiles) {
                    if ($file -ne $null) {
                        # Component-relative path (for drivers CMakeLists.txt)
                        $componentRelativePath = $file.FullName.Replace("$PWD\drivers\", "").Replace("\", "/")
                        $componentSourceFiles += $componentRelativePath
                        
                        # Root-relative path (for root CMakeLists.txt)
                        $rootRelativePath = "drivers/" + $componentRelativePath
                        $rootSourceFiles += $rootRelativePath
                    }
                }
            }
        }

        # Sort the files for consistency
        $componentSourceFiles = $componentSourceFiles | Sort-Object
        $rootSourceFiles = $rootSourceFiles | Sort-Object

        # Write component-relative files
        foreach ($file in $componentSourceFiles) {
            Write-Output "  $file" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM
        }

        Write-Output ")" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM
        Write-Output "" | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM

        # Write root-relative files
        foreach ($file in $rootSourceFiles) {
            Write-Output "  $file" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
        }

        Write-Output ")" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
        Write-Output "" | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
    }

    # Generate lists for each platform
    Generate-PlatformList -platform "WINDOWS" -displayName "Windows" -folders @("windows", "wasapi", "winmidi", "d3d12", "xaudio2")
    Generate-PlatformList -platform "MACOS" -displayName "macOS" -folders @("apple", "coreaudio", "coremidi", "metal")
    Generate-PlatformList -platform "IOS" -displayName "iOS" -folders @("apple", "coreaudio", "coremidi", "metal")
    Generate-PlatformList -platform "UNIX" -displayName "Linux/Unix" -folders @("unix", "alsa", "alsamidi", "pulseaudio")
    Generate-PlatformList -platform "COMMON" -displayName "Common drivers for all platforms" -folders @("png", "gl_context", "gles3")
    Generate-PlatformList -platform "VULKAN" -displayName "Vulkan drivers (cross-platform)" -folders @("vulkan")

    # Add platform flag management for component-relative paths
    @"
# Add platform flags to help with CMake conditionals
set(GODOT_DRIVERS_PLATFORM_FLAGS)

# Auto-detect which platform-specific sources to use by default
if(WIN32)
  list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES `${GODOT_DRIVERS_WINDOWS_SOURCES})
  list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS WINDOWS_ENABLED)
elseif(APPLE)
  if(IOS)
    list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES `${GODOT_DRIVERS_IOS_SOURCES})
    list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS APPLE_ENABLED IOS_ENABLED)
  else()
    list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES `${GODOT_DRIVERS_MACOS_SOURCES})
    list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS APPLE_ENABLED MACOS_ENABLED)
  endif()
elseif(UNIX)
  list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES `${GODOT_DRIVERS_UNIX_SOURCES})
  list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS UNIX_ENABLED)
endif()

# Always include common sources
list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES `${GODOT_DRIVERS_COMMON_SOURCES})

# Include Vulkan if enabled
if(VULKAN)
  list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES `${GODOT_DRIVERS_VULKAN_SOURCES})
  list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS VULKAN_ENABLED)
endif()

# Include GLES3 flag if enabled
if(GLES3)
  list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS GLES3_ENABLED)
endif()

# Set the final list that can be used in CMakeLists.txt
set(GODOT_DRIVERS_ACTIVE_SOURCES `${GODOT_DRIVERS_PLATFORM_SOURCES})
"@ | Out-File -FilePath $componentOutputFile -Append -Encoding utf8NoBOM

    # Also write the same platform flag management for root-relative paths
    @"
# Add platform flags to help with CMake conditionals
set(GODOT_DRIVERS_PLATFORM_FLAGS)

# Auto-detect which platform-specific sources to use by default
if(WIN32)
  list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES `${GODOT_DRIVERS_WINDOWS_SOURCES})
  list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS WINDOWS_ENABLED)
elseif(APPLE)
  if(IOS)
    list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES `${GODOT_DRIVERS_IOS_SOURCES})
    list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS APPLE_ENABLED IOS_ENABLED)
  else()
    list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES `${GODOT_DRIVERS_MACOS_SOURCES})
    list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS APPLE_ENABLED MACOS_ENABLED)
  endif()
elseif(UNIX)
  list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES `${GODOT_DRIVERS_UNIX_SOURCES})
  list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS UNIX_ENABLED)
endif()

# Always include common sources
list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES `${GODOT_DRIVERS_COMMON_SOURCES})

# Include Vulkan if enabled
if(VULKAN)
  list(APPEND GODOT_DRIVERS_PLATFORM_SOURCES `${GODOT_DRIVERS_VULKAN_SOURCES})
  list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS VULKAN_ENABLED)
endif()

# Include GLES3 flag if enabled
if(GLES3)
  list(APPEND GODOT_DRIVERS_PLATFORM_FLAGS GLES3_ENABLED)
endif()

# Set the final list that can be used in CMakeLists.txt
set(GODOT_DRIVERS_ACTIVE_SOURCES `${GODOT_DRIVERS_PLATFORM_SOURCES})
"@ | Out-File -FilePath $rootOutputFile -Append -Encoding utf8NoBOM
}

# Generate source lists for main components
Generate-SourceList -directory "core" -variableName "GODOT_CORE" -excludeDirs @("tests")
Generate-SourceList -directory "drivers" -variableName "GODOT_DRIVERS" -excludeDirs @("tests")
Generate-SourceList -directory "platform" -variableName "GODOT_PLATFORM" -excludeDirs @("tests")
Generate-SourceList -directory "scene" -variableName "GODOT_SCENE" -excludeDirs @("tests")
Generate-SourceList -directory "servers" -variableName "GODOT_SERVERS" -excludeDirs @("tests")
Generate-SourceList -directory "editor" -variableName "GODOT_EDITOR" -excludeDirs @("tests")
Generate-SourceList -directory "main" -variableName "GODOT_MAIN" -excludeDirs @("tests")

# Generate source lists for key third-party libraries
Generate-SourceList -directory "thirdparty/mbedtls" -variableName "GODOT_THIRDPARTY_MBEDTLS" -extensions @("*.c", "*.h")
Generate-SourceList -directory "thirdparty/freetype" -variableName "GODOT_THIRDPARTY_FREETYPE" -extensions @("*.c", "*.h")
Generate-SourceList -directory "thirdparty/zlib" -variableName "GODOT_THIRDPARTY_ZLIB" -extensions @("*.c", "*.h")

# Generate the platform-specific driver source list
Generate-DriversSourceList

# Create include-all files for both component and root levels
$componentIncludeAllFile = "cmake/source_lists/component_sourcelists.cmake"
$rootIncludeAllFile = "cmake/source_lists/root_sourcelists.cmake"

Write-Output "# Include all generated source lists for component-level use" | Out-File -FilePath $componentIncludeAllFile -Encoding utf8NoBOM
Write-Output "# Include all generated source lists for root-level use" | Out-File -FilePath $rootIncludeAllFile -Encoding utf8NoBOM

$components = @(
    "GODOT_CORE",
    "GODOT_DRIVERS",
    "GODOT_PLATFORM",
    "GODOT_SCENE",
    "GODOT_SERVERS",
    "GODOT_EDITOR",
    "GODOT_MAIN",
    "GODOT_THIRDPARTY_MBEDTLS",
    "GODOT_THIRDPARTY_FREETYPE",
    "GODOT_THIRDPARTY_ZLIB"
)

foreach ($component in $components) {
    Write-Output "include(`${CMAKE_SOURCE_DIR}/cmake/source_lists/component/${component}_sourcelist.cmake)" | Out-File -FilePath $componentIncludeAllFile -Append -Encoding utf8NoBOM
    Write-Output "include(`${CMAKE_SOURCE_DIR}/cmake/source_lists/root/${component}_sourcelist.cmake)" | Out-File -FilePath $rootIncludeAllFile -Append -Encoding utf8NoBOM
}

# Also include the platform-specific drivers list
Write-Output "include(`${CMAKE_SOURCE_DIR}/cmake/source_lists/component/GODOT_DRIVERS_PLATFORM_sourcelist.cmake)" | Out-File -FilePath $componentIncludeAllFile -Append -Encoding utf8NoBOM
Write-Output "include(`${CMAKE_SOURCE_DIR}/cmake/source_lists/root/GODOT_DRIVERS_PLATFORM_sourcelist.cmake)" | Out-File -FilePath $rootIncludeAllFile -Append -Encoding utf8NoBOM

Write-Output "" | Out-File -FilePath $componentIncludeAllFile -Append -Encoding utf8NoBOM
Write-Output "# Usage: Include this file in component CMakeLists.txt to get component-relative paths" | Out-File -FilePath $componentIncludeAllFile -Append -Encoding utf8NoBOM
Write-Output "# Example: include(`${CMAKE_SOURCE_DIR}/cmake/source_lists/component_sourcelists.cmake)" | Out-File -FilePath $componentIncludeAllFile -Append -Encoding utf8NoBOM

Write-Output "" | Out-File -FilePath $rootIncludeAllFile -Append -Encoding utf8NoBOM
Write-Output "# Usage: Include this file in root CMakeLists.txt to get root-relative paths" | Out-File -FilePath $rootIncludeAllFile -Append -Encoding utf8NoBOM
Write-Output "# Example: include(`${CMAKE_SOURCE_DIR}/cmake/source_lists/root_sourcelists.cmake)" | Out-File -FilePath $rootIncludeAllFile -Append -Encoding utf8NoBOM

# Create a simple all-include file that points to both - using a direct string without variable expansion
$allIncludeContent = @"
# Master include file for source lists
# This file will include the appropriate source lists based on the inclusion path

# Determine if we are in the root directory or a component directory
get_filename_component(CURRENT_LIST_DIR `${CMAKE_CURRENT_LIST_DIR} ABSOLUTE)
get_filename_component(CMAKE_SOURCE_DIR_ABS `${CMAKE_SOURCE_DIR} ABSOLUTE)

if(`${CURRENT_LIST_DIR} STREQUAL `${CMAKE_SOURCE_DIR_ABS})
  # We are in the root directory, include root-relative paths
  message(STATUS "Including source lists with root-relative paths")
  include(`${CMAKE_SOURCE_DIR}/cmake/source_lists/root_sourcelists.cmake)
else()
  # We are in a component directory, include component-relative paths
  message(STATUS "Including source lists with component-relative paths")
  include(`${CMAKE_SOURCE_DIR}/cmake/source_lists/component_sourcelists.cmake)
endif()
"@

# Write the file directly without using PowerShell's string interpolation
[System.IO.File]::WriteAllText("cmake/source_lists/all_sourcelists.cmake", $allIncludeContent, [System.Text.Encoding]::UTF8)

Write-Output "Source lists generated and saved to cmake/source_lists/component/ and cmake/source_lists/root/" 