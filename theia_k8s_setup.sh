
docker exec -ti -u root theia apk add --no-cache bash curl wget docker zsh git vim openssl

docker exec -ti -u root theia bash -c "grep -qxF 'docker' /etc/group || addgroup -g 998 docker"
docker exec -ti -u root theia bash -c "groups theia |grep docker || addgroup theia docker"
docker exec -ti -u root theia bash -c "groups theia |grep root || addgroup theia root"
docker exec -ti -u root theia bash -c "sed -i 's/docker:x:101:theia/docker:x:998:theia/g' /etc/group"
docker exec -ti theia bash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
docker exec -ti theia bash -c "sed -i 's/robbyrussell/xiong-chiamiov-plus/g' /home/theia/.zshrc"
docker exec -ti theia bash -c "echo 'alias ll=\"ls -lah\"' >> /home/theia/.zshrc"

docker exec -ti theia ssh-keygen -t rsa -b 4096 -C "shokohsc@gmail.com"

docker exec -ti theia eval "$(ssh-agent -s)"

docker exec -ti theia ssh-add ~/.ssh/id_rsa

docker exec -ti theia cat /home/theia/.ssh/id_rsa.pub
docker exec -ti theia git config --global user.email "shokohsc@gmail.com"
docker exec -ti theia git config --global user.name "shokohsc"

docker exec -ti theia git clone git@github.com:shokohsc/kind-test.git

docker exec -ti theia wget https://github.com/kubernetes-sigs/kind/releases/download/v0.7.0/kind-linux-amd64
docker exec -ti theia chmod +x kind-linux-amd64
docker exec -ti -u root theia mv /home/theia/kind-linux-amd64 /usr/bin/kind
docker exec -ti theia curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
docker exec -ti theia chmod +x ./kubectl
docker exec -ti -u root theia mv /home/theia/kubectl /usr/bin/kubectl
docker exec -ti theia wget https://github.com/derailed/k9s/releases/download/v0.19.1/k9s_Linux_x86_64.tar.gz
docker exec -ti theia tar xzf k9s_Linux_x86_64.tar.gz
docker exec -ti -u root theia mv /home/theia/k9s /usr/bin/k9s
docker exec -ti theia bash -c "grep xterm-256color /home/theia/.zshrc || echo 'export TERM=xterm-256color' >> /home/theia/.zshrc"
docker network connect bridge theia

docker exec -ti theia kind create cluster
docker network connect seedbox_connected kind-control-plane
docker network connect seedbox_connected kind-control-plane2
docker network connect seedbox_connected kind-worker
export kubernetes=$(docker exec kind-external-load-balancer awk 'END{print $1}' /etc/hosts)
docker exec -e kubernetes=$kubernertes -ti -u root theia bash -c "echo $kubernetes  kubernetes >> /etc/hosts"
docker exec -ti theia bash -c "sed -i 's/127.0.0.1/kubernetes/g' /home/theia/.kube/config"
