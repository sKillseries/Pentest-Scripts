#!/bin/bash

url=$1
fqdn=$(echo $url | sed 's#^https://www\.\(.*\)/$#\1#')

if [ ! -d "resultats" ];then
    mkdir resultats
fi
if [ ! -d "resultats/webrecon.txt" ];then
    touch resultats/webrecon.txt
fi
if [ ! -f "resultats/webalive.txt" ];then
    touch resultats/webalive.txt
fi
if [ ! -f "resultats/webfinal.txt" ];then
    touch resultats/webfinal.txt
fi
if [ ! -f "resultats/webassets" ];then
    touch resultats/webassets.txt
fi
if [ ! -f "resultats/web_potential_takeovers.txt" ];then
    touch resultats/web_potential_takeovers.txt
fi

echo "[+] HTTP response headers checking..."
{
    echo "[#] Curl Result"
    curl --location --head "$url"
    echo -e "\n"
} >> resultats/webrecon.txt

echo "[+] Site crawling..."
{
    echo "[#] hakrawler Result"
    echo "$url" | hakrawler -d 10
    echo -e "\n"
} >> resultats/webrecon.txt

echo "[+] Harvesting subdomains with assetfinder..."
assetfinder "$fqdn" >> resultats/webassets.txt
sort -u resultats/webassets.txt >> resultats/webfinal.txt
rm resultats/webassets.txt
 
echo "[+] Double checking for subdomains with amass..."
amass enum -d "$fqdn" >> resultats/webf.txt
sort -u resultats/webf.txt >> resultats/webfinal.txt
rm resultats/webf.txt

echo "[+] dnsrecon enumeration and zone transfer..."
{
    echo "[#] dnsrecon result"
    dnsrecon -a -d "$url"
    echo -e "\n"
} >> resultats/webrecon.txt

echo "[+] Probing for alive domains..."
sort -u resultats/webfinal.txt | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' >> resultats/weba.txt
sort -u resultats/weba.txt >> resultats/webalive.txt
rm resultats/weba.txt
rm resultats/webfinal.txt
 
echo "[+] Checking for possible subdomain takeover..." 
subjack -w resultats/webalive.txt -t 100 -timeout 30 -ssl -c ~/go/src/github.com/haccer/subjack/fingerprints.json -v 3 -o resultats/web_potential_takeovers.txt
{
    echo "[#] potential subdomain takeover"
    cat resultats/web_potential_takeovers.txt
    echo -e "\n"
} >> resultats/webrecon.txt
rm resultats/webalive.txt
rm resultats/web_potential_takeovers.txt
 
echo "[+] Scanning for open ports..."
{
    echo "[#] nmap web alive result"
    nmap -iL resultats/webalive.txt
    echo -e "\n"
} >> resultats/webrecon.txt

echo "[+] WAF checking..."
{
    echo "[#] Wafw00f result"
    wafw00f "$url"
    echo -e "\n"
} >> resultats/webrecon.txt

echo "[+] Double WAF checking..."
{
    echo "[#] Whatwaf result"
    whatwaf -u "$url"
    echo -e "\n"
} >> resultats/webrecon.txt

echo "[+] CMS identification checking..."
{
    echo "[#] droopescan result"
    droopescan scan -u "$url"
    echo -e "\n"
} >> resultats/webrecon.txt

echo "[+] vulnerability scanning"
{
    echo "nikto vulnerability scanning result"
    nikto -h "$url"
    echo -e "\n"
} >> resultats/webrecon.txt

echo "[+] double checking vulnerability scanning"
{
    echo "wapiti vulnerability scanning result"
    wapiti -u "$url"
    echo -e "\n"
} >> resultats/webrecon.txt