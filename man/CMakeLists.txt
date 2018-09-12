cmake_minimum_required(VERSION 2.8.12)
project(swipl-doc-core)

set(SWIPL    ${CMAKE_INSTALL_PREFIX}/bin/swipl)
set(DOC2TEX  ${CMAKE_CURRENT_SOURCE_DIR}/doc2tex)
set(RUNTEX   ${CMAKE_CURRENT_SOURCE_DIR}/runtex)
set(LIBTOTEX ${SWIPL} ${CMAKE_CURRENT_SOURCE_DIR}/libtotex.pl --)

set(DOC SWI-Prolog-${SWIPL_VERSION_STRING})

# Libraries documented in .doc files
set(DOC_LIB assoc.tex broadcast.tex clpb.tex clpfd.tex clpqr.tex gensym.tex
    library.tex libsummary.tex nbset.tex pio.tex predicateoptions.tex
    prologxref.tex readutil.tex record.tex registry.tex simplex.tex
    ugraphs.tex wwwbrowser.tex)
prepend(DOC_LIB lib/ ${DOC_LIB})

# Libraries documented using PlDoc
set(PLDOC_LIB check.tex url.tex debug.tex lists.tex
    prologpack.tex assoclib.tex ordsets.tex clpfdlib.tex pairs.tex
    option.tex main.tex apply.tex aggregate.tex threadpool.tex pureinput.tex
    charsio.tex shlib.tex csv.tex optparse.tex clpblib.tex predopts.tex
    random.tex varnumbers.tex quasiquotations.tex solutionsequences.tex
    iostream.tex persistency.tex yall.tex error.tex simplexlib.tex
    dicts.tex)
prepend(PLDOC_LIB lib/ ${PLDOC_LIB})

set(TEX_LIB ${DOC_LIB} ${PLDOC_LIB})

foreach(f ${PLDOC_LIB})
  string(REGEX REPLACE "\\.tex" ".doc" docin ${f})
  if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${docin})
    message("WARNING: DOC file for ${f}")
  endif()
endforeach()


# Main files
set(DOC_CORE intro.tex overview.tex builtin.tex module.tex
    foreign.tex runtime.tex hack.tex summary.tex xpce.tex glossary.tex
    ide.tex license.tex threads.tex engines.tex profile.tex
    attvar.tex chr.tex xref.tex bit64.tex dialect.tex extensions.tex
    tabling.tex)

set(STYFILES html.sty txt.sty)

function(doc2tex)
  foreach(f ${ARGN})
    string(REGEX REPLACE "\\.tex" ".doc" docin ${f})
    add_custom_command(
	OUTPUT ${f}
	COMMAND ${DOC2TEX} ${CMAKE_CURRENT_SOURCE_DIR}/${docin} > ${f}
	DEPENDS ${docin})
  endforeach()
endfunction()

doc2tex(${DOC_CORE})

# pldoc(tex input
#	[OPTIONS ...]
#	[DEPENDS ...]

function(pldoc tex input)
    set(options --source=${CMAKE_CURRENT_SOURCE_DIR})
    set(depends)

    if(input MATCHES "^library")
      string(REGEX REPLACE "library\\((.*)\\)" "../library/\\1.pl"
	     depends ${input})
    endif()

    foreach(arg ${ARGN})
      if(arg MATCHES "^--")
        set(options ${options} ${arg})
      elseif(arg STREQUAL "DEPENDS")
      elseif(arg STREQUAL "OPTIONS")
      else()
        set(depends ${depends} ${arg})
      endif()
    endforeach()

    add_custom_command(
	OUTPUT  ${tex}
	COMMAND ${LIBTOTEX} ${options} "'${input}'"
	DEPENDS ${depends})
endfunction()

function(libdoc lib)
  string(REGEX REPLACE "_" "" texf ${lib})
  pldoc(lib/${texf}.tex "library(${lib})" ${ARGN})
endfunction()

function(libsdoc)
  foreach(lib ${ARGN})
    libdoc(${lib})
  endforeach()
endfunction()

libsdoc(apply dicts error url pairs option optparse ordsets aggregate
        thread_pool charsio debug csv lists main check random varnumbers
        quasi_quotations solution_sequences iostream persistency yall)
libdoc(shlib --subsection)
libdoc(pure_input --subsection)
libdoc(prolog_pack --section)
pldoc(lib/assoclib.tex lib/assoclib.md
      OPTIONS --lib=assoc --module=assoc
      DEPENDS lib/assoclib.md ../library/assoc.pl)
pldoc(lib/clpblib.tex lib/clpblib.md
      OPTIONS --lib=clpb --module=clpb
      DEPENDS lib/clpblib.md ../library/clp/clpb.pl)
pldoc(lib/clpfdlib.tex lib/clpfdlib.md
      OPTIONS --lib=clpfd --module=clpfd
      DEPENDS lib/clpfdlib.md ../library/clp/clpfd.pl)
pldoc(lib/simplexlib.tex lib/simplexlib.md
      OPTIONS --lib=simplex --module=simplex
      DEPENDS lib/simplexlib.md ../library/clp/simplex.pl)
pldoc(lib/predopts.tex lib/predopts.txt
      OPTIONS --lib=predicate_options
      DEPENDS lib/predopts.txt ../library/predicate_options.pl)

doc2tex(${DOC_LIB})

prepend(TEXFILES ${CMAKE_CURRENT_BINARY_DIR}/ ${DOC}.tex ${DOC_CORE} ${TEX_LIB})
add_custom_command(
    OUTPUT  ${DOC}.pdf
    COMMAND env TEXINPUTS=lib:$$TEXINPUTS ${RUNTEX} --pdf ${DOC}
    DEPENDS ${TEXFILES})

add_custom_command(
    OUTPUT  ${DOC}.doc
    COMMAND ${SWIPL} ${CMAKE_CURRENT_SOURCE_DIR}/select.pl PDF
                     ${CMAKE_CURRENT_SOURCE_DIR}/main.doc > ${DOC}.doc
    DEPENDS main.doc select.pl)
add_custom_command(
    OUTPUT  ${DOC}.tex
    COMMAND ${DOC2TEX} ${DOC}.doc > ${DOC}.tex
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${DOC}.doc)


################
# Targets

add_custom_target(
    doc
    DEPENDS ${DOC}.pdf)

add_custom_target(
    try
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/lib/assoclib.tex)
