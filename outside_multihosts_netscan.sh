#!/bin/bash

cible=$1
cidr=$2

if [ ! -d "resultats" ];then
    mkdir resultats
fi
if [ ! -d "resultats/adrecon.txt" ];then
    touch resultats/netscan.txt
fi

echo "### Outside multihosts network scan" >> resultats/netscan.txt

echo "ICMP Port Scanning"
{
    echo "Outside multihosts ICMP Port Scanning Result"
    nmap -PE -PM -PP -sn -n "$cible"/"$cidr"
    echo -e "\n"
} >> resultats/netscan.txt

echo "TCP Port Scanning"
{
    echo "Outside multihosts TCP Port Scanning Result"
    masscan --banners -p20,21-23,25,53,80,110,111,135,139,143,443,445,993,995,1723,3306,3389,5900,8080 "$cible"/"$cidr"
    echo -e "\n"
} >> resultats/netscan.txt

echo "HTTP Port Scanning"
{
    echo "Outside multihosts HTTP Port Scanning Result"
    masscan --banners -p80,443,8000-8100,8443 "$cible"/"$cidr"
    echo -e "\n"
} >> resultats/netscan.txt

echo "UDP Port Scanning"
{
    echo "Outside multihosts UDP Port Scanning Result"
    nmap -sU -sV --version-intensity 0 -F -n "$cible"/"$cidr"
    echo -e "\n"
} >> resultats/netscan.txt

echo "SCTP Port Scanning"
{
    echo "Outside multihosts SCTP Port Scanning Result"
    nmap -sY -n --open -Pn "$cible"/"$cidr"
    echo -e "\n"
} >> resultats/netscan.txt

echo "### Outside multihosts network scan FIN" >> resultat/netscan.txt