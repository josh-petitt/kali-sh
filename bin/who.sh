#!/bin/bash

# Find the network interface
ip a | grep UP | grep -vi loopback | tee docs/ip_a.txt
cat docs/ip_a.txt | awk '{print $2}' | sed 's/\W//g' | sort | uniq | tee docs/interfaces.txt
INTERFACE=$(head -n 1 docs/interfaces.txt)

# Get the public ip
curl ipinfo.io/ip | tee public_ip.txt

# Use netdiscover
sudo netdiscover -i $INTERFACE -fPN -r 192.168.1.1/24 | tee docs/netdiscover.txt
cat docs/netdiscover.txt | grep '^\s*[0-9]' | awk '{print $2, $1}' | sort | uniq | tee docs/netdiscover_mac_ip.txt

# Use arp-scan
sudo arp-scan --localnet -x --interface=$INTERFACE | tee docs/arp-scan.txt
cat docs/arp-scan.txt | grep '^\s*[0-9]' | awk '{print $2, $1}' | sort | uniq | tee docs/arp-scan_mac_ip.txt

# Create mac and ip lists
cat docs/netdiscover_mac_ip.txt docs/arp-scan_mac_ip.txt | sort | uniq | tee docs/mac_ip.txt
cat docs/mac_ip.txt | awk '{print $1}' | sort | uniq | tee docs/mac.txt
cat docs/mac_ip.txt | awk '{print $2}' | sort | uniq | tee docs/ip.txt

# Get domain names
cat docs/ip.txt | nslookup | tee docs/nslookup.txt
paste -d ' ' docs/ip.txt docs/nslookup.txt | grep name | awk '{print $1,$5}' | tee docs/ip_dn.txt
cat docs/ip_dn.txt | awk '{print $2}' | sort | uniq | tee docs/dn.txt

# See if they respond to ping
fping -f docs/ip.txt | grep 'is' | awk '{print $1,$3}' | tee docs/ip_fping.txt

# Use nmap to discover services (be patient)
sudo nmap -iL docs/ip.txt -A --verbose | tee docs/nmap_A.txt
cat docs/nmap_A.txt | awk '/^Nmap scan report/ {host=$5;ip=$6} /^[0-9]*\/tcp/ {print ip,host,$0}' | sed 's/[()]//g'| sed -E 's/^ ([^ ]*) /\1 \1 /' | tee docs/ip_host_port_state_service_description.txt

cat docs/ip_host_port_state_service_description.txt | awk '{print $3}' | sort | uniq |tee docs/port.txt
cat docs/ip_host_port_state_service_description.txt | awk '{print $5}' | sort | uniq |tee docs/service.txt
cat docs/ip_host_port_state_service_description.txt | awk '{print $1,$3}' | sort | uniq |tee docs/ip_port.txt
cat docs/ip_host_port_state_service_description.txt | awk '{print $3,$5}' | sort | uniq |tee docs/port_service.txt
