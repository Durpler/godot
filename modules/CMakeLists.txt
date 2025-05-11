# Godot modules system

# Set default options for modules
option(MODULE_MONO_ENABLED "Enable Mono module" OFF)
option(MODULE_GDSCRIPT_ENABLED "Enable GDScript module" ON)
option(MODULE_MBEDTLS_ENABLED "Enable mbedTLS module" ON)
option(MODULE_FREETYPE_ENABLED "Enable FreeType module" ON)

# Find all potential modules
file(GLOB module_directories RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "*")

# Initialize module lists
set(GODOT_MODULES_SOURCES "")
set(GODOT_MODULES_INCLUDES "")
set(GODOT_MODULES_LIBS "")
set(GODOT_MODULES_DEFS "")

# Process each module directory
foreach(module_dir ${module_directories})
  # Skip non-directories
  if(NOT IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${module_dir}")
    continue()
  endif()

  # Check if we have an option defined for this module
  string(TOUPPER "${module_dir}" module_upper)
  set(module_option_name "MODULE_${module_upper}_ENABLED")
  
  # If the module has no explicit option, auto-enable if there's a CMakeLists.txt
  if(NOT DEFINED ${module_option_name})
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${module_dir}/CMakeLists.txt")
      set(${module_option_name} ON CACHE BOOL "Enable ${module_dir} module" FORCE)
    else()
      set(${module_option_name} OFF CACHE BOOL "Enable ${module_dir} module" FORCE)
    endif()
  endif()
  
  # If the module is enabled, include its CMakeLists.txt or do default processing
  if(${module_option_name})
    message(STATUS "Enabling module: ${module_dir}")
    
    # Add module-specific definition
    list(APPEND GODOT_MODULES_DEFS "MODULE_${module_upper}_ENABLED")
    
    # If the module has its own CMakeLists.txt, include it
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${module_dir}/CMakeLists.txt")
      add_subdirectory(${module_dir})
    else()
      # Default module processing - search for source files
      file(GLOB_RECURSE module_sources
        "${module_dir}/*.cpp"
        "${module_dir}/*.c"
      )
      
      # Add to the main sources list
      list(APPEND GODOT_MODULES_SOURCES ${module_sources})
      
      # Add the module's include directory
      list(APPEND GODOT_MODULES_INCLUDES "${CMAKE_CURRENT_SOURCE_DIR}/${module_dir}")
    endif()
  endif()
endforeach()

# Create a static library with all modules that don't have their own CMakeLists.txt
if(GODOT_MODULES_SOURCES)
  add_library(godot_modules STATIC ${GODOT_MODULES_SOURCES})
  
  target_include_directories(godot_modules
    PUBLIC
      ${GODOT_MODULES_INCLUDES}
      ${CMAKE_SOURCE_DIR}
  )
  
  target_link_libraries(godot_modules
    PUBLIC
      godot_core
      ${GODOT_MODULES_LIBS}
      ${GODOT_THIRDPARTY_LIBS}
  )
  
  target_compile_definitions(godot_modules
    PUBLIC
      ${GODOT_MODULES_DEFS}
  )
endif()

# Export module variables to parent scope
set(GODOT_MODULES_INCLUDES ${GODOT_MODULES_INCLUDES} PARENT_SCOPE)
set(GODOT_MODULES_LIBS ${GODOT_MODULES_LIBS} PARENT_SCOPE)
set(GODOT_MODULES_DEFS ${GODOT_MODULES_DEFS} PARENT_SCOPE) 