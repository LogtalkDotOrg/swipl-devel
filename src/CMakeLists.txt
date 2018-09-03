cmake_minimum_required(VERSION 3.4)
project(swipl)

option(BUILD_SHARED_LIBS
       "Do (not) build shared libraries"
       ON)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../cmake")

include(Version)
include(Utils)
include(Windows)

include(CheckIncludeFile)
include(CheckLibraryExists)
include(CheckFunctionExists)
include(CheckSymbolExists)
include(CheckTypeSize)
include(AlignOf)
include(CheckStructHasMember)

find_package(Threads)
find_package(ZLIB)
find_package(GMP)
if(UNIX)
find_package(Curses)
endif(UNIX)

include(Config)
include(GCCBuiltins)
include(TestSignalType)
include(TestSCNProcessors)

# FIXME: Is this still needed?
if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
  add_compile_options(-fno-strict-aliasing)
endif()

# Source locations
get_filename_component(SWIPL_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/.." ABSOLUTE)
set(SWIPL_LIBRARY_ROOT ${SWIPL_ROOT}/library)
set(SWIPL_BOOT_ROOT ${SWIPL_ROOT}/boot)

# Installation locations
string(TOLOWER ${CMAKE_HOST_SYSTEM_PROCESSOR}-${CMAKE_HOST_SYSTEM_NAME}
       SWIPL_ARCH)

set(SWIPL_INSTALL_DIR swipl)
set(SWIPL_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX}/lib/${SWIPL_INSTALL_DIR})
set(SWIPL_INSTALL_ARCH_EXE ${SWIPL_INSTALL_PREFIX}/bin/${SWIPL_ARCH})
set(SWIPL_INSTALL_ARCH_LIB ${SWIPL_INSTALL_PREFIX}/lib/${SWIPL_ARCH})
set(SWIPL_INSTALL_LIBRARY  ${SWIPL_INSTALL_PREFIX}/library)
set(SWIPL_INSTALL_BOOT     ${SWIPL_INSTALL_PREFIX}/boot)
set(SWIPL_INSTALL_INCLUDE  ${SWIPL_INSTALL_PREFIX}/include)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(SWIPL_BOOT_FILE "boot64.prc")
else()
  set(SWIPL_BOOT_FILE "boot32.prc")
endif()

include(Install)

################
# C files
################

set(SRC_OS pl-buffer.c pl-ctype.c pl-file.c pl-files.c pl-glob.c pl-os.c
    pl-stream.c pl-string.c pl-table.c pl-text.c pl-utf8.c pl-fmt.c
    pl-dtoa.c pl-option.c pl-cstack.c pl-codelist.c pl-prologflag.c pl-tai.c
    pl-locale.c)
prepend(SRC_OS os/ ${SRC_OS})


set(SRC_TAI caltime_utc caltime_tai leapsecs_sub leapsecs_add
    caldate_fmjd caldate_mjd leapsecs_init leapsecs_read tai_pack
    tai_unpack)
prepend(SRC_TAI libtai/ ${SRC_TAI})

set(SRC_MINIZIP zip.c unzip.c ioapi.c)
prepend(SRC_MINIZIP minizip/ ${SRC_MINIZIP})

set(SRC_CORE pl-atom.c pl-wam.c pl-arith.c pl-bag.c pl-error.c
    pl-comp.c pl-zip.c pl-dwim.c pl-ext.c pl-flag.c
    pl-funct.c pl-gc.c pl-privitf.c pl-list.c pl-string.c
    pl-load.c pl-modul.c pl-op.c pl-prims.c pl-pro.c
    pl-proc.c pl-prof.c pl-read.c pl-rec.c pl-setup.c
    pl-sys.c pl-trace.c pl-util.c pl-wic.c pl-write.c
    pl-term.c pl-thread.c pl-xterm.c pl-srcfile.c
    pl-beos.c pl-attvar.c pl-gvar.c pl-btree.c
    pl-init.c pl-gmp.c pl-segstack.c pl-hash.c
    pl-version.c pl-codetable.c pl-supervisor.c
    pl-dbref.c pl-termhash.c pl-variant.c pl-assert.c
    pl-copyterm.c pl-debug.c pl-cont.c pl-ressymbol.c pl-dict.c
    pl-trie.c pl-indirect.c pl-tabling.c pl-rsort.c pl-mutex.c)

set(HDR_CORE pl-atom.ih pl-funct.ih)

set(LIBSWIPL_SRC
    ${SRC_CORE}
    ${SRC_OS}
    ${SRC_OS_SPECIFIC}
    ${SRC_TAI}
    ${SRC_MINIZIP})
set(SWIPL_SRC pl-main.c)

