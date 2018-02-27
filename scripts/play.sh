#!/bin/bash

runyml="./tests/run.yml"

if [[ -f ${runyml} ]]; then
  ansible-playbook $1 ${runyml}

elif [[ -d ~/$1 ]]; then
  cd ~/$1
  ansible-playbook ${runyml}
fi

exit 0


