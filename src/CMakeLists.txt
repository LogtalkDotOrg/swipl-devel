cmake_minimum_required(VERSION 3.4)
project(SWI-Prolog)
set(SWIPL_VERSION_MAJOR 7)
set(SWIPL_VERSION_MINOR 7)
set(SWIPL_VERSION_PATCH 19)
set(SWIPL_VERSION_STRING ${SWIPL_VERSION_MAJOR}.${SWIPL_VERSION_MINOR}.${SWIPL_VERSION_PATCH})

option(BUILD_SHARED_LIBS
       "Do (not) build shared libraries"
       ON)

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

include(Utils)

include(CheckIncludeFile)
include(CheckLibraryExists)
include(CheckFunctionExists)
include(CheckTypeSize)
include(CheckStructHasMember)

include(FindThreads)
include(FindZLIB)
include(FindGMP)

if(${CMAKE_USE_PTHREADS_INIT})
  set(O_PLMT 1)
endif()
if(${GMP_FOUND})
  set(HAVE_GMP_H 1)
endif()

include(Config)
include(TestSignalType)
include(TestSCNProcessors)

# Populate parms.h
set(C_CC     ${CMAKE_C_COMPILER})
set(C_CFLAGS ${CMAKE_C_FLAGS})

set(PLDISTDIR swipl)
set(PLBASE ${CMAKE_INSTALL_PREFIX}/${PLDISTDIR})
string(TOLOWER ${CMAKE_HOST_SYSTEM_PROCESSOR}-${CMAKE_HOST_SYSTEM_NAME} PLARCH)
get_filename_component(PLHOME .. ABSOLUTE)
set(PL_LIB_SRC_DIR ${PLHOME}/library)
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set(PLBOOT_FILE "boot64.prc")
else()
  set(PLBOOT_FILE "boot32.prc")
endif()

include(Install)

################
# C files
################

set(SRC_OS os/pl-buffer.c os/pl-ctype.c os/pl-file.c os/pl-files.c
    os/pl-glob.c os/pl-os.c os/pl-stream.c os/pl-string.c os/pl-table.c
    os/pl-text.c os/pl-utf8.c os/pl-fmt.c os/pl-dtoa.c os/pl-option.c
    os/pl-cstack.c os/pl-codelist.c os/pl-prologflag.c
    os/pl-tai.c os/pl-locale.c)

set(SRC_TAI libtai/caltime_utc libtai/caltime_tai libtai/leapsecs_sub
    libtai/leapsecs_add libtai/caldate_fmjd libtai/caldate_mjd
    libtai/leapsecs_init libtai/leapsecs_read libtai/tai_pack
    libtai/tai_unpack)

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
    pl-trie.c pl-indirect.c pl-tabling.c pl-rsort.c pl-mutex.c
    minizip/zip.c minizip/unzip.c minizip/ioapi.c)

set(HDR_CORE pl-atom.ih pl-funct.ih)

set(SRC_LIB_SWIPL ${SRC_CORE} ${SRC_OS} ${SRC_TAI})
set(SRC_SWIPL pl-main)

################
# Prolog files
################

set(PL_BOOT ../boot/syspred.pl ../boot/toplevel.pl ../boot/license.pl
    ../boot/bags.pl ../boot/apply.pl ../boot/expand.pl ../boot/dcg.pl
    ../boot/history.pl ../boot/attvar.pl ../boot/packs.pl
    ../boot/dwim.pl ../boot/rc.pl ../boot/predopts.pl
    ../boot/parms.pl ../boot/autoload.pl ../boot/qlf.pl
    ../boot/topvars.pl ../boot/messages.pl ../boot/load.pl
    ../boot/dicts.pl ../boot/engines.pl ../boot/iri.pl ../boot/tabling.pl)

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

set(PL_LIB_CLP bounds.pl clp_events.pl clp_distinct.pl simplex.pl clpfd.pl clpb.pl)
prepend(PL_LIB_CLP clp/ ${PL_LIB_CLP})
set(PL_LIB_DCG basics.pl)
prepend(PL_LIB_DCG dcg/ ${PL_LIB_DCG})