################
# Prolog files
################

set(SWIPL_BOOT_FILES syspred.pl toplevel.pl license.pl bags.pl apply.pl
    expand.pl dcg.pl history.pl attvar.pl packs.pl dwim.pl rc.pl predopts.pl
    parms.pl autoload.pl qlf.pl topvars.pl messages.pl load.pl dicts.pl
    engines.pl iri.pl tabling.pl)
prepend(SWIPL_BOOT_FILES ${SWIPL_BOOT_ROOT} ${SWIPL_BOOT_FILES})

set(PL_LIB helpidx.pl help.pl explain.pl sort.pl
    qsave.pl shlib.pl statistics.pl system.pl error.pl
    backcomp.pl gensym.pl listing.pl debug.pl vm.pl
    quintus.pl edinburgh.pl ctypes.pl files.pl modules.pl
    edit.pl shell.pl check.pl heaps.pl win_menu.pl console_input.pl
    tty.pl readln.pl readutil.pl make.pl hotfix.pl option.pl
    oset.pl ordsets.pl occurs.pl lists.pl pprint.pl
    www_browser.pl url.pl utf8.pl main.pl assoc.pl nb_set.pl
    threadutil.pl qpforeign.pl dif.pl when.pl ugraphs.pl
    checklast.pl checkselect.pl operators.pl date.pl
    prolog_stack.pl prolog_clause.pl prolog_xref.pl prolog_source.pl
    broadcast.pl pairs.pl base64.pl record.pl rbtrees.pl settings.pl
    thread.pl dialect.pl apply_macros.pl apply.pl nb_rbtrees.pl
    aggregate.pl pure_input.pl pio.pl thread_pool.pl terms.pl
    charsio.pl portray_text.pl csv.pl persistency.pl fastrw.pl
    coinduction.pl ansi_term.pl base32.pl prolog_history.pl
    optparse.pl arithmetic.pl writef.pl predicate_options.pl
    random.pl prolog_breakpoints.pl prolog_autoload.pl
    prolog_colour.pl varnumbers.pl codesio.pl prolog_codewalk.pl
    prolog_pack.pl git.pl prolog_metainference.pl quasi_quotations.pl
    sandbox.pl prolog_format.pl prolog_install.pl check_installation.pl
    solution_sequences.pl iostream.pl dicts.pl yall.pl tabling.pl
    lazy_lists.pl prolog_jiti.pl zip.pl obfuscate.pl)

set(PL_LIB_CLP bounds.pl clp_events.pl clp_distinct.pl simplex.pl
    clpfd.pl clpb.pl)
prepend(PL_LIB_CLP clp/ ${PL_LIB_CLP})

set(PL_LIB_DCG basics.pl)
prepend(PL_LIB_DCG dcg/ ${PL_LIB_DCG})

prepend(PL_LIB_FILES     ${SWIPL_LIBRARY_ROOT} ${PL_LIB})
prepend(PL_LIB_FILES_CLP ${SWIPL_LIBRARY_ROOT} ${PL_LIB_CLP})
prepend(PL_LIB_FILES_DCG ${SWIPL_LIBRARY_ROOT} ${PL_LIB_DCG})
set(PL_LIB_FILES_ALL ${PL_LIB_FILES} ${PL_LIB_FILES_CLP} ${PL_LIB_FILES_DCG})
set(PL_LIB_INDEX ${SWIPL_LIBRARY_ROOT}/INDEX.pl)

################
# Custom targets and commands
################

# FIXME: should we create these in the build directory?
# FIXME: it is not allowed to have multiple OUTPUT that appear in
# the dependencies of independent targets.  This is supposed to use
# add_custom_target(), but that will force the build regardless of
# whether this is out of date, forcing rebuilding the entire remainder
add_custom_command(
    OUTPUT  ${CMAKE_CURRENT_SOURCE_DIR}/pl-codetable.c
	    ${CMAKE_CURRENT_SOURCE_DIR}/pl-jumptable.ic
            ${CMAKE_CURRENT_SOURCE_DIR}/pl-vmi.h
    COMMAND mkvmi ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDS mkvmi pl-vmi.c
    COMMENT "Generating VMI metadata"
)

add_custom_command(
    OUTPUT  pl-atom.ih pl-funct.ih
    COMMAND defatom ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDS defatom ATOMS
    COMMENT "Generating static atoms and functors"
)

set(USE_GIT_VERSION_H 1)
add_custom_target(
    version.h
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/mkversion.sh
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Updating (git) version"
)

add_custom_command(
    OUTPUT  swipl.prc
    COMMAND swipl -O -b ${SWIPL_BOOT_ROOT}/init.pl
    DEPENDS swipl ${SWIPL_BOOT_FILES}
)

