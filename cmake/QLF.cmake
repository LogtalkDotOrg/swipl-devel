# compile_qlf spec ...

function(run_installed_swipl command)
  install(CODE "EXECUTE_PROCESS(COMMAND swipl -f none --home=${SWIPL_INSTALL_PREFIX} -g \"${command}\" -t halt)")
endfunction()

function(qcompile)
  foreach(f ${ARGN})
    install(CODE "message(\"-- QLF compiling ${f}\")")
    run_installed_swipl("qcompile(${f})")
  endforeach()
endfunction()

