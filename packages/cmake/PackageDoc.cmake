include(Documentation)

set(SWIPL      ${CMAKE_INSTALL_PREFIX}/bin/swipl)
set(LATEX2HTML ${CMAKE_INSTALL_PREFIX}/lib/swipl/bin/latex2html ${DOC_OPTIONS})
set(DOC2TEX    ${SWIPL_ROOT}/man/doc2tex)
set(RUNTEX     ${SWIPL_ROOT}/man/runtex ${DOC_OPTIONS})
set(PLTOTEX    ${SWIPL} ${SWIPL_ROOT}/packages/pltotex.pl --)

function(doc2tex file)
  add_custom_command(
      OUTPUT ${file}.tex
      COMMAND ${DOC2TEX} ${CMAKE_CURRENT_SOURCE_DIR}/${file}.doc > ${file}.tex
      DEPENDS ${file}.doc)
endfunction()

function(pkg_doc pkg)
  set(pldoc)
  set(docfiles)
  set(mode)
  set(texfiles)

  foreach(arg ${ARGN})
    if(arg STREQUAL "SOURCES")
      set(mode sources)
    else()
      if(arg MATCHES ".*\\.pl")
        set(pldoc ${pldoc} ${arg})
      elseif(arg MATCHES ".*\\.doc")
        set(docfiles ${docfiles} ${arg})
      endif()
    endif()
  endforeach()

  foreach(d ${pldoc})
    string(REPLACE ".pl" ".tex" tex ${d})
    string(REPLACE "_" "" tex ${tex})
    set(texfiles ${texfiles} ${tex})
    get_filename_component(base ${d} NAME_WE)
    add_custom_command(
	OUTPUT ${tex}
	COMMAND ${PLTOTEX} "\"library('${base}')\""
	DEPENDS ${d})
  endforeach()

  foreach(d ${docfiles})
    string(REPLACE ".doc" "" base ${d})
    string(REPLACE ".doc" ".tex" tex ${d})
    set(texfiles ${texfiles} ${tex})
    doc2tex(${base})
  endforeach()

  doc2tex(${pkg})

  tex_byproducts(${pkg} byproducts)

  add_custom_command(
      OUTPUT ${pkg}.pdf ${byproducts}
      COMMAND ${RUNTEX} --pdf ${pkg}
      DEPENDS ${pkg}.tex ${texfiles}
      COMMENT "Generating ${pkg}.pdf")

  add_custom_target(
      ${pkg}.doc.pdf
      DEPENDS ${pkg}.pdf)

  add_custom_command(
      OUTPUT ${pkg}.html
      COMMAND ${LATEX2HTML} ${pkg}
      DEPENDS ${pkg}.tex ${texfiles})

  add_custom_target(
      ${pkg}.doc.html
      DEPENDS ${pkg}.html)

  add_dependencies(doc ${pkg}.doc.pdf ${pkg}.doc.html)

  if(INSTALL_DOCUMENTATION)
    if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${pkg}.html)
      install(FILES ${pkg}.html
	      DESTINATION ${SWIPL_INSTALL_PREFIX}/doc/packages/)
    else()
      install(FILES ${pkg}.html
	      DESTINATION ${SWIPL_INSTALL_PREFIX}/doc/packages/)
    endif()
  endif()
endfunction()
