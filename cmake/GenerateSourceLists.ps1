#!/usr/bin/env pwsh
# GenerateSourceLists.ps1
# Script to generate source lists for CMake files in Godot

# Create cmake directory if it doesn't exist
if (-not (Test-Path "cmake/source_lists")) {
    New-Item -ItemType Directory -Path "cmake/source_lists" -Force | Out-Null
}

# Helper function to generate a source list for a directory
function Generate-SourceList {
    param (
        [string]$directory,
        [string]$variableName,
        [string[]]$extensions = @("*.cpp", "*.c", "*.mm", "*.m", "*.h", "*.hpp"),
        [string[]]$excludeDirs = @()
    )

    Write-Output "Generating source list for $directory into ${variableName}_sourcelist.cmake"

    # Create output file
    $outputFile = "cmake/source_lists/${variableName}_sourcelist.cmake"
    
    # Create or clear the output file
    Write-Output "# Generated source list for $directory" | Out-File -FilePath $outputFile

    $sourceFiles = @()
    $headerFiles = @()
    
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
                    $relativePath = $_.FullName.Replace("$PWD\", "").Replace("\", "/")
                    $relativePath
                }
                
        if ($ext -like "*.h" -or $ext -like "*.hpp") {
            $headerFiles += $files
        } else {
            $sourceFiles += $files
        }
    }

    # Sort the files for consistency
    $sourceFiles = $sourceFiles | Sort-Object
    $headerFiles = $headerFiles | Sort-Object

    # Write source files to the output file
    Write-Output "# ${variableName}_SOURCES - Source files for $directory" | Out-File -FilePath $outputFile -Append
    Write-Output "set(${variableName}_SOURCES" | Out-File -FilePath $outputFile -Append

    foreach ($file in $sourceFiles) {
        Write-Output "  $file" | Out-File -FilePath $outputFile -Append
    }

    Write-Output ")" | Out-File -FilePath $outputFile -Append
    Write-Output "" | Out-File -FilePath $outputFile -Append

    # Write header files to the output file
    Write-Output "# ${variableName}_HEADERS - Header files for $directory" | Out-File -FilePath $outputFile -Append
    Write-Output "set(${variableName}_HEADERS" | Out-File -FilePath $outputFile -Append

    foreach ($file in $headerFiles) {
        Write-Output "  $file" | Out-File -FilePath $outputFile -Append
    }

    Write-Output ")" | Out-File -FilePath $outputFile -Append
    Write-Output "" | Out-File -FilePath $outputFile -Append

    # Create an ALL files variable
    Write-Output "# ${variableName}_FILES - All files for $directory" | Out-File -FilePath $outputFile -Append
    Write-Output "set(${variableName}_FILES" | Out-File -FilePath $outputFile -Append
    Write-Output "  `${${variableName}_SOURCES}" | Out-File -FilePath $outputFile -Append
    Write-Output "  `${${variableName}_HEADERS}" | Out-File -FilePath $outputFile -Append
    Write-Output ")" | Out-File -FilePath $outputFile -Append
}

# Function to generate platform-specific drivers source list
function Generate-DriversSourceList {
    Write-Output "Generating platform-specific driver source lists..."

    $outputFile = "cmake/source_lists/GODOT_DRIVERS_PLATFORM_sourcelist.cmake"
    
    # Create or clear the output file
    Write-Output "# Platform-dependent driver source lists for Godot" | Out-File -FilePath $outputFile
    Write-Output "# This file organizes driver source files by platform" | Out-File -FilePath $outputFile
    Write-Output "" | Out-File -FilePath $outputFile

    # Function to generate lists for a specific platform/subfolder
    function Generate-PlatformList {
        param (
            [string]$platform,
            [string]$displayName,
            [string[]]$folders
        )

        Write-Output "# $displayName drivers" | Out-File -FilePath $outputFile -Append
        Write-Output "set(GODOT_DRIVERS_${platform}_SOURCES" | Out-File -FilePath $outputFile -Append

        $sourceFiles = @()

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
                        $relativePath = $file.FullName.Replace("$PWD\", "").Replace("\", "/")
                        $sourceFiles += $relativePath
                    }
                }
            }
        }

        # Sort the files for consistency
        $sourceFiles = $sourceFiles | Sort-Object

        foreach ($file in $sourceFiles) {
            Write-Output "  $file" | Out-File -FilePath $outputFile -Append
        }

        Write-Output ")" | Out-File -FilePath $outputFile -Append
        Write-Output "" | Out-File -FilePath $outputFile -Append
    }

    # Generate lists for each platform
    Generate-PlatformList -platform "WINDOWS" -displayName "Windows" -folders @("windows", "wasapi", "winmidi", "d3d12", "xaudio2")
    Generate-PlatformList -platform "MACOS" -displayName "macOS" -folders @("apple", "coreaudio", "coremidi", "metal")
    Generate-PlatformList -platform "IOS" -displayName "iOS" -folders @("apple", "coreaudio", "coremidi", "metal")
    Generate-PlatformList -platform "UNIX" -displayName "Linux/Unix" -folders @("unix", "alsa", "alsamidi", "pulseaudio")
    Generate-PlatformList -platform "COMMON" -displayName "Common drivers for all platforms" -folders @("png", "gl_context", "gles3")
    Generate-PlatformList -platform "VULKAN" -displayName "Vulkan drivers (cross-platform)" -folders @("vulkan")

    # Add platform flag management
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

# Set the final list that can be used in drivers/CMakeLists.txt
set(GODOT_DRIVERS_ACTIVE_SOURCES `${GODOT_DRIVERS_PLATFORM_SOURCES})
"@ | Out-File -FilePath $outputFile -Append
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

# Create an include-all file
$includeAllFile = "cmake/source_lists/all_sourcelists.cmake"
Write-Output "# Include all generated source lists" | Out-File -FilePath $includeAllFile

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
    Write-Output "include(`${CMAKE_SOURCE_DIR}/cmake/source_lists/${component}_sourcelist.cmake)" | Out-File -FilePath $includeAllFile -Append
}

# Also include the platform-specific drivers list
Write-Output "include(`${CMAKE_SOURCE_DIR}/cmake/source_lists/GODOT_DRIVERS_PLATFORM_sourcelist.cmake)" | Out-File -FilePath $includeAllFile -Append

Write-Output "" | Out-File -FilePath $includeAllFile -Append
Write-Output "# Usage: include this file in your root CMakeLists.txt" | Out-File -FilePath $includeAllFile -Append
Write-Output "#        include(`${CMAKE_SOURCE_DIR}/cmake/source_lists/all_sourcelists.cmake)" | Out-File -FilePath $includeAllFile -Append

Write-Output "Source lists generated and saved to cmake/source_lists/" 