#!/bin/bash

########################################
# Default settings
########################################

network="192.168.1.1"
ssh_port="22"
ssh_user="root"
ssh_args="-o StrictHostKeyChecking=no -o BatchMode=yes"
outfile="/var/tmp/scan.out"

########################################
# Read inventory
########################################

inventory=`cat ~/.ansible.cfg \
  | grep "^inventory" \
  | awk -F'=' '{print $2}'`

ignore=`dirname ${inventory}`"/ignore"

########################################
# Perform a scan
########################################

if [[ $1 != "--skip-scan" ]]; then
  nmap -p ${ssh_port} ${network}-100 -oG ${outfile}
fi

for host in `cat ${outfile} \
  | egrep '.*?(Ports:).*?(ssh)' \
  | awk -F' ' '{print $2}'`; do

  [[ -n `cat ${ignore} \
     | awk -F' ' '{print $1}' \
     | egrep "^${host}$"` ]] && continue

  if [[ -z `cat ${inventory} | egrep "^${host}$"` ]]; then
    echo "trying ssh to ${host}..."
    ssh ${ssh_args} -l ${ssh_user} ${host} uptime
    if [[ $? == 0 ]]; then
      echo ${host} >> ${inventory}
    fi
  fi

done

rm -f ${outfile}

exit 0

