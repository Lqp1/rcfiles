#!/usr/bin/env bash

# Check args
if [ -z $1 ] || [ -z $2 ]
then
   echo "USAGE : $0 USER HOME"
   exit 1
fi

if [ ! -d $2 ]
then
   echo "Path $2 does not lead to a directory..."
   exit 2
fi

# Check dependencies
which ansible-playbook 2>&1 > /dev/null || exit 3
which git 2>&1 > /dev/null || exit 3

# Run install
mv -v $2/.zshrc $2/.zshrc.old
ansible-playbook -i "local," -c local --extra-vars "user=$1 home=$2" deploy.yml
