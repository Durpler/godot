# Third-party dependencies

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Include generated source lists
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/GODOT_THIRDPARTY_MBEDTLS_sourcelist.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/GODOT_THIRDPARTY_FREETYPE_sourcelist.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/source_lists/GODOT_THIRDPARTY_ZLIB_sourcelist.cmake)

# Convert relative paths to full paths
set(MBEDTLS_FULL_PATHS)
foreach(SOURCE_FILE ${GODOT_THIRDPARTY_MBEDTLS_SOURCES})
  list(APPEND MBEDTLS_FULL_PATHS "${CMAKE_CURRENT_SOURCE_DIR}/mbedtls/${SOURCE_FILE}")
endforeach()

set(FREETYPE_FULL_PATHS)
foreach(SOURCE_FILE ${GODOT_THIRDPARTY_FREETYPE_SOURCES})
  list(APPEND FREETYPE_FULL_PATHS "${CMAKE_CURRENT_SOURCE_DIR}/freetype/${SOURCE_FILE}")
endforeach()

set(ZLIB_FULL_PATHS)
foreach(SOURCE_FILE ${GODOT_THIRDPARTY_ZLIB_SOURCES})
  list(APPEND ZLIB_FULL_PATHS "${CMAKE_CURRENT_SOURCE_DIR}/zlib/${SOURCE_FILE}")
endforeach()

# Option to use system libraries where available
option(USE_SYSTEM_LIBS "Use system libraries instead of bundled ones when possible" OFF)

# MbedTLS
if(USE_SYSTEM_LIBS AND NOT WIN32)
  find_package(MbedTLS)
endif()

if(MBEDTLS_FOUND)
  message(STATUS "Using system MbedTLS")
  add_library(godot_thirdparty_mbedtls INTERFACE)
  target_link_libraries(godot_thirdparty_mbedtls INTERFACE MbedTLS::mbedtls MbedTLS::mbedcrypto MbedTLS::mbedx509)
else()
  message(STATUS "Using bundled MbedTLS")
  # First check if mbedtls folder exists
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/mbedtls/library")
    add_library(godot_thirdparty_mbedtls STATIC ${GODOT_THIRDPARTY_MBEDTLS_SOURCES})
    target_include_directories(godot_thirdparty_mbedtls PUBLIC mbedtls/include)
    target_compile_definitions(godot_thirdparty_mbedtls PRIVATE MBEDTLS_GODOT)
  else()
    # For initial configuration, use an empty source list to allow config to proceed
    add_library(godot_thirdparty_mbedtls STATIC "")
    message(WARNING "MbedTLS source files not found. Using an empty placeholder library.")
  endif()
endif()

# FreeType
if(USE_SYSTEM_LIBS AND NOT WIN32)
  find_package(Freetype)
endif()

if(FREETYPE_FOUND)
  message(STATUS "Using system FreeType")
  add_library(godot_thirdparty_freetype INTERFACE)
  target_link_libraries(godot_thirdparty_freetype INTERFACE Freetype::Freetype)
else()
  message(STATUS "Using bundled FreeType")
  # Manually compile FreeType instead of using add_subdirectory since it doesn't have CMakeLists.txt
  
  # Check if freetype folder exists
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/freetype/src")
    add_library(godot_thirdparty_freetype STATIC ${GODOT_THIRDPARTY_FREETYPE_SOURCES})
    target_include_directories(godot_thirdparty_freetype
      PUBLIC
        freetype/include
      PRIVATE
        freetype/src
    )
    
    # Disable Harfbuzz, Brotli, etc.
    target_compile_definitions(godot_thirdparty_freetype
      PRIVATE
        FT2_BUILD_LIBRARY
        FT_CONFIG_OPTION_USE_BROTLI=0
    )
  else()
    # For initial configuration, use an empty source list to allow config to proceed
    add_library(godot_thirdparty_freetype STATIC "")
    message(WARNING "FreeType source files not found. Using an empty placeholder library.")
  endif()
endif()

# ZLIB
if(USE_SYSTEM_LIBS AND NOT WIN32)
  find_package(ZLIB)
endif()

if(ZLIB_FOUND)
  message(STATUS "Using system ZLIB")
  add_library(godot_thirdparty_zlib INTERFACE)
  target_link_libraries(godot_thirdparty_zlib INTERFACE ZLIB::ZLIB)
else()
  message(STATUS "Using bundled ZLIB")
  # Check if zlib folder exists
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/zlib")
    add_library(godot_thirdparty_zlib STATIC ${GODOT_THIRDPARTY_ZLIB_SOURCES})
    target_include_directories(godot_thirdparty_zlib PUBLIC zlib)
  else()
    # For initial configuration, use an empty source list to allow config to proceed
    add_library(godot_thirdparty_zlib STATIC "")
    message(WARNING "ZLIB source files not found. Using an empty placeholder library.")
  endif()
endif()

# Create convenience variable for all third-party libraries
set(GODOT_THIRDPARTY_LIBS 
  godot_thirdparty_mbedtls
  godot_thirdparty_freetype
  godot_thirdparty_zlib
) 