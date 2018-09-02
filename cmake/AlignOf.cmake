MACRO(ALIGNOF TYPE LANG NAME)

  IF(NOT ${NAME})

    #
    # Try to compile and run a foo grogram.
    # The alignment result will be stored in ALIGNOF_${CHECK_TYPE}
    #

    SET(INCLUDE_HEADERS
      "#include <stddef.h>
       #include <stdio.h>
       #include <stdlib.h>")

    FOREACH(File ${CMAKE_EXTRA_INCLUDE_FILES})
        SET(INCLUDE_HEADERS "${INCLUDE_HEADERS}\n#include <${File}>\n")
    ENDFOREACH()
    SET(INCLUDE_HEADERS "${INCLUDE_HEADERS}\n#include <stdint.h>\n")

    FILE (WRITE "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/c_get_${NAME}_alignment.${LANG}"
      "${INCLUDE_HEADERS}
       int main(){
           char diff;
           struct foo {char a; ${TYPE} b;};
           struct foo *p = (struct foo *) malloc(sizeof(struct foo));
           diff = ((char *)&p->b) - ((char *)&p->a);
           return diff;
       }"
    )

    TRY_RUN(${NAME} COMPILE_RESULT "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/"
      "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/c_get_${NAME}_alignment.${LANG}"
      COMPILE_OUTPUT_VARIABLE "${NAME}_COMPILE_VAR")

    IF (NOT COMPILE_RESULT)
        MESSAGE(FATAL_ERROR "Check alignment of ${TYPE} in ${LANG}: compilation failed: ${${NAME}_COMPILE_VAR}")
    ELSE()
        MESSAGE(STATUS "Check alignment of ${TYPE} in ${LANG}: ${${NAME}}")
    ENDIF()

  ENDIF()

ENDMACRO()
