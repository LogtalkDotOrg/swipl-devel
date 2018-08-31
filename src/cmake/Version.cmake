# Set SWIPL_VERSION_MAJOR, SWIPL_VERSION_MINOR and SWIPL_VERSION_PATCH
# from the VERSION file in the project root

file(READ "${CMAKE_CURRENT_SOURCE_DIR}/../VERSION" SWIPL_VERSION_STRING)

string(STRIP "${SWIPL_VERSION_STRING}" SWIPL_VERSION_STRING)
string(REGEX MATCHALL "[0-9a-z][0-9a-z]*"
       VERSION_COMPONENTS ${SWIPL_VERSION_STRING})

list(GET VERSION_COMPONENTS 0 SWIPL_VERSION_MAJOR)
list(GET VERSION_COMPONENTS 1 SWIPL_VERSION_MINOR)
list(GET VERSION_COMPONENTS 2 SWIPL_VERSION_PATCH)

message("Configuring SWI-Prolog-${SWIPL_VERSION_MAJOR}.${SWIPL_VERSION_MINOR}.${SWIPL_VERSION_PATCH}")
