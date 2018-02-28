#!/bin/bash

runyml="./tests/run.yml"

if [[ -f ${runyml} ]]; then
  ansible-playbook $1 $2 $3 $4 ${runyml}

elif [[ -d ~/$1 ]]; then
  cd ~/$1
  ansible-playbook $1 $2 $3 $4 ${runyml}
fi

exit 0

