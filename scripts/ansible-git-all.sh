#!/bin/bash

action=$1

[[ -z $1 ]] && exit 1

cd /ansible/roles

for dir in `ls -1d *`; do
  [[ ! -d ./${dir}/.git ]] && continue
  echo -e "\e[36m**** ${dir} ****\e[0m"
  cd ${dir}
  git ${action}
  echo
  cd ..
done
