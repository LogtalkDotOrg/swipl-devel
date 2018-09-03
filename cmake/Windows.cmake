if(CMAKE_SYSTEM_NAME MATCHES "Windows")

add_compile_options(-D__WINDOWS__)
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  add_compile_options(-DWIN64)
endif()

set(SRC_OS_SPECIFIC pl-nt.c pl-ntconsole.c pl-dde.c os/windows/uxnt.c)
set(LIBSWIPL_LIBRARIES ${LIBSWIPL_LIBRARIES} winmm.lib)

endif()
