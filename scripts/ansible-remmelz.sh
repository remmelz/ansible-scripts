#!/bin/bash

tmpfile="/var/tmp/remmelz.yml"
github="https://github.com/remmelz"
repo=$1

if [[ -z ${repo} ]]; then

  echo
  echo "Usage: $0 <repo> (--download-only)"
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

[[ $2 == "--download-only" ]] && exit 1

echo "  - name: ${repo}" > ${tmpfile}
echo "    hosts: all"   >> ${tmpfile}
echo "    roles:"       >> ${tmpfile}
echo "      - ${repo}"  >> ${tmpfile}

ansible-playbook -c local -i '127.0.0.1,' ${tmpfile}

rm -f ${tmpfile}
exit 0
