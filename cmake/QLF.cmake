# compile_qlf spec ...

# run_installed_swipl(command
#		      [QUIET]
#		      [SCRIPT script ...]
#		      [PACKAGES pkg ...]
#		      [COMMENT comment])
#
# Run the compiled Prolog system with its home set to the installed system.
# This is used for post installation tasks

function(run_installed_swipl command)
  set(pforeign ${CMAKE_CURRENT_BINARY_DIR})
  set(plibrary ${CMAKE_CURRENT_SOURCE_DIR})
  set(sep ":")

  set(options -f none -t halt --home=${SWIPL_INSTALL_PREFIX})
  cmake_parse_arguments(my "QUIET" "COMMENT" "SCRIPT;PACKAGES" ${ARGN})

  if(my_QUIET)
    set(options ${options} -q)
  endif()

  if(my_COMMENT)
    install(CODE "message(\"${my_COMMENT}\")")
  endif()

  foreach(s ${my_SCRIPT})
    set(options ${options} -s ${s})
  endforeach()

  foreach(pkg ${packages})
    get_filename_component(src ${CMAKE_SOURCE_DIR}/packages/${pkg} ABSOLUTE)
    get_filename_component(bin ${CMAKE_BINARY_DIR}/packages/${pkg} ABSOLUTE)
    set(plibrary "${plibrary}${sep}${src}")
    set(pforeign "${pforeign}${sep}${bin}")
  endforeach()

  install(CODE "EXECUTE_PROCESS(COMMAND
                   ${CMAKE_BINARY_DIR}/src/swipl ${options} 
                   -p foreign=${pforeign} -p library=${plibrary} -g \"${command}\")")
endfunction()

# qcompile(spec ...)
# Generate QLF files for the given libraries.

function(qcompile)
  foreach(f ${ARGN})
    run_installed_swipl("qcompile(${f})"
			COMMENT "-- QLF compiling ${f}")
  endforeach()
endfunction()

