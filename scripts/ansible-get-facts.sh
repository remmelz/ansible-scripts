#!/bin/bash


category=$1
factsdir="/var/tmp/ansible.facts"

if [[ -z $1 ]]; then
  echo "Usage: $0 <host category>"
  exit 1
fi

ansible ${category} \
  -m setup \
  --tree ${factsdir} 

ls ${factsdir}

