ip route | grep default | awk '{ print $9 }'
PRIMARY_IP=172.16.0.4
POD_CIDR=10.244.0.0/16
SERVICE_CIDR=10.96.0.0/16
{     sudo apt-get update;     sudo apt-get install -y apt-transport-https ca-certificates curl; }
{
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay;     sudo modprobe br_netfilter; }
{
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system; }
sudo apt-get install -y containerd
{     sudo mkdir -p /etc/containerd;     containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sudo tee /etc/containerd/config.toml; }
sudo systemctl restart containerd
sudo systemctl status containerd
KUBE_LATEST=$(curl -L -s https://dl.k8s.io/release/stable.txt | awk 'BEGIN { FS="." } { printf "%s.%s", $1, $2 }')
{     sudo mkdir -p /etc/apt/keyrings;     curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBE_LATEST}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg; }
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBE_LATEST}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
{     sudo apt-get update;     sudo apt-get install -y kubelet kubeadm kubectl;     sudo apt-mark hold kubelet kubeadm kubectl; }
sudo crictl config     --set runtime-endpoint=unix:///run/containerd/containerd.sock     --set image-endpoint=unix:///run/containerd/containerd.sock
cat <<EOF | sudo tee /etc/default/kubelet
KUBELET_EXTRA_ARGS='--node-ip ${PRIMARY_IP}'
EOF
POD_CIDR=10.244.0.0/16
SERVICE_CIDR=10.96.0.0/16
sudo kubeadm init --pod-network-cidr $POD_CIDR --service-cidr $SERVICE_CIDR --apiserver-advertise-address $PRIMARY_IP
{     mkdir ~/.kube;     sudo cp /etc/kubernetes/admin.conf ~/.kube/config;     sudo chown $(id -u):$(id -g) ~/.kube/config;     chmod 600 ~/.kube/config; }
kubectl get pods -n kube-system
cilium install --version 1.18.1
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
cilium install --version 1.18.1
cilium status --wait
cilium connectivity test
kubectl get pods -n kube-system
kubeadm join 172.16.0.4:6443 --token yx6dpl.r5gup4i4sf9p71l4 \
kubectl get pods -n kube-system
kubectl get nodes
cilium connectivity test
