# Include in all Prolog packages

set(CMAKE_MODULE_PATH
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake"
    "${CMAKE_CURRENT_SOURCE_DIR}/../cmake")

# CMake modules we always need
include(CheckIncludeFile)
include(CheckFunctionExists)

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

set(SWIPL_LIBRARIES "")
set(SWIPL_INSTALL_MODULES ${SWIPL_INSTALL_PREFIX}/lib/${SWIPL_ARCH})
set(SWIPL_INSTALL_LIBRARY ${SWIPL_INSTALL_PREFIX}/library)
