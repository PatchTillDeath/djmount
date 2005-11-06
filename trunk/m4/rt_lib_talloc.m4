dnl
dnl @synopsis RT_LIB_TALLOC([ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
dnl
dnl This macro will check for the existence of the talloc library
dnl (http://talloc.samba.org/). 
dnl
dnl It does this by checking for the header file talloc.h and the talloc 
dnl library object file. A --with-talloc-prefix=DIR option is supported 
dnl as well, to search for talloc in DIR/include and DIR/lib .
dnl
dnl The following output variables are set with AC_SUBST: 
dnl 
dnl	TALLOC_CPPFLAGS
dnl	TALLOC_LDFLAGS
dnl 	TALLOC_LIBS
dnl
dnl You can use them like this in Makefile.am: 
dnl
dnl	AM_CPPFLAGS   = $(TALLOC_CPPFLAGS)
dnl	AM_LDFLAGS    = $(TALLOC_LDFLAGS)
dnl	program_LDADD = $(TALLOC_LIBS)
dnl
dnl Additionally, the C preprocessor symbol HAVE_TALLOC will be defined 
dnl with AC_DEFINE if talloc is available. 
dnl
dnl @version $Id$
dnl @author R�mi Turboult <r3mi@users.sourceforge.net>
dnl
dnl This file is free software, distributed under the terms of the GNU
dnl General Public License.  As a special exception to the GNU General
dnl Public License, this file may be distributed as part of a program
dnl that contains a configuration script generated by Autoconf, under
dnl the same distribution terms as the rest of that program.
dnl

AC_DEFUN([RT_LIB_TALLOC], [

AH_TEMPLATE([HAVE_TALLOC], [Define if talloc is available])

#
# Add any special lib or include directory
#

AC_ARG_WITH([talloc-prefix], 
	AS_HELP_STRING([--with-talloc-prefix=DIR],
	[search for talloc in DIR/include and DIR/lib]))

AC_MSG_CHECKING([for talloc CPPFLAGS])
if test x"$with_talloc_prefix" != x ; then
	TALLOC_CPPFLAGS="$TALLOC_CPPFLAGS -I$with_talloc_prefix/include"
fi
AC_MSG_RESULT($TALLOC_CPPFLAGS)

AC_MSG_CHECKING([for talloc LDFLAGS])
if test x"$with_talloc_prefix" != x ; then
	TALLOC_LDFLAGS="$TALLOC_LDFLAGS -L$with_talloc_prefix/lib"
fi
AC_MSG_RESULT($TALLOC_LDFLAGS)

TALLOC_LIBS="-ltalloc"

#
# Try linking with talloc library
#

AC_MSG_CHECKING([for talloc library])
AC_LANG_PUSH(C)
ac_save_CPPFLAGS="$CPPFLAGS"
ac_save_LDFLAGS="$LDFLAGS"
ac_save_LIBS="$LIBS"
CPPFLAGS="$CPPFLAGS $TALLOC_CPPFLAGS"
LDFLAGS="$LDFLAGS $TALLOC_LDFLAGS"
LIBS="$LIBS $TALLOC_LIBS"

AC_TRY_LINK([
/* those include are currently missing from "talloc.h" */
#include <stdio.h>
#include <stdlib.h>
#ifdef HAVE_STDARG_H
#  include <stdarg.h>
#else
#  include <varargs.h>
#endif
#include "talloc.h"
], 
[
	(void) talloc_get_size (talloc_autofree_context());
],
[
	talloc_found=yes
],
[
	talloc_found=no

])
CPPFLAGS="$ac_save_CPPFLAGS"
LDFLAGS="$ac_save_LDFLAGS"
LIBS="$ac_save_LIBS"
AC_LANG_POP(C)

AC_MSG_RESULT($talloc_found)
if test x"$talloc_found" = xyes ; then
	AC_DEFINE([HAVE_TALLOC])
     	m4_if([$1], [], [:], [$1])

else
	TALLOC_CPPFLAGS=""
	TALLOC_LDFLAGS=""
	TALLOC_LIBS=""
     	m4_if([$2], [], [:], [$2])
fi

# 
# Now just export out symbols
#

AC_SUBST([TALLOC_CPPFLAGS])
AC_SUBST([TALLOC_LDFLAGS])
AC_SUBST([TALLOC_LIBS])

])


