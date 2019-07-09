#!/bin/bash

#Set up master node 
echo 'Initialize master node, please wait may take some time'
kubeadm init --image-repository registry.aliyuncs.com/google_containers --apiserver-advertise-address=192.168.0.30

#Make .kube dir for vagrant user
echo 'Adding .kube dir for user'
mkdir -p /home/vagrant/.kube
  sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
  sudo chown -R vagrant:vagrant /home/vagrant/.kube/config

#Make .kube dir for root user
echo 'Adding .kube dir for root'
mkdir -p /root/.kube
  sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config

#Deploy pod network weavenet
echo 'Deploying Weavenet CNI'
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')" >/dev/null 2>&1

#Bootstrap token
echo 'Creating worker bootstrap token'
kubeadm token create --print-join-command > /bootstrap_token.sh 
echo 'Master node set up'

#Add kubectl alias to vagrant user .bashrc file
echo 'Adding kubectl alias to bashrc'
cat <<EOF > /home/vagrant/.bashrc
#.bashrc
#Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
#Uncomment the following line if you don't like systemctl's auto-paging feature:
#export SYSTEMD_PAGER=
#User specific aliases and functions
alias k='kubectl'
alias kg='kubectl get'
alias kgpo='kubectl get po'
alias kgn='kubectl get nodes'
alias kd='kubectl describe'
alias krm='kubectl delete'
alias krmf='kubectl delete -f'
alias kc='kubectl create -f'
alias ka='kubectl apply -f'
alias kl='kubectl logs'
EOF
source ~/.bashrc

#Rebooting node
echo 'Setup complete rebooting node...'
sleep 10 && reboot