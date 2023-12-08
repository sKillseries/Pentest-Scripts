#!/bin/bash

cible=$1
mask=$2
range=$3

if [ ! -d "resultats" ];then
    mkdir resultats
fi
if [ ! -d "resultats/adrecon.txt" ];then
    touch resultats/adrecon.txt
fi

echo "[*] DHCP Checking..."
{
    echo "[#] DHCP Check result"
    nmap --script broadcast-dhcp-discover 
} >> resultats/adrecon.txt

echo "[*] DNS checking..."
{
    echo "[#] DNS Check result"
    nmap --script dns-srv-enum --script-args dns-srv-enum.domain="$cible" 
} >> resultats/adrecon.txt


echo "[*] Disvovering DNS nameservers..."
{
    echo "[#] DNS Discover result"
    nmap -v -sV -p 53 "$cible"/"$mask"
    nmap -v -sV -sU -p 53 "$cible"/"$mask"
} >> resultats/adrecon.txt


echo "[*] Reverse lookups PTR"
{
    echo "[#] PTR result"
    dnsrecon -r "$range" -n "$cible"
    echo -e "\n"
} >> resultats/adrecon.txt

echo "[*] nbt-ns scanning..."
{
    echo "[#] nbt scan result"
    nbtscan -r "$cible"/"$mask"
    nmblookup -A "$cible"
    echo -e "\n"
} >> resultats/adrecon.txt

echo "[*] Port scanning..."
{
    echo "[#] Port Scan result"
    nmap -sS -n --open -p 88,389 "$cible"
    echo -e "\n"
} >> resultats/adrecon.txt

echo "[*] ldap checking..."
{
    echo "[#] ldap check result"
    impacket-ntlmrelayx -t "ldap://'$cible'" --dump-adcs --dump-laps --dump-gmsa
    windapsearch --dc "$cible" --module users
    windapsearch --dc "$cible" --module metadata
    echo -e "\n"
} >> resultats/adrecon.txt

echo "[*] Looking for exposed rpc services..."
{
    echo "[#] exposed rpc services result"
    impacket-rpcdump -port 135 "$cible"
    impacket-rpcdump -port 593 "$cible"
    echo -e "\n"
} >> resultats/adrecon.txt

echo "[*] enum4linux checking..."
{
    echo "[#] enum4linux result"
    enum4linux -A "$cible"
    echo -e "\n"
} >> resultats/adrecon.txt
