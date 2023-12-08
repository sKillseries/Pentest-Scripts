#!/bin/bash

cible=$1
cidr=$2

if [ ! -d "resultats" ];then
    mkdir resultats
fi
if [ ! -d "resultats/adrecon.txt" ];then
    touch resultats/netscan.txt
fi

echo "### Inside multihosts network scan ###" >> resultats/netscan.txt

echo "ICMP Port Scanning"
{
    echo "Inside multihosts ICMP Port Scanning Result"
    nmap -PE -PM -PP -sn -vvv -n "$cible"/"$cidr"
    echo -e "\n"
} >> resultats/netscan.txt

echo "TCP Port Scanning"
{
    echo "Inside multihosts TCP Port Scanning Result"
    nmap -sV -sC -O -n -Pn -p- -oA fullfastscan "$cible"/"$cidr"
    echo -e "\n"
} >> resultats/netscan.txt

echo "HTTP Port Scanning"
{
    echo "Inside multihosts HTTP Port Scanning Result"
    masscan --banners -p80,443,8000-8100,8443 "$cible"/"$cidr"
    echo -e "\n"
} >> resultats/netscan.txt

echo "UDP Port Scanning"
{
    echo "Inside multihosts UDP Port Scanning Result"
    nmap -sU -sV --version-intensity 0 -n "$cible"/"$cidr"
    echo -e "\n"
} >> resultats/netscan.txt

echo "SCTP Port Scanning"
{
    echo "Inside multihosts SCTP Port Scanning Result"
    nmap -p- -sY -sV -sC -F -n -oA SCTAllScan "$cible"/"$cidr"
    echo -e "\n"
} >> resultats/netscan.txt

echo "DHCP Scanning"
{
    echo "DHCP multihosts Scanning Result"
    nmap --script broadcast-dhcp-discover
    echo -e "\n"
} >> resultats/netscan.txt

echo "### Inside multihosts network scan FIN ###" >> resultat/netscan.txt