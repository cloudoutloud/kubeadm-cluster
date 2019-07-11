#!/bin/bash

# Join worker nodes to the cluster
echo "Joining worker node to cluster, may take some time.."
yum install -q -y sshpass >/dev/null 2>&1
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no 192.168.0.30:/bootstrap_token.sh /bootstrap_token.sh 2>/dev/null
bash /bootstrap_token.sh >/dev/null 2>&1

#Add route to worker nodes for weaveworks
ip route add 10.96.0.1/32 dev eth1
cat <<EOF >/etc/sysconfig/network-scripts/route-eth1
10.96.0.1/32 via 192.168.0.1/32 dev eth1
EOF
service network restart

#Rebooting node
echo 'Setup complete rebooting node...'
sleep 10 && reboot