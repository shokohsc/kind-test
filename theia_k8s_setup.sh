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

docker exec -ti -u root kind-control-plane apt-get update -qy
docker exec -ti -u root kind-control-plane2 apt-get update -qy
docker exec -ti -u root kind-control-plane3 apt-get update -qy

docker exec -ti -u root kind-control-plane apt-get install -qy open-iscsi
docker exec -ti -u root kind-control-plane2 apt-get install -qy open-iscsi
docker exec -ti -u root kind-control-plane3 apt-get install -qy open-iscsi
docker exec -ti -u root kind-control-plane systemctl enable open-iscsi iscsid
docker exec -ti -u root kind-control-plane2 systemctl enable open-iscsi iscsid
docker exec -ti -u root kind-control-plane3 systemctl enable open-iscsi iscsid
docker exec -ti -u root kind-control-plane systemctl start open-iscsi iscsid
docker exec -ti -u root kind-control-plane2 systemctl start open-iscsi iscsid
docker exec -ti -u root kind-control-plane3 systemctl start open-iscsi iscsid
#
#
# docker exec -ti -u root kind-control-plane systemctl status iscsid
# docker exec -ti -u root kind-control-plane2 systemctl status iscsid
# docker exec -ti -u root kind-control-plane3 systemctl status iscsid
#
#
# docker exec -ti -u root kind-control-plane systemctl stop open-iscsi iscsid
# docker exec -ti -u root kind-control-plane2 systemctl stop open-iscsi iscsid
# docker exec -ti -u root kind-control-plane3 systemctl stop open-iscsi iscsid
# docker exec -ti -u root kind-control-plane systemctl disable open-iscsi iscsid
# docker exec -ti -u root kind-control-plane2 systemctl disable open-iscsi iscsid
# docker exec -ti -u root kind-control-plane3 systemctl disable open-iscsi iscsid
# docker exec -ti -u root kind-control-plane apt-get remove -y open-iscsi tgt
# docker exec -ti -u root kind-control-plane2 apt-get remove -y open-iscsi tgt
# docker exec -ti -u root kind-control-plane3 apt-get remove -y open-iscsi tgt
# docker exec -ti -u root kind-control-plane apt-get autoremove -y
# docker exec -ti -u root kind-control-plane2 apt-get autoremove -y
# docker exec -ti -u root kind-control-plane3 apt-get autoremove -y
#
# # [pvc-b9ec5f7b-b3b5-4fc1-aac2-5013050fd522-e-a7165958]
# # time="2021-01-05T08:58:36Z"
# # level=warning
# # msg="FAIL to discover due to Failed to execute:
# # nsenter [--mount=/host/proc/1/ns/mnt --net=/host/proc/1/ns/net iscsiadm -m discovery -t sendtargets -p 10.244.2.20],
# # output ,
# # stderr,
# # Failed to connect to bus: No data available
# # iscsiadm: can not connect to iSCSI daemon (111)!
# # Failed to connect to bus: No data available
# # iscsiadm: can not connect to iSCSI daemon (111)!
# # iscsiadm: Cannot perform discovery. Initiatorname required.
# # iscsiadm: Could not perform SendTargets discovery: could not connect to iscsid
# # , error exit status 20"
