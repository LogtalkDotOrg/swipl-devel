# compile_qlf spec ...

# run_installed_swipl(command [QUIET] [SCRIPT script ...] [COMMENT comment])
# Run Prolog with its home set to the installed system.  This is used for
# post installation tasks

function(run_installed_swipl command)
  set(options -f none -t halt --home=${SWIPL_INSTALL_PREFIX})
  cmake_parse_arguments(my "QUIET" "COMMENT" "SCRIPT" ${ARGN})
  if(my_QUIET)
    set(options ${options} -q)
  endif()
  if(my_COMMENT)
    install(CODE "message(\"${my_COMMENT}\")")
  endif()
  foreach(s ${my_SCRIPT})
    set(options ${options} -s ${s})
  endforeach()
  install(CODE "EXECUTE_PROCESS(COMMAND swipl ${options} -g \"${command}\")")
endfunction()

# qcompile(spec ...)
# Generate QLF files for the given libraries.

function(qcompile)
  foreach(f ${ARGN})
    run_installed_swipl("qcompile(${f})"
			COMMENT "-- QLF compiling ${f}")
  endforeach()
endfunction()

