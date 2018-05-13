#!/bin/bash

github="https://github.com/remmelz"
repo=$1

if [[ -z ${repo} ]]; then

  echo
  echo "Usage: $0 <repo>"
  echo
  echo "Repository list"
  echo "---------------"
  curl -s "${github}/?tab=repositories" \
    | grep "ansible" | grep "href" \
    | awk -F'"' '{print $2}' \
    | awk -F'/' '{print $3}' \
    | sort
  echo
  exit 1

fi

rpm -q ansible >> /dev/null
[[ $? != 0 ]] && zypper -n in ansible
rpm -q git >> /dev/null
[[ $? != 0 ]] && zypper -n in git

cd /etc/ansible/roles || exit 1

if [[ ! -d ${repo} ]]; then
  git clone ${github}/${repo}.git
  cd ${repo} || exit 1
else
  cd ${repo} || exit 1
  git pull
fi

echo "  - name: ${repo}" > ./run.yml
echo "    hosts: all"   >> ./run.yml
echo "    roles:"       >> ./run.yml
echo "      - ${repo}"  >> ./run.yml

ansible-playbook -c local \
  -i '127.0.0.1,' ./run.yml

rm -f ./run.yml
exit 0

