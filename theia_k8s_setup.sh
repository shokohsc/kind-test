docker exec -ti theia ssh-keygen -t rsa -b 4096 -C "shokohsc@gmail.com"
docker exec -ti theia eval "$(ssh-agent -s)"
docker exec -ti theia ssh-add ~/.ssh/id_rsa
docker exec -ti theia cat /home/theia/.ssh/id_rsa.pub

docker network create --subnet 172.19.0.0/16 --gateway 172.19.0.1 kind
docker exec -ti theia kind create cluster --config /home/project/kind/kind.yaml

docker network connect kind traefik && \
docker network connect kind theia
export kubernetes=$(docker exec kind-external-load-balancer awk 'END{print $1}' /etc/hosts)
docker exec -ti -u root theia vi /etc/hosts
docker exec -e kubernetes=$kubernertes -ti -u root theia bash -c "echo $kubernetes  kubernetes >> /etc/hosts"
docker exec -ti theia bash -c "kind get kubeconfig > /home/theia/.kube/config"
docker exec -ti theia bash -c "sed -i 's/127.0.0.1/kubernetes/g' /home/theia/.kube/config"

docker exec -ti theia kubectl cluster-info --context kind-kind
docker exec -ti theia kubectl taint nodes --all node-role.kubernetes.io/master-

docker exec -ti -u root kind-control-plane sh -c "echo 'nameserver 10.96.0.10' >> /etc/resolv.conf"
docker exec -ti -u root kind-control-plane2 sh -c "echo 'nameserver 10.96.0.10' >> /etc/resolv.conf"
docker exec -ti -u root kind-control-plane3 sh -c "echo 'nameserver 10.96.0.10' >> /etc/resolv.conf"

docker exec -ti -u root kind-control-plane apt-get update -qy
docker exec -ti -u root kind-control-plane2 apt-get update -qy
docker exec -ti -u root kind-control-plane3 apt-get update -qy

docker exec -ti -u root kind-control-plane apt-get install -qy open-iscsi
docker exec -ti -u root kind-control-plane2 apt-get install -qy open-iscsi
docker exec -ti -u root kind-control-plane3 apt-get install -qy open-iscsi

docker exec -ti -u root kind-control-plane systemctl enable iscsid
docker exec -ti -u root kind-control-plane2 systemctl enable iscsid
docker exec -ti -u root kind-control-plane3 systemctl enable iscsid

docker exec -ti -u root kind-control-plane systemctl start iscsid
docker exec -ti -u root kind-control-plane2 systemctl start iscsid
docker exec -ti -u root kind-control-plane3 systemctl start iscsid


docker exec -ti -u root kind-control-plane systemctl status iscsid
docker exec -ti -u root kind-control-plane2 systemctl status iscsid
docker exec -ti -u root kind-control-plane3 systemctl status iscsid
