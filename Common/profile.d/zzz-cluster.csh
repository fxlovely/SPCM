#!/bin/csh -ef

##########################################################################
#   Copy this to /etc/profile.d and modify to taste or source it (or
#   a modified copy) from /etc/csh.login or /etc/csh.cshrc.
##########################################################################

# Caution: 
# The line below is modified by install. Be careful not to replace
# %%PREFIX%% with a hard-coded prefix from an installed script.
prefix=%%PREFIX%%

# Set prompt to show more than just "login" for a host like
# login.avi.hpc.uwm.edu
set first_two=`hostname|awk -F '.' ' { printf("%s.%s",$1,$2); }'`
set prompt="[%n@$first_two %c] %h: "

umask 027

# Useful shortcuts
alias f finger
alias dir 'ls -als'

if ( $?prompt2 && (`hostname -s` == login) && \
    -e $prefix/etc/spcm/check-local-password-age ) then
    cluster-pw-check
endif
