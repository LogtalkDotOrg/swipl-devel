if(CMAKE_SYSTEM_NAME MATCHES "Darwin")

# Prefer sem_open() over deprecated sem_init()
set(USE_SEM_OPEN 1)

endif()
