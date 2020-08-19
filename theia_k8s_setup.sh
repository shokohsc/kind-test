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

docker exec -ti -u root kind-control-plane sh -c "echo 'nameserver 10.96.0.10' >> /etc/resolv.conf"
docker exec -ti -u root kind-control-plane2 sh -c "echo 'nameserver 10.96.0.10' >> /etc/resolv.conf"
docker exec -ti -u root kind-worker sh -c "echo 'nameserver 10.96.0.10' >> /etc/resolv.conf"