prepend(PL_LIB_FILES     ${PL_LIB_SRC_DIR} ${PL_LIB})
prepend(PL_LIB_FILES_CLP ${PL_LIB_SRC_DIR} ${PL_LIB_CLP})
prepend(PL_LIB_FILES_DCG ${PL_LIB_SRC_DIR} ${PL_LIB_DCG})
set(PL_LIB_FILES_ALL ${PL_LIB_FILES} ${PL_LIB_FILES_CLP} ${PL_LIB_FILES_DCG})
set(PL_LIB_INDEX ${PL_LIB_SRC_DIR}/INDEX.pl)

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
    COMMAND swipl -O -b ${PLHOME}/boot/init.pl
    DEPENDS swipl ${PL_BOOT}
)

add_custom_command(
    OUTPUT  ${PL_LIB_INDEX}
    COMMAND swipl -f none -g "\"make_library_index(\'${PL_LIB_SRC_DIR}\')\"" -t halt
    DEPENDS swipl.prc ${PL_LIB_FILES_ALL}
)

add_custom_target(prolog_products ALL
    DEPENDS swipl.prc ${PL_LIB_SRC_DIR}/INDEX.pl
)

configure_file(config.h.in config.h)
configure_file(parms.h.in parms.h)
include_directories(BEFORE ${CMAKE_BINARY_DIR})
include_directories(BEFORE ${CMAKE_SOURCE_DIR})

# build helpers
add_executable(mkvmi mkvmi.c)
add_executable(defatom defatom.c)

# build swipl
add_executable(swipl ${SRC_SWIPL})
target_link_libraries(swipl libswipl
		      ${ZLIB_LIBRARIES}
		      ${GMP_LIBRARIES}
		      ${CMAKE_THREAD_LIBS_INIT})
if(HAVE_LIB_DL)
  target_link_libraries(swipl dl)
endif()
if(HAVE_LIB_M)
  target_link_libraries(swipl m)
endif()
if(HAVE_LIB_RT)
  target_link_libraries(swipl rt)
endif()

# build the library
add_library(libswipl ${SRC_LIB_SWIPL} ${HDR_CORE})
set_target_properties(libswipl PROPERTIES
		      OUTPUT_NAME swipl
		      VERSION ${SWIPL_VERSION_STRING}
		      SOVERSION ${SWIPL_VERSION_MAJOR})
add_dependencies(libswipl version.h)

# testing
add_custom_target(check
    COMMAND swipl -q -g test -t halt ${CMAKE_CURRENT_SOURCE_DIR}/test.pl
)

################
# Installation
################


install(TARGETS swipl libswipl
	RUNTIME DESTINATION lib/${PLDISTDIR}/bin/${PLARCH}
        LIBRARY DESTINATION lib/${PLDISTDIR}/lib/${PLARCH}
)
install(FILES ${CMAKE_BINARY_DIR}/swipl.prc
	DESTINATION lib/${PLDISTDIR}
	RENAME ${PLBOOT_FILE}
)
install(CODE "MESSAGE(\"Installing the library.\")")
install(FILES ${PL_LIB_FILES} DESTINATION lib/${PLDISTDIR}/library)
install(FILES ${PL_LIB_FILES_CLP} DESTINATION lib/${PLDISTDIR}/library/clp)
install(FILES ${PL_LIB_FILES_DCG} DESTINATION lib/${PLDISTDIR}/library/dcg)
install(FILES ${PL_LIB_INDEX} DESTINATION lib/${PLDISTDIR}/library)
install(CODE "file(WRITE ${CMAKE_INSTALL_PREFIX}/lib/${PLDISTDIR}/bin/swipl.home \"..\n\")")
install(CODE "file(WRITE ${CMAKE_INSTALL_PREFIX}/lib/${PLDISTDIR}/swipl.home \".\n\")")

# Create symbolic link from public installation dir to executables
install(DIRECTORY DESTINATION bin)
ilink(${CMAKE_INSTALL_PREFIX}/lib/${PLDISTDIR}/bin/${PLARCH}/swipl
      ${CMAKE_INSTALL_PREFIX}/bin/swipl)
