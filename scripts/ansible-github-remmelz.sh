#!/bin/bash

repo=$1
tmpfile="/var/tmp/remmelz.yml"
github="https://github.com/remmelz"

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
if [[ $? != 0 ]]; then

  which zypper >> /dev/null
  [[ $? == 0 ]] && zypper -n install ansible git
  
  which yum >> /dev/null
  [[ $? == 0 ]] && yum -y install ansible git
fi

[[ ! -d /etc/ansible/roles ]] && mkdir -p /etc/ansible/roles
cd /etc/ansible/roles || exit 1

if [[ ! -d ${repo} ]]; then
  git clone ${github}/${repo}.git
fi

cd ${repo} || exit 1
git pull

[[ $2 == "--download-only" ]] && exit 1

echo "  - name: ${repo}" > ${tmpfile}
echo "    hosts: all"   >> ${tmpfile}
echo "    roles:"       >> ${tmpfile}
echo "      - ${repo}"  >> ${tmpfile}

ansible-playbook -c local -i '127.0.0.1,' ${tmpfile}

rm -f ${tmpfile}
exit 0
