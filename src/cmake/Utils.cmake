# prepend(out prefix ...)
# assign ${out} with all arguments from ... after prepending prefix to
# it.

FUNCTION(PREPEND var prefix)
   SET(listVar "")
   FOREACH(f ${ARGN})
      LIST(APPEND listVar "${prefix}/${f}")
   ENDFOREACH(f)
   SET(${var} "${listVar}" PARENT_SCOPE)
ENDFUNCTION(PREPEND)

FUNCTION(LINK from to)
   get_filename_component(LNTDIR, ${to} DIRECTORY)
   get_filename_component(LNTNAME, ${from} NAME)
   file(RELATIVE_PATH LNLNK ${LNTDIR} ${from})
   message("ln -sf ${LNLNK} ${LNTNAME} in ${LNTDIR}")
   EXECUTE_PROCESS(COMMAND ln -sf ${LNLNK} ${LNTNAME}
		   WORKING_DIRECTORY ${LNTDIR})
ENDFUNCTION(LINK)

# ilink(from to)
# Install ${from} in ${to} using a relative symbolic link

FUNCTION(ILINK from to)
   get_filename_component(LNTDIR ${to} DIRECTORY)
   get_filename_component(LNTNAME ${from} NAME)
   file(RELATIVE_PATH LNLNK ${LNTDIR} ${from})
   install(CODE "EXECUTE_PROCESS(COMMAND ln -sf ${LNLNK} ./${LNTNAME}
		                 WORKING_DIRECTORY ${LNTDIR})")
ENDFUNCTION(ILINK)
