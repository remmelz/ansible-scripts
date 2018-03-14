#!/bin/bash

homedir="/home/ansible"
runyml="./tests/run.yml"

if [[ -f ${runyml} ]]; then
  ansible-playbook $1 $2 $3 $4 ${runyml}

elif [[ -d ${homedir}/$1 ]]; then
  cd ${homedir}/$1
  ansible-playbook ${runyml}

fi

exit 0

