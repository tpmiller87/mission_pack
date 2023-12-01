#!/bin/bash


if [[ $EUID -ne 0 ]]; then
    echo "You must run this script as root!"
    exit 1
fi

read -p "What non-root user should own these tools?:  " user

echo "$user will own the directory 'my_tools' and everything in it."
echo "Exit this script if this is not what you want!"
sleep 5
echo "Starting the preferred tools startup script..."
sleep 2
#update repos


apt --fix-broken install
apt update

mkdir my_tools
cd my_tools

#chrome install
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i *chrome*
rm *chrome*

#name that hash install
apt install name-that-hash -y

#golang install
apt install golang-go -y

#SharpCollection install
git clone https://github.com/Flangvik/SharpCollection.git

#crackmapexec update - latest 6.0.0 "BANE"
#wget https://github.com/mpgn/CrackMapExec/releases/download/v6.0.0/cme-ubuntu-latest-3.11.zip
#unzip cme-ubuntu-latest-3.11.zip
#chmod +x cme
#cp cme /usr/bin 

#make permissions all for user 'kali' from root
cd -
chown -R $user:$user my_tools

#install netexec
apt install pipx git
pipx ensurepath
pipx install git+https://github.com/Pennyw0rth/NetExec
echo "alias nxc='netexec'" >> /home/cpt/.zshrc

#to-do:
#Make aliases for the below commands:
#nmap -Pn -n -sS -p 21-23,25,53,80,111,137,139,445,443,944,1433,1521,1830,3306,5432,6379,8443,8080,27017-27019,28017 --min-hostgroup 255 --min-rtt-timeout 0ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 6000 -oA NAMEOFOP -vvv --open -iL <IPLIST>
#nmap -Pn -n -sS -p- --min-hostgroup 255 --min-rtt-timeout 25ms --max-rtt-timeout 100ms --max-retries 1 --max-scan-delay 0 --min-rate 1000 -oA NAMEFULL -vvv --open -iL ~/share/data/networkMapping/internal/nmap/disc/livehosts.txt
#sudo mount -t cifs -o username=xxx,uid=$(id -u),gid=$(id -g) //<IP>/share /home/xxx/share
#
#Probably add Bloodhound updates (CE is out so it will be only on server)
