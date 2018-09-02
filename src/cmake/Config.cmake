check_include_file(inttypes.h HAVE_INTTYPES_H)
check_include_file(stdlib.h HAVE_STDLIB_H)
check_include_file(strings.h HAVE_STRINGS_H)
check_include_file(wchar.h HAVE_WCHAR_H)
check_include_file(alloca.h HAVE_ALLOCA_H)
check_include_file(curses.h HAVE_CURSES_H)
check_include_file(dirent.h HAVE_DIRENT_H)
check_include_file(dl.h HAVE_DL_H)
check_include_file(dlfcn.h HAVE_DLFCN_H)
check_include_file(dmalloc.h HAVE_DMALLOC_H)
check_include_file(execinfo.h HAVE_EXECINFO_H)
check_include_file(float.h HAVE_FLOAT_H)
check_include_file(floatingpoint.h HAVE_FLOATINGPOINT_H)
check_include_file(ieeefp.h HAVE_IEEEFP_H)
check_include_file(ieee754.h HAVE_IEEE754_H)
check_include_file(libloaderapi.h HAVE_LIBLOADERAPI_H)
check_include_file(limits.h HAVE_LIMITS_H)
check_include_file(locale.h HAVE_LOCALE_H)
check_include_file(malloc.h HAVE_MALLOC_H)
check_include_file(memory.h HAVE_MEMORY_H)
check_include_file(ncurses/curses.h HAVE_NCURSES_CURSES_H)
check_include_file(ncurses/term.h HAVE_NCURSES_TERM_H)
check_include_file(poll.h HAVE_POLL_H)
check_include_file(pwd.h HAVE_PWD_H)
check_include_file(shlobj.h HAVE_SHLOBJ_H)
check_include_file(siginfo.h HAVE_SIGINFO_H)
check_include_file(signal.h HAVE_SIGNAL_H)
check_include_file(string.h HAVE_STRING_H)
check_include_file(sys/dir.h HAVE_SYS_DIR_H)
check_include_file(sys/file.h HAVE_SYS_FILE_H)
check_include_file(sys/mman.h HAVE_SYS_MMAN_H)
check_include_file(sys/ndir.h HAVE_SYS_NDIR_H)
check_include_file(sys/param.h HAVE_SYS_PARAM_H)
check_include_file(sys/resource.h HAVE_SYS_RESOURCE_H)
check_include_file(sys/select.h HAVE_SYS_SELECT_H)
check_include_file(sys/stat.h HAVE_SYS_STAT_H)
check_include_file(sys/syscall.h HAVE_SYS_SYSCALL_H)
check_include_file(sys/termio.h HAVE_SYS_TERMIO_H)
check_include_file(sys/termios.h HAVE_SYS_TERMIOS_H)
check_include_file(sys/time.h HAVE_SYS_TIME_H)
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(sys/wait.h HAVE_SYS_WAIT_H)
check_include_file(term.h HAVE_TERM_H)
check_include_file(time.h HAVE_TIME_H)
check_include_file(unistd.h HAVE_UNISTD_H)
check_include_file(valgrind/valgrind.h HAVE_VALGRIND_VALGRIND_H)
check_include_file(vfork.h HAVE_VFORK_H)
check_include_file(mach/thread_act.h HAVE_MACH_THREAD_ACT_H)
check_include_file(sys/stropts.h HAVE_SYS_STROPTS_H)

check_library_exists(dl dlopen	      "" HAVE_LIBDL)
check_library_exists(m  sin           "" HAVE_LIBM)
check_library_exists(rt clock_gettime "" HAVE_LIBRT)

if(HAVE_LIBDL)
set(CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES} dl)
endif()
if(HAVE_LIBM)
set(CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES} m)
endif()
if(HAVE_LIBRT)
set(CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES} rt)
endif()
set(CMAKE_REQUIRED_LIBRARIES ${CMAKE_REQUIRED_LIBRARIES}
    ${CMAKE_THREAD_LIBS_INIT}
    ${GMP_LIBRARIES}
)

set(CMAKE_REQUIRED_INCLUDES ${CMAKE_REQUIRED_INCLUDES} ${GMP_INCLUDE_DIRS})

set(CMAKE_EXTRA_INCLUDE_FILES ${CMAKE_EXTRA_INCLUDE_FILES} math.h)
if(GMP_FOUND)
  set(CMAKE_EXTRA_INCLUDE_FILES ${CMAKE_EXTRA_INCLUDE_FILES} gmp.h)
endif()

#if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
#  set(CMAKE_REQUIRED_FLAGS ${CMAKE_REQUIRED_FLAGS} -Wno-builtin-declaration-mismatch)
#endif()

################
# Types

