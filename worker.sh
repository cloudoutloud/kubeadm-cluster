#!/bin/bash

use scp to retrive bootstrap file from master node


#Add route to worker nodes for weaveworks
ip route add 10.96.0.1/32 dev eth1
cat <<EOF >/etc/sysconfig/network-scripts/route-eth1
10.96.0.1/32 via 192.168.0.1/32 dev eth1
EOF
service network restart

#Rebooting node
echo 'Setup complete rebooting node...'
sleep 10 && reboot