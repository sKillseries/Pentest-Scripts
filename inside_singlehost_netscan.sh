#!/bin/bash

cible=$1

if [ ! -d "resultats" ];then
    mkdir resultats
fi
if [ ! -d "resultats/adrecon.txt" ];then
    touch resultats/netscan.txt
fi

echo "### Inside singlehost network scan ###" >> resultats/netscan.txt

echo "ICMP Port Scanning"
{
    echo "Inside singlehost ICMP Port Scanning Result"
    nmap -PE -PM -PP -sn -vvv -n "$cible"
} >> resultats/netscan.txt

echo "TCP Port Scanning"
{
    echo "Inside singlehost TCP Port Scanning Result"
    nmap -sV -sC -O -n -Pn -p- -oA fullfastscan "$cible"
    echo -e "\n"
} >> resultats/netscan.txt

echo "HTTP Port Scanning"
{
    echo "Inside singlehost HTTP Port Scanning Result"
    masscan --banners -p80,443,8000-8100,8443 "$cible"
    echo -e "\n"
} >> resultats/netscan.txt

echo "UDP Port Scanning"
{
    echo "Inside singlehost UDP Port Scanning Result"
    nmap -sU -sV --version-intensity 0 -n "$cible"
    echo -e "\n"
} >> resultats/netscan.txt

echo "SCTP Port Scanning"
{
    echo "Inside singlehost SCTP Port Scanning Result"
    nmap -p- -sY -sV -sC -F -n -oA SCTAllScan "$cible"
    echo -e "\n"
} >> resultats/netscan.txt

echo "DHCP Scanning"
{
    echo "DHCP Scanning Result"
    nmap --script broadcast-dhcp-discover
    echo -e "\n"
} >> resultats/netscan.txt

echo "### Inside singlehost network scan FIN ###" >> resultat/netscan.txt