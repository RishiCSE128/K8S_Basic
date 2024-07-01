POD_NETWORK_CIDR=$1

if [[ $# -eq 0 ]]; then
    echo 'Error in Arg: Use format "k8s_install X.X.X.X/n"'
    exit
fi

clear
sudo apt -y update #Update your system
sudo apt -y install apt-transport-https ca-certificates curl #Install necessary packages
sudo swapoff -a #disabled swap
sudo sed -i '/swap/d' /etc/fstab #make change permanent 

clear
## install docker 
# uninstall existing docker engine
pkg_list=(docker.io \
     docker-doc \
     docker-compose \
     docker-compose-v2 \
     podman-docker \
     containerd runc)
     
pkg_list=(docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc)
for pkg in ${pkg_list[@]}; do
	sudo apt -y autoremove $pkg; 
done
     
clear

# Add Docker's official GPG key:
sudo apt -y update
clear

sudo apt -y install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

clear
sudo apt -y update
clear

#install the latest version
sudo apt -y install docker-ce \
		    docker-ce-cli \
		    containerd.io \
		    docker-buildx-plugin \
		    docker-compose-plugin
clear
#Start and enable Docker
sudo systemctl status docker
sudo systemctl enable docker

clear
## Install kubeadm, kubelet, and kubectl
#Add Kubernetes' official GPG key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
#Add the Kubernetes repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt -y update
clear

#Install kubeadm, kubelet, and kubectl
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl #Enable the kubelet service before running kubeadm
clear

#prepare system for kubeadm init 
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd

clear
#Initialize the Kubernetes Master Node
##Initialize the Kubernetes control plane
sudo kubeadm init \
	--pod-network-cidr=$POD_NETWORK_CIDR \
	--ignore-preflight-errors=CRI
#Set up the kubeconfig file for the regular user 
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

##Install a Pod Network Add-On
#Install Flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

#verify
clear
kubectl get nodes
kubectl get pods --all-namespaces