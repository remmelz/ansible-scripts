#!/bin/bash
##
##  Description: 
##
##    Usefull when having a dynamic environment just like me. It enables/disables
##    the hosts in the inventory file. This will speedup the ansible run 
##    and you don't see anoying error messages.
##   

if [[ ! -f ~/.ansible.cfg ]]; then
  echo "Error: ansible config file not found."
  exit 1
fi

inventory=`cat ~/.ansible.cfg \
  | grep 'inventory' \
  | awk -F'=' '{print $2}' \
  | sed 's/ //g'`

if [[ ! -f ${inventory} ]]; then
  echo "Error: inventory file file not found."
  exit 1
fi

echo "Updating ${inventory} file..."
for host in `cat ${inventory} | grep -v '\['`; do

    host=`echo ${host} | sed "s/#//g"`
    ping -qc1 -W1 ${host} > /dev/null
    if [[ $? != 0 ]]; then
      echo -e "# ${host} \e[31m[offline]\e[0m"
      sed -i "s/^${host}$/#${host}/g" ${inventory}
    else
      echo -e "${host} \e[92m[online]\e[0m"
      sed -i "s/^#${host}$/${host}/g" ${inventory}
    fi
    
done

exit 0

