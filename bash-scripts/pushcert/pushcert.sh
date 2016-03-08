#!/bin/bash
#
# This script (pushcert.sh) copies user's certificate to target host
# to create passwordless ssh 
# V1.0 20140731

# Install sshpass
echo "Checking the sshpass package for you..."
sudo yum install -y sshpass > /dev/null 2>&1
echo "done"
echo ""

# Check the existence of the key
echo "Checking your local key..."
if [ -f ~/.ssh/*.pub ]; then
 echo "Good, you already have the key :)"
else 
 echo "You don't have the key yet, generating it now..."
 ssh-keygen
fi
echo ""

# Root password to access remote hosts
echo "Please type the root password to access the remote hosts"
echo "Your input will be hidden on the screen"
read -s rootpwd

echo ""
echo "Please type the file that contains the host"
read hostfile
echo ""

# Push the certificate
if [ -f $hostfile ]; then
 for host in $(cat $hostfile)
 do 
  echo "Adding $host certificate to known hosts..."
  ssh-keyscan $host >> ~/.ssh/known_hosts
  echo "done"
  echo ""
  echo "Pushing your pub key to $host..."
  sshpass -p "$rootpwd" ssh-copy-id root@"$host"
 done
else
 echo "Can not find $hostfile"
 exit 1
fi 
