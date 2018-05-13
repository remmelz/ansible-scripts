#!/bin/bash

runyml="tests/run.yml"
roles=`cat ~/.ansible.cfg \
  | sed 's/ //g' \
  | grep "^roles_path" \
  | awk -F'=' '{print $2}'`

if [[ -f ${runyml} ]]; then
  ansible-playbook $1 $2 $3 $4 ${runyml}

elif [[ -z $1 ]]; then

  ls -1 ${roles}

elif [[ -d ${roles}/$1 ]]; then

  cd ${roles}/$1

  if [[ -f ${runyml} ]]; then
    ansible-playbook ${runyml}
  else
    echo "error: could not find ${runyml}"
    exit 1
  fi

fi

exit 0

