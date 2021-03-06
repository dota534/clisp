dnl -*- Autoconf -*-
dnl Copyright (C) 2002-2008, 2010 Sam Steingold, Bruno Haible
dnl This file is free software, distributed under the terms of the GNU
dnl General Public License.  As a special exception to the GNU General
dnl Public License, this file may be distributed as part of a program
dnl that contains a configuration script generated by Autoconf, under
dnl the same distribution terms as the rest of that program.

AC_PREREQ(2.57)

AC_DEFUN([CL_READLINE],[dnl
AC_ARG_WITH([readline],
AC_HELP_STRING([--with-readline],[use readline (default is YES, if present)]),
[ac_cv_use_readline=$withval], [ac_cv_use_readline=default])
ac_cv_have_readline=no
if test "$ac_cv_use_readline" = "no" ; then
AC_MSG_NOTICE([not checking for readline])
else
AC_REQUIRE([CL_TERMCAP])dnl
if test $ac_cv_search_tgetent != no ; then
 AC_LIB_LINKFLAGS_BODY(readline)
 ac_save_CPPFLAGS="$CPPFLAGS"
 CPPFLAGS="$CPPFLAGS $INCREADLINE"
 AC_CHECK_HEADERS(readline/readline.h)
 if test "$ac_cv_header_readline_readline_h" != yes; then
  CPPFLAGS="$ac_save_CPPFLAGS"
 else # have <readline/readline.h> => check library
  ac_save_LIBS="$LIBS"
  LIBS="$LIBREADLINE $LIBS"
  AC_CHECK_FUNC(readline)dnl do not define HAVE_READLINE
  AC_CHECK_FUNCS(rl_filename_completion_function)
  if test "$ac_cv_func_readline" != yes ; then
    LIBS="$ac_save_LIBS"
    CPPFLAGS="$ac_save_CPPFLAGS"
  else # have readline => check modern features
    if test $ac_cv_func_rl_filename_completion_function = no ;
    then RL_FCF=filename_completion_function
    else RL_FCF=rl_filename_completion_function
    fi
    dnl READLINE_CONST is necessary for C++ compilation of stream.d
    CL_PROTO([filename_completion_function], [
      CL_PROTO_CONST([
#include <stdio.h>
#include <readline/readline.h>
      ],[char* ${RL_FCF} (char *, int);],
      cl_cv_proto_readline_const) ],
      [extern char* ${RL_FCF}($cl_cv_proto_readline_const char*, int);])
    AC_CHECK_DECLS([rl_already_prompted, rl_readline_name, dnl
rl_gnu_readline_p, rl_deprep_term_function],,,
[#include <stdio.h>
#include <readline/readline.h>])
    AC_MSG_CHECKING(for a modern readline)
    if test "$ac_cv_have_decl_rl_already_prompted" = yes \
         -a "$ac_cv_have_decl_rl_gnu_readline_p" = yes; then
      dnl LIBREADLINE has been added to LIBS.
      AC_MSG_RESULT([found a modern GNU readline])
      ac_cv_have_readline=yes
    else
      AC_MSG_RESULT([readline is too old and will not be used])
      LIBS="$ac_save_LIBS"
      CPPFLAGS="$ac_save_CPPFLAGS"
    fi
  fi
 fi
fi
if test "$ac_cv_have_readline" = yes; then
  AC_DEFINE_UNQUOTED(READLINE_FILE_COMPLETE,${RL_FCF},[The readline built-in filename completion function, either rl_filename_completion_function() or filename_completion_function()])
  AC_DEFINE_UNQUOTED(READLINE_CONST,$cl_cv_proto_readline_const,[declaration of filename_completion_function() needs const in the first argument])
  AC_DEFINE(HAVE_READLINE,,[have a working modern GNU readline])
elif test "$ac_cv_use_readline" = yes; then
  AC_MSG_FAILURE([despite --with-readline, GNU readline was not found (try --with-libreadline-prefix)])
fi
fi
])
