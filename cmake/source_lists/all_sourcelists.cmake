# Master include file for source lists
# This file will include the appropriate source lists based on the inclusion path

# Determine if we are in the root directory or a component directory
get_filename_component(CURRENT_LIST_DIR ${CMAKE_CURRENT_LIST_DIR} ABSOLUTE)
get_filename_component(CMAKE_SOURCE_DIR_ABS ${CMAKE_SOURCE_DIR} ABSOLUTE)

if(${CURRENT_LIST_DIR} STREQUAL ${CMAKE_SOURCE_DIR_ABS})
  # We are in the root directory, include root-relative paths
  message(STATUS "Including source lists with root-relative paths")
  include(${CMAKE_SOURCE_DIR}/cmake/source_lists/root_sourcelists.cmake)
else()
  # We are in a component directory, include component-relative paths
  message(STATUS "Including source lists with component-relative paths")
  include(${CMAKE_SOURCE_DIR}/cmake/source_lists/component_sourcelists.cmake)
endif()