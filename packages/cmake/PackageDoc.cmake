include(Documentation)

set(SWIPL      ${CMAKE_INSTALL_PREFIX}/bin/swipl)
set(LATEX2HTML ${CMAKE_INSTALL_PREFIX}/lib/swipl/bin/latex2html ${DOC_OPTIONS})
set(DOC2TEX    ${SWIPL_ROOT}/man/doc2tex)
set(RUNTEX     ${SWIPL_ROOT}/man/runtex ${DOC_OPTIONS})
set(PLTOTEX    ${SWIPL} ${SWIPL_ROOT}/packages/pltotex.pl --)

function(doc2tex file)
  string(REPLACE ".doc" "" file ${file})
  set(texfiles ${texfiles} ${file}.tex PARENT_SCOPE)
  add_custom_command(
      OUTPUT ${file}.tex
      COMMAND ${DOC2TEX} ${CMAKE_CURRENT_SOURCE_DIR}/${file}.doc > ${file}.tex
      DEPENDS ${file}.doc)
endfunction()

# pldoc file.pl [out.tex] [library(lib)]

function(pldoc file)
  set(tex)
  set(lib)

  foreach(arg ${ARGN})
    if(arg MATCHES ".*\\.tex")
      set(tex ${arg})
    elseif(arg MATCHES "library")
      set(lib "\"${arg}\"")
    endif()
  endforeach()

  if(NOT tex)
    string(REPLACE ".pl" ".tex" tex ${file})
    string(REPLACE "_" "" tex ${tex})
  endif()

  if(NOT lib)
    get_filename_component(base ${file} NAME_WE)
    set(lib "\"library('${base}')\"")
  endif()

  get_filename_component(base ${file} NAME_WE)
  add_custom_command(
      OUTPUT ${tex}
      COMMAND echo "--out=${tex} ${lib}"
      COMMAND ${PLTOTEX} --out=${tex} ${lib}
      DEPENDS ${file})

  set(texfiles ${texfiles} ${tex} PARENT_SCOPE)
endfunction()

function(flush_src)
  if(src)
    pldoc(${src})
  endif()
  set(src "" PARENT_SCOPE)
  set(texfiles ${texfiles} PARENT_SCOPE)
endfunction()

# pkg_doc(pkg
#	  [ SOURCE file.pl [out.tex] [library(...)] ]*
#	  [ SOURCES file.pl file.doc ... ])

function(pkg_doc pkg)
  set(pldoc)
  set(docfiles)
  set(mode)
  set(texfiles)
  set(src)

  foreach(arg ${ARGN})
    if(arg STREQUAL "SOURCES")
      flush_src()
      set(mode sources)
    elseif(arg STREQUAL "SOURCE")
      flush_src()
      set(mode source)
      set(src)
    elseif(mode STREQUAL "source")
      set(src ${src} ${arg})
    else()
      if(arg MATCHES ".*\\.pl")
        pldoc(${arg})
      elseif(arg MATCHES ".*\\.doc")
        doc2tex(${arg})
      endif()
    endif()
  endforeach()
  flush_src()

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
