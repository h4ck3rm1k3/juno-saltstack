
exit

##########################################################

source auth-openrc.sh
source admin-openrc.sh

keystone user-create --name neutron --pass $NEUTRON_PASS
keystone user-role-add --user neutron --tenant service --role admin
keystone service-create --name neutron --type network --description "OpenStack Networking"
keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ network / {print $2}') \
  --publicurl http://controller1:9696 \
  --adminurl http://controller1:9696 \
  --internalurl http://controller1:9696 \
  --region regionOne

exit
###########################################################

ovs-vsctl add-br br-ex
ovs-vsctl add-port br-ex enp0s20f1


exit
#############################################################

neutron net-create ext-net --shared --router:external True --provider:physical_network external --provider:network_type flat

sleep 1
neutron subnet-create ext-net --name ext-subnet \
  --allocation-pool start=192.168.1.200,end=192.168.1.224 \
  --disable-dhcp --gateway 192.168.1.1 192.168.1.0/24



source demo-openrc.sh

sleep 1
neutron net-create demo-net

sleep 1
neutron subnet-create demo-net --name demo-subnet --gateway 172.16.1.1 172.16.1.0/24

neutron router-create demo-router
neutron router-interface-add demo-router demo-subnet
neutron router-gateway-set demo-router ext-net

neutron net-list

###

nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
neutron floatingip-create ext-net


