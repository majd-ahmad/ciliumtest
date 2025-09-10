clear
    2  ip route | grep default | awk '{ print $9 }'
    3  PRIMARY_IP=172.16.0.5
    4  POD_CIDR=10.244.0.0/16
    5  SERVICE_CIDR=10.96.0.0/16
    6  {     sudo apt-get update;     sudo apt-get install -y apt-transport-https ca-certificates curl; }
    7  {
    8      cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
    9  overlay
   10  br_netfilter
   11  EOF
   12        sudo modprobe overlay;     sudo modprobe br_netfilter; } 
   13  {
   14      cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
   15  net.bridge.bridge-nf-call-iptables  = 1
   16  net.bridge.bridge-nf-call-ip6tables = 1
   17  net.ipv4.ip_forward                 = 1
   18  EOF
   19        sudo sysctl --system; }
   20  sudo apt-get install -y containerd
   21  {     sudo mkdir -p /etc/containerd;     containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sudo tee /etc/containerd/config.toml; }
   22  sudo systemctl restart containerd
   23  KUBE_LATEST=$(curl -L -s https://dl.k8s.io/release/stable.txt | awk 'BEGIN { FS="." } { printf "%s.%s", $1, $2 }')
   24  {     sudo mkdir -p /etc/apt/keyrings;     curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBE_LATEST}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg; }
   25  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBE_LATEST}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
   26  {     sudo apt-get update;     sudo apt-get install -y kubelet 
kubeadm kubectl;     sudo apt-mark hold kubelet kubeadm kubectl; }    
   27  sudo crictl config     --set runtime-endpoint=unix:///run/containerd/containerd.sock     --set image-endpoint=unix:///run/containerd/containerd.sock
   28  cat <<EOF | sudo tee /etc/default/kubelet
   29  KUBELET_EXTRA_ARGS='--node-ip ${PRIMARY_IP}'
   30  EOF
