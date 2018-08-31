cmake_minimum_required(VERSION 3.0)
project(SWI-Prolog)

# Default location to install SWI-Prolog (for now)
set(CMAKE_INSTALL_PREFIX $ENV{HOME}/cmake)
# Default build target
set(CMAKE_BUILD_TYPE RelWithDebInfo)
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -gdwarf-2 -g3 -Wall")

set(SWIPL_PACKAGE_LIST
    libedit
)

# Add the core Prolog system
add_subdirectory(src)

# Add the packages
foreach(package ${SWIPL_PACKAGE_LIST})
  add_subdirectory(packages/${package})
endforeach(package)
