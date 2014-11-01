
Ubuntu Ethernet Bonding
http://www.paulmellors.net/ubuntu-server-14-04-lts-nic-bonding/

sudo apt-get install ifenslave-2.6
sudo vi /etc/modules
# /etc/modules: kernel modules to load at boot time.
#
# This file contains the names of kernel modules that should be loaded
# at boot time, one per line. Lines beginning with "#" are ignored.
# Parameters can be specified after the module name.

loop
lp
rtc
bonding

sudo modprobe bonding

sudo vi /etc/network/interfaces
auto lo
iface lo inet loopback

#eth0 is manually configured, and slave to the “bond0″ bonded NIC
auto eth0
iface eth0 inet manual
bond-master bond0
bond-primary eth0

#eth1 ditto, thus creating a 2-link bond.
auto eth1
iface eth1 inet manual
bond-master bond0

# bond0 is the bonding NIC and can be used like any other normal NIC.
# bond0 is configured using static network information.
auto bond0
iface bond0 inet static
address x.x.x.x
gateway x.x.x.x
netmask x.x.x.x
dns-nameservers x.x.x.x x.x.x.x
dns-search xxxxxxx
bond-mode balance-tlb
bond-miimon 100
bond-slaves none

reboot
# cat /proc/net/bonding/bond0
