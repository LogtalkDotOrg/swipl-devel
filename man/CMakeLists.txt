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

function(pldoc tex dep input)
    add_custom_command(
	OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/${tex}
	COMMAND ${LIBTOTEX} ${ARGN} "'${input}'"
	DEPENDS ${dep}
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endfunction()

pldoc(lib/shlib.tex ../library/shlib.pl "library(shlib)" --subsection)

add_custom_command(
    OUTPUT ${DOC}.pdf
    COMMAND env TEXINPUTS=lib:$$TEXINPUTS ./runtex --pdf ${DOC}
    DEPENDS ${TEXINPUTS} ${TEX_LIB})

add_custom_target(
    doc
    DEPENDS ${DOC}.pdf)

add_custom_target(
    try
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/lib/shlib.tex)