check_type_size("int" SIZEOF_INT)
check_type_size("long" SIZEOF_LONG)
check_type_size("void *" SIZEOF_VOIDP)
check_type_size("long long int" SIZEOF_LONG_LONG)
check_type_size("wchar_t" SIZEOF_WCHAR_T)
check_type_size("mp_bitcnt_t" SIZEOF_MP_BITCNT_T)

if(NOT SIZEOF_MP_BITCNT_T STREQUAL "")
  set(HAVE_MP_BITCNT_T 1)
endif()

alignof(int64_t c ALIGNOF_INT64_T)
alignof(double c ALIGNOF_DOUBLE)
alignof("void*" c ALIGNOF_VOIDP)


################
# Functions

# Misc
check_function_exists(mmap HAVE_MMAP)
check_function_exists(strerror HAVE_STRERROR)
check_function_exists(poll HAVE_POLL)
check_function_exists(popen HAVE_POPEN)
check_function_exists(getpwnam HAVE_GETPWNAM)
check_function_exists(fork HAVE_FORK)
check_function_exists(vfork HAVE_VFORK)
check_function_exists(qsort_r HAVE_QSORT_R)
check_function_exists(qsort_s HAVE_QSORT_S)
check_function_exists(getpagesize HAVE_GETPAGESIZE)
# files
check_function_exists(access HAVE_ACCESS)
check_function_exists(chmod HAVE_CHMOD)
check_function_exists(fchmod HAVE_FCHMOD)
check_function_exists(fcntl HAVE_FCNTL)
check_function_exists(fstat HAVE_FSTAT)
check_function_exists(ftruncate HAVE_FTRUNCATE)
check_function_exists(getcwd HAVE_GETCWD)
check_function_exists(getwd HAVE_GETWD)
check_function_exists(opendir HAVE_OPENDIR)
check_function_exists(readlink HAVE_READLINK)
check_function_exists(remove HAVE_REMOVE)
check_function_exists(rename HAVE_RENAME)
check_function_exists(stat HAVE_STAT)
# Strings and locale
check_function_exists(memmove HAVE_MEMMOVE)
check_function_exists(strcasecmp HAVE_STRCASECMP)
check_function_exists(stricmp HAVE_STRICMP)
check_function_exists(strlwr HAVE_STRLWR)
check_function_exists(setlocale HAVE_SETLOCALE)
check_function_exists(mbsnrtowcs HAVE_MBSNRTOWCS)
check_function_exists(mbcasescoll HAVE_MBCASESCOLL)
check_function_exists(localeconv HAVE_LOCALECONV)
check_function_exists(wcsdup HAVE_WCSDUP)
check_function_exists(wcsxfrm HAVE_WCSXFRM)
# processes
check_function_exists(getpid HAVE_GETPID)
check_function_exists(waitpid HAVE_WAITPID)
# environment, config
check_function_exists(setenv HAVE_SETENV)
check_function_exists(putenv HAVE_PUTENV)
check_function_exists(unsetenv HAVE_UNSETENV)
check_function_exists(sysconf HAVE_SYSCONF)
check_function_exists(confstr HAVE_CONFSTR)
check_function_exists(getrlimit HAVE_GETRLIMIT)
check_function_exists(getrusage HAVE_GETRUSAGE)
# dynamic linking
check_function_exists(shl_load HAVE_SHL_LOAD)
check_function_exists(dlopen HAVE_DLOPEN)
check_function_exists(dladdr HAVE_DLADDR)
# signals
check_function_exists(signal HAVE_SIGNAL)
check_function_exists(sigprocmask HAVE_SIGPROCMASK)
check_function_exists(sigsetmask HAVE_SIGSETMASK)
check_function_exists(siggetmask HAVE_SIGGETMASK)
check_function_exists(sigaction HAVE_SIGACTION)
check_function_exists(sigset HAVE_SIGSET)
check_function_exists(sigblock HAVE_SIGBLOCK)
check_function_exists(kill HAVE_KILL)
check_function_exists(backtrace HAVE_BACKTRACE)
# Allocation
check_function_exists(mtrace HAVE_MTRACE)
# terminal
check_function_exists(tgetent HAVE_TGETENT)
check_function_exists(tcsetattr HAVE_TCSETATTR)
check_function_exists(grantpt HAVE_GRANTPT)
check_function_exists(sgttyb HAVE_SGTTYB)
check_function_exists(cfmakeraw HAVE_CFMAKERAW)
# math
check_function_exists(ceil HAVE_CEIL)
check_function_exists(floor HAVE_FLOOR)
check_function_exists(srand HAVE_SRAND)
check_function_exists(srandom HAVE_SRANDOM)
check_function_exists(random HAVE_RANDOM)
check_function_exists(rint HAVE_RINT)
check_function_exists(fpclass HAVE_FPCLASS)
check_function_exists(_fpclass HAVE_FPCLASS)
# check_function_exists(fpclassify HAVE_FPCLASSIFY)
check_function_exists(fpresetsticky HAVE_FPRESETSTICKY)
check_function_exists(fpsetmask HAVE_FPSETMASK)
check_function_exists(isnan HAVE_ISNAN)
check_function_exists(isinf HAVE_ISINF)
# time and sleep
check_function_exists(ftime HAVE_FTIME)
check_function_exists(clock_gettime HAVE_CLOCK_GETTIME)
check_function_exists(gettimeofday HAVE_GETTIMEOFDAY)
check_function_exists(localtime_r HAVE_LOCALTIME_R)
check_function_exists(localtime_s HAVE_LOCALTIME_S)
check_function_exists(ctime_r HAVE_CTIME_R)
check_function_exists(asctime_r HAVE_ASCTIME_R)
check_function_exists(nanosleep HAVE_NANOSLEEP)
check_function_exists(sleep HAVE_SLEEP)
check_function_exists(usleep HAVE_USLEEP)
check_function_exists(select HAVE_SELECT)
check_function_exists(clock HAVE_CLOCK)
check_function_exists(times HAVE_TIMES)
check_function_exists(delay HAVE_DELAY)
check_function_exists(dossleep HAVE_DOSSLEEP)
check_function_exists(clock_gettime HAVE_CLOCK_GETTIME)
# threads and scheduling
check_function_exists(pthread_attr_setaffinity_np HAVE_PTHREAD_ATTR_SETAFFINITY_NP)
check_function_exists(pthread_getname_np HAVE_PTHREAD_GETNAME_NP)
check_function_exists(pthread_getw32threadhandle_np HAVE_PTHREAD_GETW32THREADHANDLE_NP)
check_function_exists(pthread_kill HAVE_PTHREAD_KILL)
check_function_exists(pthread_mutexattr_setkind_np HAVE_PTHREAD_MUTEXATTR_SETKIND_NP)
check_function_exists(pthread_mutexattr_settype HAVE_PTHREAD_MUTEXATTR_SETTYPE)
check_function_exists(pthread_mutex_timedlock HAVE_PTHREAD_MUTEX_TIMEDLOCK)
check_function_exists(pthread_setconcurrency HAVE_PTHREAD_SETCONCURRENCY)
check_function_exists(pthread_setname_np HAVE_PTHREAD_SETNAME_NP)
check_function_exists(pthread_sigmask HAVE_PTHREAD_SIGMASK)
check_function_exists(pthread_timedjoin_np HAVE_PTHREAD_TIMEDJOIN_NP)
check_function_exists(pthread_getcpuclockid HAVE_PTHREAD_GETCPUCLOCKID)
check_function_exists(sched_setaffinity HAVE_SCHED_SETAFFINITY)
check_function_exists(sema_init HAVE_SEMA_INIT)
check_function_exists(sem_init HAVE_SEM_INIT)
# Windows
check_function_exists(WSAPoll HAVE_WSAPOLL)
check_function_exists(WinExec HAVE_WINEXEC)

