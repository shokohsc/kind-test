# Install packages
docker exec -ti -u root theia apk add --no-cache bash curl wget docker zsh git vim openssl unzip
# Config
docker exec -ti -u root theia bash -c "grep -qxF 'docker' /etc/group || addgroup -g 998 docker"
docker exec -ti -u root theia bash -c "groups theia |grep docker || addgroup theia docker"
docker exec -ti -u root theia bash -c "groups theia |grep root || addgroup theia root" 
docker exec -ti -u root theia bash -c "sed -i 's/docker:x:101:theia/docker:x:998:theia/g' /etc/group" 
docker exec -ti theia bash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
docker exec -ti theia bash -c "sed -i 's/robbyrussell/xiong-chiamiov-plus/g' /home/theia/.zshrc" 
docker exec -ti theia bash -c "echo 'alias ll=\"ls -lah\"' >> /home/theia/.zshrc" 
docker exec -ti theia git config --global user.email "shokohsc@gmail.com" 
docker exec -ti theia git config --global user.name "shokohsc" 
docker exec -ti theia wget https://github.com/kubernetes-sigs/kind/releases/download/v0.8.1/kind-linux-amd64 
docker exec -ti -u root theia chmod +x kind-linux-amd64 
docker exec -ti -u root theia mv /home/theia/kind-linux-amd64 /usr/bin/kind 
docker exec -ti theia curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl 
docker exec -ti -u root theia chmod +x ./kubectl 
docker exec -ti -u root theia mv /home/theia/kubectl /usr/bin/kubectl 
docker exec -ti theia wget https://github.com/derailed/k9s/releases/download/v0.19.1/k9s_Linux_x86_64.tar.gz 
docker exec -ti theia tar xzf k9s_Linux_x86_64.tar.gz 
docker exec -ti theia rm k9s_Linux_x86_64.tar.gz 
docker exec -ti -u root theia mv /home/theia/k9s /usr/bin/k9s 
docker exec -ti theia bash -c "grep xterm-256color /home/theia/.zshrc || echo 'export TERM=xterm-256color' >> /home/theia/.zshrc"
docker exec -ti theia wget https://get.helm.sh/helm-v3.2.0-linux-amd64.tar.gz
docker exec -ti theia tar zxf helm-v3.2.0-linux-amd64.tar.gz
docker exec -ti theia rm helm-v3.2.0-linux-amd64.tar.gz
docker exec -ti -u root theia mv linux-amd64/helm /usr/bin/helm
docker exec -ti theia rm -rf linux-amd64
docker exec -ti theia wget https://releases.hashicorp.com/terraform/0.12.25/terraform_0.12.25_linux_amd64.zip
docker exec -ti theia unzip terraform_0.12.25_linux_amd64.zip
docker exec -ti -u root theia mv terraform /usr/bin/terraform
docker exec -ti theia rm terraform_0.12.25_linux_amd64.zip
docker exec -ti theia wget https://github.com/sl1pm4t/k2tf/releases/download/v0.4.1/k2tf_0.4.1_Linux_x86_64.tar.gz
docker exec -ti theia tar xzf k2tf_0.4.1_Linux_x86_64.tar.gz
docker exec -ti -u root theia mv k2tf /usr/bin/k2tf
docker exec -ti theia rm k2tf_0.4.1_Linux_x86_64.tar.gz
docker exec -ti theia wget https://github.com/hashicorp/terraform-provider-kubernetes-alpha/releases/download/0.1.0/terraform-provider-kubernetes-alpha_0.1.0_linux_amd64.zip
docker exec -ti theia unzip terraform-provider-kubernetes-alpha_0.1.0_linux_amd64.zip
docker exec -ti theia cp terraform-provider-kubernetes-alpha ~/.terraform.d/plugins/terraform-provider-kubernetes-alpha
docker exec -ti theia rm -rf terraform-provider-kubernetes-alpha

docker exec -ti theia ssh-keygen -t rsa -b 4096 -C "shokohsc@gmail.com"
docker exec -ti theia eval "$(ssh-agent -s)"
docker exec -ti theia ssh-add ~/.ssh/id_rsa
docker exec -ti theia cat /home/theia/.ssh/id_rsa.pub

docker exec -ti theia kind create cluster
docker network connect kind traefik && \
docker network connect kind theia
export kubernetes=$(docker exec kind-external-load-balancer awk 'END{print $1}' /etc/hosts)
docker exec -e kubernetes=$kubernertes -ti -u root theia bash -c "echo $kubernetes  kubernetes >> /etc/hosts"
docker exec -ti theia mkdir .kube
docker exec -ti theia bash -c "kind get kubeconfig > /home/theia/.kube/config"
docker exec -ti theia bash -c "sed -i 's/127.0.0.1/kubernetes/g' /home/theia/.kube/config"

docker exec -ti -u root kind-control-plane bash -c "apt-get update && apt-get install -y nfs-common"
docker exec -ti -u root kind-control-plane2 bash -c "apt-get update && apt-get install -y nfs-common"
docker exec -ti -u root kind-worker bash -c "apt-get update && apt-get install -y nfs-common"
