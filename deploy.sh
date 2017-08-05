#!/usr/bin/env bash

# Check dependencies
which ansible-playbook 2>&1 > /dev/null || exit 1
which git 2>&1 > /dev/null || exit 1

# Run install
ansible-playbook -i "local," -c local deploy.yml
