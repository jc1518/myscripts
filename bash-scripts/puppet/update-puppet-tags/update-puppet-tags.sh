#!/bin/bash
#
# This script updates the given puppet tags on hosts listed in the file
# V1.0 20140731  

boldecho()
{
    echo -e "\033[1m$@\033[0m" 
}

# Check the syntax
if [[ $1 == "help" || $1 == "" || $2 == "" ]];
then
 echo ""
 boldecho "Usage: update-puppet-tags.sh <file> <tag>"   
 echo "Mandatory arguments:"
 echo " file: keeps the server list"
 echo " tag: specifies the tag that you want to apply"
 echo "Example:"
 echo "  ./update-puppet-tags.sh prodhost sys_common::cron"
 echo ""
 exit
fi

# Dry run to verify the change that is going to happen
# Only test it against the first host
guineapig=$(head -1 $1)
ssh -t $guineapig "sudo su - -c \"puppetd --test --tags $2 --noop\""
echo ""
boldecho "Does it look right to you? [Yes or No]"
read answer

case "$answer" in

Yes|YES|yes|Y|y)
 echo "Start to apply the change to all hosts..."
 for host in $(cat $1)
 do
  echo "Applying change to $host..."
  ssh -t $host "sudo su - -c \"puppetd --test --tags $2\""
 done
;;

*)
 echo "Exiting..."
 exit
;;

esac


 
  
  

