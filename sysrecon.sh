#!/bin/bash

cible=$1

if [ ! -d "resultats" ];then
    mkdir resultats
fi
if [ ! -d "resultats/sysrecon.txt" ];then
    touch resultats/sysrecon.txt
fi

echo "[*] ARP active discovering..."
{
    echo "[#] ARP scan result"
    nmap -sn "$cible"
    echo -e "\n"
} >> resultats/sysrecon.txt

echo "[*] NBT discovering..."
{
    echo "[#] NBT scan result"
    nbtscan -r "$cible"
    echo -e "\n"
} >> resultats/sysrecon.txt

echo "[*] ICMP discovering..."
{
    echo "[#] ICMP scan result"
    nmap -PE -PP -PM -sP "$cible"
    echo -e "\n"
} >> resultats/sysrecon.txt

echo "[*] TCP Port scanning..."
{
    echo "[#] TCP port scan result"
    nmap -Pn --script vuln -sV -p "0-65535" "$cible"
    echo -e "\n"
} >> resultats/sysrecon.txt

echo "[*] Double Checking Port Scanning..."
{
    echo "[#] masscan result"
    masscan -p0-65535,U:0-65535 --max-rate 100000 "$cible"
    echo -e "\n"
} >> resultats/sysrecon.txt 
