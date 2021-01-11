docker exec -ti theia ssh-keygen -t rsa -b 4096 -C "shokohsc@gmail.com"
docker exec -ti theia eval "$(ssh-agent -s)"
docker exec -ti theia ssh-add ~/.ssh/id_rsa
docker exec -ti theia cat /home/theia/.ssh/id_rsa.pub

docker network create --subnet 172.19.0.0/16 --gateway 172.19.0.1 kind
docker network connect kind traefik && \
docker network connect kind theia
docker exec -ti theia kind create cluster --config /home/project/kind/kind.yaml
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

# nsenter --mount=/host/proc/1/ns/mnt --net=/host/proc/1/ns/net iscsiadm -m node -T iqn.2019-10.io.longhorn:pvc-5d3258fb-8184-4010-91a5-3afc2b55925d -p 10.244.1.14 --login
