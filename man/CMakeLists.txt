cmake_minimum_required(VERSION 2.8.12)
project(swipl-doc-core)

set(LIBTOTEX ${CMAKE_INSTALL_PREFIX}/bin/swipl libtotex.pl --)

set(DOC SWI-Prolog-${SWIPL_VERSION_STRING})

set(TEX_LIB library.tex readutil.tex wwwbrowser.tex registry.tex
    check.tex url.tex debug.tex lists.tex bounds.tex clpqr.tex gensym.tex
    nbset.tex libsummary.tex prologpack.tex assoc.tex assoclib.tex
    prologxref.tex ugraphs.tex ordsets.tex broadcast.tex record.tex
    clpfd.tex clpfdlib.tex pairs.tex option.tex main.tex apply.tex
    aggregate.tex threadpool.tex pio.tex pureinput.tex charsio.tex shlib.tex
    csv.tex optparse.tex clpb.tex clpblib.tex predicateoptions.tex
    predopts.tex random.tex varnumbers.tex quasiquotations.tex
    solutionsequences.tex iostream.tex persistency.tex yall.tex error.tex
    simplex.tex simplexlib.tex dicts.tex)
prepend(TEX_LIB lib/ ${TEX_LIB})

set(TEXFILES ${DOC}.tex intro.tex overview.tex builtin.tex module.tex
    foreign.tex runtime.tex hack.tex summary.tex xpce.tex glossary.tex
    ide.tex license.tex threads.tex engines.tex profile.tex
    attvar.tex chr.tex xref.tex bit64.tex dialect.tex extensions.tex
    tabling.tex)

set(STYFILES html.sty txt.sty)

foreach(f ${TEXFILES})
    string(REGEX REPLACE "\\.tex" ".doc" docin ${f})
    add_custom_command(
	OUTPUT ${f}
	COMMAND ./doc2tex ${docin} > ${f}
	DEPENDS ${docin}
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endforeach()

# pldoc(tex input
#	[OPTIONS ...]
#	[DEPENDS ...]

function(pldoc tex input)
    set(options)
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
	OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/${tex}
	COMMAND ${LIBTOTEX} ${options} "'${input}'"
	DEPENDS ${depends}
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endfunction()

function(libdoc lib)
  pldoc(lib/${lib}.tex "library(${lib})" ${ARGN})
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
pldoc(lib/predopts.tex lib/predopts.txt
      OPTIONS --lib=predicate_options
      DEPENDS lib/predopts.txt ../library/predicate_options.pl)

add_custom_command(
    OUTPUT ${DOC}.pdf
    COMMAND env TEXINPUTS=lib:$$TEXINPUTS ./runtex --pdf ${DOC}
    DEPENDS ${TEXINPUTS} ${TEX_LIB}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_target(
    doc
    DEPENDS ${DOC}.pdf)

#set(LIBS apply.tex dicts.tex shlib.tex assoclib.tex)
#set(LIBS clpblib.tex clpfdlib.tex)
prepend(LIBS ${CMAKE_CURRENT_SOURCE_DIR}/ ${TEX_LIB})

add_custom_target(
    try
    DEPENDS ${LIBS})
