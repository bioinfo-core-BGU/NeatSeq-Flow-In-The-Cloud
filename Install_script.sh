# Script for easy installation of NeatSeq-Flow and it's GUI with conda 
# Will install conda and all required packages into a dedicated directory ('miniconda3') inside the current directory.
# Written by Menachem Sklarz, 4/2/19
#!/bin/bash

USAGE="USAGE: sh Install_script.sh [setup_conda|setup_sge] user\n\n

setup_conda Will install conda and NeatSeq-Flow Environment including it's GUI.\n

setup_sge   Will setup the SGE needed parameters and install firefox [You must run this option as a root user!!]


"
set -eu


if [ $# == 0 ]; then
    echo -e $USAGE
    exit
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo -e $USAGE
    exit
fi


if [ "$1" == "setup_conda" ]; then
    # Make a directory for conda installation
    mkdir miniconda3; cd miniconda3;
    # Download and execute conda installer into current directory:
    curl -LO https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
    CURRENT_DIR=$(readlink -f .)
    sh Miniconda3-latest-Linux-x86_64.sh -b -f -p $CURRENT_DIR
    PREFIX="$CURRENT_DIR/bin"
    CONDA_DIR=$CURRENT_DIR
    echo "Adding miniconda to path in .bashrc"
    echo export PATH=\"$PREFIX:\$PATH\" >> $HOME/.bashrc
    
    # Add current directory to path
    PATH="$PREFIX:$PATH"

    # Install git
    conda install -y -c anaconda git


    # Get NeatSeq_Flow installer and create environment:
    curl -LO http://neatseq-flow.readthedocs.io/en/latest/extra/NeatSeq_Flow_conda_env.yaml
    conda env create --force -p $CONDA_DIR/envs/NeatSeq_Flow -f NeatSeq_Flow_conda_env.yaml

    echo source $PREFIX/activate  NeatSeq_Flow >> $HOME/.bashrc
else
    if [ "$1" == "setup_sge" ]; then
        USER_LIST=USERS
        YOURQ=all.q
        
        if [ "$USER" == "root" ]; then
            if [ $# == 2 ]; then
                YOUR_USER=$2
               
            else
                YOUR_USER=$USER
            fi

             
            #qconf -am sgeadmin
            qconf -am $YOUR_USER
            qconf -au $YOUR_USER $USER_LIST
            echo $USER
            qconf -aattr queue user_lists $USER_LIST  $YOURQ
            qconf -Ap /dev/stdin <<<'
pe_name            shared
slots              999
user_lists         NONE
xuser_lists        NONE
start_proc_args    NONE
stop_proc_args     NONE
allocation_rule    $pe_slots
control_slaves     FALSE
job_is_first_task  TRUE
urgency_slots      min
accounting_summary FALSE
qsort_args         NONE'

            qconf -rattr queue load_thresholds NONE  $YOURQ
            qconf -aattr queue pe_list shared $YOURQ
            
            yum install -y firefox
            yum install -y dbus-x11
        else
            echo  "You Must be a root user to run this script"
        fi 
    else
        echo -e $USAGE
    fi 
fi 