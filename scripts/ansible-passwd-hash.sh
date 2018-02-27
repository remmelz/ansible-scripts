#!/bin/bash
##
##  Description: 
##
##    Usefull for generating a hashed password in Ansible.
##   

python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.using(rounds=5000).hash(getpass.getpass())"
