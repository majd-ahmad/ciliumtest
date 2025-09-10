clear
    2  ip route | grep default | awk '{ print $9 }'
    3  PRIMARY_IP=172.16.0.4
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
   23  sudo systemctl status containerd
   24  KUBE_LATEST=$(curl -L -s https://dl.k8s.io/release/stable.txt | awk 'BEGIN { FS="." } { printf "%s.%s", $1, $2 }')
   25  {     sudo mkdir -p /etc/apt/keyrings;     curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBE_LATEST}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg; }
   26  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBE_LATEST}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
   27  {     sudo apt-get update;     sudo apt-get install -y kubelet kubeadm kubectl;     sudo apt-mark hold kubelet kubeadm kubectl; }
   28  sudo crictl config     --set runtime-endpoint=unix:///run/containerd/containerd.sock     --set image-endpoint=unix:///run/containerd/containerd.sock
   29  cat <<EOF | sudo tee /etc/default/kubelet
   30  KUBELET_EXTRA_ARGS='--node-ip ${PRIMARY_IP}'
   31  EOF
   32  POD_CIDR=10.244.0.0/16
   33  SERVICE_CIDR=10.96.0.0/16
   34  sudo kubeadm init --pod-network-cidr $POD_CIDR --service-cidr $SERVICE_CIDR --apiserver-advertise-address $PRIMARY_IP
   35  {     mkdir ~/.kube;     sudo cp /etc/kubernetes/admin.conf ~/.kube/config;     sudo chown $(id -u):$(id -g) ~/.kube/config;     chmod 600 ~/.kube/config; }
   36  kubectl get pods -n kube-system
   37  cilium install --version 1.18.1
   38  CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
   39  CLI_ARCH=amd64
   40  if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
   41  curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
   42  sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
   43  sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
   44  cilium install --version 1.18.1
   45  cilium status --wait
   46  cilium connectivity test
   47  kubectl get pods -n kube-system
   48  kubeadm join 172.16.0.4:6443 --token yx6dpl.r5gup4i4sf9p71l4 \
   49  kubectl get pods -n kube-system
   50  kubectl get nodes
   51  cilium connectivity test
   52  kubectl get nodes
   53  kubectl get nodeskubectl create deployment nginx --image nginx:alpine
   54  kubectl expose deploy nginx --type=NodePort --port 80
   55  PORT_NUMBER=$(kubectl get service -l app=nginx -o jsonpath="{.items[0].spec.ports[0].nodePort}")
   56  kubectl create deployment nginx --image nginx:alpine
   57  kubectl expose deploy nginx --type=NodePort --port 80
   58  PORT_NUMBER=$(kubectl get service -l app=nginx -o jsonpath="{.items[0].spec.ports[0].nodePort}")
   59  echo -e "\n\nService exposed on NodePort $PORT_NUMBER"
   60  curl http://node01:$PORT_NUMBER
   61  curl http://node02:$PORT_NUMBER
   62  kubectl get pods
   63  kubectl edit pod nginx-7977cdf8f5-cv252
   64  kubectl get pods -o
   65  kubectl get pods wide -o
   66  ls
   67  kubectl edit pod nginx-7977cdf8f5-cv252
   68  nano testconfmap.yaml
   69  kubectl apply -f testconfmap.yaml
   70  k
   71  kubectl get dep
   72  kubectl get depl
   73  kubectl get deployments
   74  kubectl get deployment nginx
   75  kubectl edit deployment nginx
   76  kubectl apply -f testconfmap.yaml
   77  kubectl get services
   78  kubectl apply -f testconfmap.yaml
   79  kubectl get deployment nginx
   80  kubectl edit deployment nginx
   81  kubectl delete  deployment nginx
   82  kubectl get deployment nginx
   83  kubectl get deployment
   84  kubectl get deploymentkubectl create deployment nginx --image nginx:alpine
   85  kubectl expose deploy nginx --type=NodePort --port 80
   86  PORT_NUMBER=$(kubectl get service -l app=nginx -o jsonpath="{.items[0].spec.ports[0].nodePort}")
   87  kubectl create deployment nginx --image nginx:alpine
   88  kubectl expose deploy nginx --type=NodePort --port 80
   89  PORT_NUMBER=$(kubectl get service -l app=nginx -o jsonpath="{.items[0].spec.ports[0].nodePort}")
   90  echo -e "\n\nService exposed on NodePort $PORT_NUMBER"
   91  kubectl get deployment nginx
   92  history
