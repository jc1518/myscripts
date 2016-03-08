#!/bin/bash
#
# This script updates the given puppet tags on hosts listed in the file
# V1.0 20140731 root/password version

boldecho()
{
    echo -e "\033[1m$@\033[0m" 
}

# Check the syntax
if [[ $1 == "help" || $1 == "" || $2 == "" ]];
then
 echo ""
 boldecho "Usage: update-puppet-tags-root.sh <file> <tag>"   
 echo "Mandatory arguments:"
 echo " file: keeps the server list"
 echo " tag: specifies the tag that you want to apply"
 echo "Example:"
 echo "  ./update-puppet-tags-root.sh host sys_common::cron"
 echo ""
 exit
fi

echo "Please type your root password:"
read -s rootpwd

# Dry run to verify the change that is going to happen
# Only test it against the first host
guineapig=$(head -1 $1)
sshpass -p "$rootpwd" ssh -oStrictHostKeyChecking=no -t root@$guineapig "puppetd --test --tags $2 --noop"
echo ""
boldecho "Does it look right to you? [Yes or No]"
read answer

case "$answer" in

Yes|YES|yes|Y|y)
 echo "Start to apply the change to all hosts..."
 for host in $(cat $1)
 do
  echo "Applying change to $host..."
  sshpass -p "$rootpwd" ssh -oStrictHostKeyChecking=no -t root@$host "puppetd --test --tags $2"
 done
;;

*)
 echo "Exiting..."
 exit
;;

esac


 
  
  

