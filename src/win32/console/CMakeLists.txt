cmake_minimum_required(VERSION 2.8.12)
project(swipl-plterm)

add_compile_options(-DUNICODE -D_UNICODE)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/../..)

add_library(libplterm complete.c console.c edit.c history.c menu.c)
set_target_properties(libplterm PROPERTIES
		      OUTPUT_NAME plterm
		      PREFIX "")

install(TARGETS libplterm
	RUNTIME DESTINATION ${SWIPL_INSTALL_ARCH_EXE}
        LIBRARY DESTINATION ${SWIPL_INSTALL_ARCH_LIB}
)
