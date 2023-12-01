#!/bin/bash

file=$1
echo -n "What is your password? (There is no echo)" $'\n'
read -s assword

scp_file () {

/usr/bin/expect  <(cat << EOF
stty -echo
spawn scp -o ConnectTimeout=3 -o StrictHostKeyChecking=no $file cpt@kali-$i:/tmp	
expect "assword:"
send "$assword\r"
stty echo
interact
EOF
)
}

run_file () {

/usr/bin/expect  <(cat << EOF
stty -echo
spawn ssh cpt@kali-$i -o StrictHostKeyChecking=no -o ConnectTimeout=3 'bash' < /tmp/$file
expect "assword:"
send "$assword\r"
stty echo
interact
EOF
)
}

rm_file () {

/usr/bin/expect  <(cat << EOF
stty -echo
spawn ssh cpt@kali-$i -o StrictHostKeyChecking=no -o ConnectTimeout=3 "/usr/bin/rm /tmp/$file"
expect "assword:"
send "$assword\r"
stty echo
interact
EOF
)
}

for i in {0..9}; do
	scp_file
	run_file
	rm_file;
done