add_custom_command(
    OUTPUT  ${PL_LIB_INDEX}
    COMMAND swipl -f none -g "\"make_library_index('${SWIPL_LIBRARY_ROOT}')\"" -t halt
    DEPENDS swipl.prc ${PL_LIB_FILES_ALL}
)

add_custom_target(prolog_products ALL
    DEPENDS swipl.prc ${PL_LIB_INDEX}
)

configure_file(config.h.cmake config.h)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/../swipl.home" "${SWIPL_ROOT}\n")

# build helpers
add_executable(mkvmi mkvmi.c)
add_executable(defatom defatom.c)

# Establish libraries
if(CURSES_FOUND)
  set(LIBSWIPL_LIBRARIES ${LIBSWIPL_LIBRARIES} ${CURSES_LIBRARIES})
endif()
if(GMP_FOUND)
  set(LIBSWIPL_LIBRARIES ${LIBSWIPL_LIBRARIES} ${GMP_LIBRARIES})
endif()
set(LIBSWIPL_LIBRARIES
    ${LIBSWIPL_LIBRARIES}
    ${ZLIB_LIBRARIES}
    ${CMAKE_THREAD_LIBS_INIT})
if(HAVE_LIBDL)
  set(LIBSWIPL_LIBRARIES ${LIBSWIPL_LIBRARIES} dl)
endif()
if(HAVE_LIBM)
  set(LIBSWIPL_LIBRARIES ${LIBSWIPL_LIBRARIES} m)
endif()
if(HAVE_LIBRT)
  set(LIBSWIPL_LIBRARIES ${LIBSWIPL_LIBRARIES} rt)
endif()

# build swipl
add_executable(swipl ${SWIPL_SRC})
target_link_libraries(swipl libswipl)

# build the library
add_library(libswipl ${LIBSWIPL_SRC} ${HDR_CORE})
add_dependencies(libswipl version.h)
set_target_properties(libswipl PROPERTIES
		      OUTPUT_NAME swipl
		      VERSION ${SWIPL_VERSION_STRING}
		      SOVERSION ${SWIPL_VERSION_MAJOR})
target_include_directories(libswipl BEFORE PRIVATE
			   ${CMAKE_CURRENT_BINARY_DIR}
			   ${CMAKE_CURRENT_SOURCE_DIR}
			   ${ZLIB_INCLUDE_DIRS})
target_link_libraries(libswipl ${LIBSWIPL_LIBRARIES})

include(WindowsTargets)

# testing
add_custom_target(check
    COMMAND swipl -q -g test -t halt ${CMAKE_CURRENT_SOURCE_DIR}/test.pl
)

# Populate parms.h, making the compilation environment known to Prolog
include(Params)
configure_file(parms.h.cmake parms.h)

################
# Installation
################

install(TARGETS swipl libswipl
	RUNTIME DESTINATION ${SWIPL_INSTALL_ARCH_EXE}
        LIBRARY DESTINATION ${SWIPL_INSTALL_ARCH_LIB}
)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/swipl.prc
	DESTINATION ${SWIPL_INSTALL_PREFIX}
	RENAME ${SWIPL_BOOT_FILE}
)
install(CODE "MESSAGE(\"Installing the library.\")")
install(FILES ${PL_LIB_FILES}     DESTINATION ${SWIPL_INSTALL_LIBRARY})
install(FILES ${PL_LIB_FILES_CLP} DESTINATION ${SWIPL_INSTALL_LIBRARY}/clp)
install(FILES ${PL_LIB_FILES_DCG} DESTINATION ${SWIPL_INSTALL_LIBRARY}/dcg)
install(FILES ${PL_LIB_INDEX}     DESTINATION ${SWIPL_INSTALL_LIBRARY})
install(FILES ${SWIPL_BOOT_FILES} DESTINATION ${SWIPL_INSTALL_BOOT})
install(FILES
	${CMAKE_CURRENT_SOURCE_DIR}/SWI-Prolog.h
	${CMAKE_CURRENT_SOURCE_DIR}/os/SWI-Stream.h
	DESTINATION ${SWIPL_INSTALL_INCLUDE})
install(CODE "file(WRITE ${SWIPL_INSTALL_PREFIX}/bin/swipl.home \"..\n\")")
install(CODE "file(WRITE ${SWIPL_INSTALL_PREFIX}/swipl.home \".\n\")")

# Create symbolic link from public installation dir to executables
install(DIRECTORY DESTINATION bin)
ilink(${SWIPL_INSTALL_ARCH_EXE}/swipl
      ${CMAKE_INSTALL_PREFIX}/bin/swipl)
