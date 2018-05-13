#!/bin/bash

templ=$1
newvm=$2

########################################
# Default settings
########################################

user="root"
hypervisor="192.168.1.100"
inventory="/ansible/inventory/hosts"
boot_wait=25

alive_before="/var/tmp/hosts.alive.before"
alive_after="/var/tmp/hosts.alive.after"

########################################
# Start script
########################################

if [[ -z ${templ} ]]; then
  ssh ${user}@${hypervisor} "virsh list --all"
  exit 1
fi

printf "Collecting list online hosts..."
fping -a -q -g 192.168.1.1 192.168.1.100 | sort -n > ${alive_before}
echo "[done]"

ssh ${user}@${hypervisor} "virt-clone -o ${templ} -n ${newvm} --auto-clone"
ssh ${user}@${hypervisor} "virsh start ${newvm}"

echo "Waiting ${boot_wait} sec for host to bootup..."
c=1; while [[ $c -le ${boot_wait} ]]; do printf '.'; sleep 1; let c=$c+1; done
echo

printf "Collecting list online hosts..."
fping -a -q -g 192.168.1.1 192.168.1.100 | sort -n > ${alive_after}
echo "[done]"

ipaddr=`diff ${alive_before} ${alive_after} | tail -1 | awk -F' ' '{print $2}'`
ssh ${user}@${hypervisor} "virsh desc ${newvm} ip=${ipaddr}"
echo "New host ipaddress: ${ipaddr}"

exit 0


