KUBEADM CLUSTER

This will set up a 3 node kubernetes cluster using kubeadm https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
It will use centos7 as operating system. 

What will you need installed pre installation:

vagrant - https://www.vagrantup.com/downloads.html
virtual box - https://www.virtualbox.org/wiki/Downloads

To get set up just run:

1. cd to top level repo dir and run 'vagrant up', may take some time for cluster to fully provision.
2. Once all VM's are up you can ssh using 'vagrant ssh <host-name>'
3. To destroy env run 'vagrant destroy'


Networking:
Please note vagrant file will use your own network as a bridge and the following IP's are assigned to the nodes:
192.168.0.30
192.168.0.31
192.168.0.33
Please adjust if needed.
