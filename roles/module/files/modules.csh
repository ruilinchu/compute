#!/bin/csh
# -*- shell-script -*-
########################################################################
#  This is the system wide source file for setting up
#  modules:
#
########################################################################

set MY_NAME="/opt/apps/lmod/lmod/init/cshrc"



if ( ! $?MODULEPATH_ROOT ) then
    if ( $?USER) then
        setenv USER $LOGNAME
    endif

    set UNAME = `uname`
    setenv LMOD_sys             $UNAME
    setenv MODULEPATH_ROOT      "/opt/apps/modulefiles"
    set MODULEPATH_INIT = "/opt/apps/lmod/lmod/init/.modulespath"
    if ( -f $MODULEPATH_INIT ) then
       	foreach str (`cat $MODULEPATH_INIT | sed 's/#.*$//'`)	# Allow end-of-line comments.
	   foreach dir ( $str )
              if ( -d $dir ) then
                 setenv MODULEPATH `/opt/apps/lmod/lmod/libexec/addto --append MODULEPATH $dir`
              endif
           end
	end
    else
       setenv MODULEPATH `/opt/apps/lmod/lmod/libexec/addto --append MODULEPATH $MODULEPATH_ROOT/$LMOD_sys $MODULEPATH_ROOT/Core`
       setenv MODULEPATH `/opt/apps/lmod/lmod/libexec/addto --append MODULEPATH /opt/apps/lmod/lmod/modulefiles/Core`
    endif

    setenv BASH_ENV             "/opt/apps/lmod/lmod/init/bash"

    #
    # If MANPATH is empty, Lmod is adding a trailing ":" so that
    # the system MANPATH will be found
    if ( ! $?MANPATH ) then
      setenv MANPATH :
    endif
    setenv MANPATH `/opt/apps/lmod/lmod/libexec/addto MANPATH /opt/apps/lmod/lmod/share/man`

endif

if ( -f  /opt/apps/lmod/lmod/init/csh  ) then
  source /opt/apps/lmod/lmod/init/csh
endif

# Local Variables:
# mode: shell-script
# indent-tabs-mode: nil
# End:

