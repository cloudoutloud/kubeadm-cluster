#!/bin/bash
# This script is to be run on all nodes that require to be part of the kubernetes cluster

#Disable swap
echo 'Disabling swap'
sed -i '/swap/d' /etc/fstab
swapoff -a

#Disable SElinux
echo 'Disabling SElinux'
setenforce 0
sed -i 's/enforcing/disabled/g' /etc/selinux/config   
grep disabled /etc/selinux/config | grep -v '#'

#Yum update
echo 'Yum updating, please wait may take some time'
yum update -y >/dev/null 2>&1

#install docker container runtime engine
echo 'Installing docker container engine'
yum install -y docker >/dev/null 2>&1
systemctl start docker >/dev/null 2>&1 
systemctl enable docker >/dev/null 2>&1

#Allowing vagrant user to use docker
echo 'Adding vagrant user to docker group'
export USER=vagrant
groupadd docker
usermod -aG docker $USER

#Add k8's repo
echo 'Adding k8 repo'
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

#Install/start kubelet kubeadm kubectl
echo 'Installing and starting kubeadm, kubectl and kubelet'
yum install -y kubeadm kubelet kubectl --disableexcludes=kubernetes >/dev/null 2>&1
systemctl enable kubelet && systemctl start kubelet >/dev/null 2>&1

#Add sysctl settings RHEL/centos7 
echo 'Adding sysctl settings'
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

#Add net-tools for networking troubleshooting
echo 'Adding net-tools'
yum install -y net-tools >/dev/null 2>&1





