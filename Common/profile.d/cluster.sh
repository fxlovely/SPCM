
# Set prompt to show more than just "login" for a host like
# login.avi.hpc.uwm.edu
first_two=`hostname | awk -F '.' ' { printf("%s.%s",$1,$2); }'`
PS1="[\u@$first_two \W] \!: "

# Useful shortcuts
alias f=finger
alias dir='ls -als'

if shopt -q login_shell; then
    cluster-pw-check
fi
