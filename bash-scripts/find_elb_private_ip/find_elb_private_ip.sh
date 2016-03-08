#!/bin/bash

PROFILE=""

aws $PROFILE ec2 describe-network-interfaces --filters "Name=description,Values=ELB*" |  jq -r '.NetworkInterfaces[] | "NAME: \(.Description) INTERFACE: \(.NetworkInterfaceId) IP: \(.PrivateIpAddress)"'

