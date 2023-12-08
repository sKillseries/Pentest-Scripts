#!/bin/bash

cible=$1
cidr=$2

if [ ! -d "resultats" ];then
    mkdir resultats
fi
if [ ! -d "resultats/adrecon.txt" ];then
    touch resultats/hostdiscovering.txt
fi

echo "Active Host Discovering"
{
    echo "Active Host Result"
    nmap -sn "$cible"/"$cidr"
    echo -e "\n"
} >> resultats/hostdiscovering.txt

echo "Active Host Discovering double checking"
{
    echo "Active host double checking Result"
    nbtscan -r "$cible"/"$cidr"
    echo -e "\n"
} >> resultats/hostdiscovering.txt