#!/bin/bashtxt

cible=$1

if [ ! -d "resultats" ];then
    mkdir resultats
fi
if [ ! -d "resultats/adrecon.txt" ];then
    touch resultats/netscan.txt
fi

echo "### Outside singlehost network scan" >> resultats/netscan.txt

echo "ICMP Port Scanning"
{
    echo "Outside singlehost ICMP Port Scanning Result"
    nmap -PE -PM -PP -sn -n "$cible"
    echo -e "\n"
} >> resultats/netscan.txt

echo "TCP Port Scanning"
{
    echo "Outside singlehost TCP Port Scanning Result"
    masscan --banners -p20,21-23,25,53,80,110,111,135,139,143,443,445,993,995,1723,3306,3389,5900,8080 "$cible"
    echo -e "\n"
} >> resultats/netscan.txt

echo "HTTP Port Scanning"
{
    echo "Outside singlehost HTTP Port Scanning Result"
    masscan --banners -p80,443,8000-8100,8443 "$cible"
    echo -e "\n"
} >> resultats/netscan.txt

echo "UDP Port Scanning"
{
    echo "Outside singlehost UDP Port Scanning Result"
    nmap -sU -sV --version-intensity 0 -F -n "$cible"
    echo -e "\n"
} >> resultats/netscan.txt

echo "SCTP Port Scanning"
{
    echo "Outside singlehost SCTP Port Scanning Result"
    nmap -sY -n --open -Pn "$cible"
    echo -e "\n"
} >> resultats/netscan.txt

echo "### Outside singlehost network scan FIN" >> resultat/netscan.txt