check_symbol_exists(F_SETLKW fcntl.h HAVE_F_SETLKW)
check_symbol_exists(timezone time.h HAVE_VAR_TIMEZONE)

check_struct_has_member("struct tm" tm_gmtoff time.h HAVE_STRUCT_TIME_TM_GMTOFF)
check_struct_has_member("struct stat" st_mtim stat.h HAVE_STRUCT_STAT_ST_MTIM)
check_struct_has_member("struct rusage" ru_idrss sys/resource.h HAVE_RU_IDRSS)

# GMP
# check_function_exists(gmp_randinit_mt HAVE_GMP_RANDINIT_MT)
# Requires <gmp.h> as this is a macro
check_c_source_compiles(
    "#include <gmp.h>\nint main() { gmp_randinit_mt(0); return 0;}"
    HAVE_GMP_RANDINIT_MT)

if(HAVE_QSORT_R)
  include(TestGNUQsortR)
endif()


################
# Set of features compatible with the old config tools

if(HAVE_CLOCK_GETTIME AND HAVE_PTHREAD_GETCPUCLOCKID)
  set(PTHREAD_CPUCLOCKS 1)
endif()
if(CMAKE_USE_PTHREADS_INIT)
  set(O_PLMT 1)
endif()
if(GMP_FOUND)
  set(HAVE_GMP_H 1)
endif()
if(HAVE_F_SETLKW AND HAVE_FCNTL)
  set(FCNTL_LOCKS 1)
endif()

################
# Stuff we do not need to define is below such that findmacros.pl does
# not complain about them.

# HAVE_VISITED
# HAVE_SIGNALS
# HAVE_SIGINFO  (no longer used; may be deleted)
# HAVE_RLIM_T   (no longer used; may be deleted)
