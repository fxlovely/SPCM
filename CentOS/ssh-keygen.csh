# Generated by cluster-setup
if ( ! -f ~/.ssh/id_rsa ) then
    ssh-keygen -f ~/.ssh/id_rsa -N ""
endif

if ( ! -f ~/.ssh/authorized_keys ) then
    cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
endif

chmod 700 ~/.ssh

