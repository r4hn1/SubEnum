#!/bin/bash

# This script is used to enumerate subdomains.
clear
tput setaf 2
printf "\n"
echo "███████╗██╗   ██╗██████╗ ███████╗███╗   ██╗██╗   ██╗███╗   ███╗ "
echo "██╔════╝██║   ██║██╔══██╗██╔════╝████╗  ██║██║   ██║████╗ ████║ "
echo "███████╗██║   ██║██████╔╝█████╗  ██╔██╗ ██║██║   ██║██╔████╔██║ "
echo "╚════██║██║   ██║██╔══██╗██╔══╝  ██║╚██╗██║██║   ██║██║╚██╔╝██║ "
echo "███████║╚██████╔╝██████╔╝███████╗██║ ╚████║╚██████╔╝██║ ╚═╝ ██║ "
echo "╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝ "
printf "\n"
tput setaf 4
printf "\t\t------Twitter : R4hn1 --------\n"
printf "\t\t------LinkedIn : R4hn1 --------\n"
printf "\n"
# Taking Input From User.
read -p "Enter Domain Name (example.com) : " domain
printf "\n"
echo "Example : a, aaaa, cname, ns, ptr, txt, mx, soa"
echo "[-] Case Sensitive use lowercase for records."
printf "\n"
read -p "Enter Record Name : " record
printf "\n"
echo "[+] Checking Requirements."

# Checking Required Binaries. massdns,subfinder,dnsx,httpx
if ! [ -x "$(command -v massdns)" ]; then
    echo "[-] Error: massdns is not installed." >&2
    echo "[+] Installing massdns."
    git clone https://github.com/blechschmidt/massdns >/dev/null
    cd massdns/ 
    make >/dev/null
    cp bin/massdns /usr/bin/ 
else
	if [[ "$(id -u)" != "0" ]]; then
		echo "Requirement not met."
		echo "Please run this script from root."
	else
		echo "[+] Massdns Properly Installed."
	   	if ! [[ -x "$(command -v subfinder)" ]]; then
	   		echo "[-] Error: subfinder is not installed." >&2
	   		echo "[+] Installing subfinder."
	   		GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder >/dev/null
	   		cp /root/go/bin/subfinder /usr/bin/subfinder 
	   	else
	   		echo "[+] Subfinder Properly Installed."
	   		if ! [[ -x "$(command -v dnsx)" ]]; then
	   			echo "[-] Error: dnsx is not installed." >&2
	   			echo "[+] Installing dnsx."
	   			GO111MODULE=on go get -v github.com/projectdiscovery/dnsx/cmd/dnsx >/dev/null
	   			cp /root/go/bin/dnsx /usr/bin/dnsx
	   		else
	   			echo "[+] dnsx Properly Installed."
	   			if ! [[ -x "$(command -v httpx)" ]]; then
	   				echo "[-] Errot: httpx is not installed." >&2
	   				echo "[+] Installing httpx."
	   				GO111MODULE=on go get -v github.com/projectdiscovery/httpx/cmd/httpx >/dev/null
	   				cp /root/go/bin/httpx /usr/bin/httpx
	   				exit 1
	   			fi
	   		fi
	   	fi
	fi
fi

echo "[+] Requirement Successfully Met."
printf "\n"

# Creating Directory 
rm -rf $domain
mkdir $domain

# Downloading Subdomain Bruteforce File.
all="https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt"
resolv="https://raw.githubusercontent.com/blechschmidt/massdns/master/lists/resolvers.txt"
echo "[+] Downloading required files."
wget -q $all -O all.txt >/dev/null
wget -q $resolv -O resolvers.txt >/dev/null
sed -i "s/$/.$domain/" all.txt 

echo "[+] Enumerating $domain ....."

# Bruteforce Subdomains. 
massdns -r resolvers.txt all.txt -o S -w $domain/$domain.txt

# Enumerate Subdomains
subfinder -d $domain -silent | tee $domain/$domain.txt >/dev/null
printf "\n"

# Finding record.
echo "[+] Searching $record records for $domain"
dnsx -l $domain/$domain.txt -$record -resp-only -silent -o $domain/$record.txt >/dev/null
cat $domain/$domain.txt $domain/$record.txt | sort -u | uniq | tee $domain/merge.txt >/dev/null
cat $domain/merge.txt | grep -v -E "(azure.com|edgekey.net$|.elb.|akadns.net|$domain$)" > $domain/$domain.final.txt

# Capturing Header
httpx -l $domain/$domain.final.txt -title -tech-detect -status-code -follow-redirects -o $domain/http.txt -silent
printf "\n"
echo "[+] Total Discovered Domains : `cat $domain/$domain.txt | wc -l`"
echo "[+] Total $record Record Discovered : `cat $domain/$record.txt | wc -l`"
echo "[+] Total Domain list with $record record : `cat $domain/merge.txt | wc -l`"
echo "[+] File saved in `pwd`/$domain" 
printf "\n"

# Removing Downloaded files.
rm -f all.txt resolvers.txt
