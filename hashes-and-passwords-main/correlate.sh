#!/bin/bash

Help () {
	echo "Usage: ./correlate.sh <<file with hash:plaintext>> <<file with hash:user>>"
	echo "If a cracked plaintext password contains a colon it will add an extra column"
	echo "to the .csv file and will need to be manually corrected."
}

if [[ $1 == '' ]]; then
	echo "Please supply the files necessary or use -h for help"
	exit
elif [[ $1 == '-h' ]]; then
	Help
	exit
fi

while read line;
do
   hash=$(echo $line | awk -F : '{print $1}'); 
   user=$(grep $hash $2 | awk -F : '{print $2}');
   echo $line:$user;
done < $1 | sort -u -t ':' -k3 | sed 's/ /, /g' | tee correlated.csv

echo
echo
echo "When viewing CSV, ensure you are delimiting by colon (:)."
