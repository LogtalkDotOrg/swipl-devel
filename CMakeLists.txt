cmake_minimum_required(VERSION 3.0)
project(SWI-Prolog)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(Version)

# Default location to install SWI-Prolog (for now)
if(IS_DIRECTORY "$ENV{SWIPL_INSTALL_PREFIX}")
  set(CMAKE_INSTALL_PREFIX $ENV{SWIPL_INSTALL_PREFIX})
  message("-- Using install prefix \"${CMAKE_INSTALL_PREFIX}\"")
endif()

# Default build target
set(CMAKE_BUILD_TYPE RelWithDebInfo)
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -gdwarf-2 -g3")
set(CMAKE_C_FLAGS_RELEASE "-O2")

if(MSVC)
  add_compile_options(/W3)
else()
  add_compile_options(-Wall)
endif()

set(SWIPL_PACKAGE_LIST
    clib
    zlib
    libedit
    plunit
    sgml
    http
    ssl
    RDF
    semweb
)

enable_testing()

# Add the core Prolog system
add_subdirectory(src)

# Add the packages
foreach(package ${SWIPL_PACKAGE_LIST})
  add_subdirectory(packages/${package})
endforeach(package)

include(Pack)
