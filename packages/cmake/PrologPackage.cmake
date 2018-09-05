# Include in all Prolog packages

set(CMAKE_MODULE_PATH
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake"
    "${CMAKE_CURRENT_SOURCE_DIR}/../cmake")

# CMake modules we always need
include(CheckIncludeFile)
include(CheckFunctionExists)
include(CheckSymbolExists)

# Arity is of size_t.  This should now be the case for all packages
set(PL_ARITY_AS_SIZE 1)

if(NOT SWIPL_ROOT)
  get_filename_component(SWIPL_ROOT ../.. ABSOLUTE)
endif()
if(NOT SWIPL_INSTALL_DIR)
  set(SWIPL_INSTALL_DIR swipl)
endif()
if(NOT SWIPL_INSTALL_PREFIX)
  set(SWIPL_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX}/lib/${SWIPL_INSTALL_DIR})
endif()
if(NOT SWIPL_ARCH)
  string(TOLOWER ${CMAKE_HOST_SYSTEM_PROCESSOR}-${CMAKE_HOST_SYSTEM_NAME}
	 SWIPL_ARCH)
endif()

include_directories(BEFORE ${SWIPL_ROOT}/src ${SWIPL_ROOT}/src/os)
include_directories(BEFORE ${CMAKE_CURRENT_BINARY_DIR})

if(CMAKE_EXECUTABLE_FORMAT STREQUAL "ELF")
  set(SWIPL_LIBRARIES "")
else()
  set(SWIPL_LIBRARIES libswipl)
endif()

set(SWIPL_INSTALL_MODULES ${SWIPL_INSTALL_PREFIX}/lib/${SWIPL_ARCH})
set(SWIPL_INSTALL_LIBRARY ${SWIPL_INSTALL_PREFIX}/library)

# swipl_foreign_module(name
#		       [C_SOURCES file ...]
#		       [C_LIBS lib ...]
#		       [PL_LIBS file ...])

function(swipl_foreign_module name)
  set(target "module_${name}")
  set(c_sources)
  set(c_libs)
  set(pl_libs)
  set(mode)

  foreach(arg ${ARGN})
    if(arg STREQUAL "C_SOURCES")
      set(mode c_sources)
    elseif(arg STREQUAL "C_LIBS")
      set(mode c_libs)
    elseif(arg STREQUAL "PL_LIBS")
      set(mode pl_libs)
    else()
      set(${mode} ${${mode}} ${arg})
    endif()
  endforeach()

  add_library(${target} MODULE ${c_sources})
  set_target_properties(${target} PROPERTIES OUTPUT_NAME ${name} PREFIX "")
  target_link_libraries(${target} ${c_libs} ${SWIPL_LIBRARIES})

  install(TARGETS ${target}
	  LIBRARY DESTINATION ${SWIPL_INSTALL_MODULES})
  install(FILES ${pl_libs}
	  DESTINATION ${SWIPL_INSTALL_LIBRARY})
endfunction()
