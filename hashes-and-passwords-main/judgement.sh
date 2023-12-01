#!/bin/bash

Help () {
	echo "Usage: ./judgement.sh <<file with plaintext passwords>>"
	echo "Complexity levels are based off of Microsofts definition."
	echo "Blank passwords are omitted which may cause a discrepancy between"
	echo "the number of passwords supplied and the number of passwords evaluated"
	echo "if blank passwords are not trimmed from the supplied password file."
}

if [[ $1 == '' ]]; then
	echo "Please supply a file with plaintext passwords or use -h for help"
	exit
elif [[ $1 == '-h' ]]; then
	Help
	exit
fi

#total number of lines (passwords) in the input file.
total_passes=$(sed '/^$/d' $1 | wc -l)
#strip empty passwords and then sort them based on frequency, storing the top 10.
top10reuse=$(cat $1 | sed '/^[[:space:]]*$/d' | sort | uniq -c | sort -k1nr | head -n 10)

echo $total_passes "total passwords loaded."

#adding a newline at the beginning of the file and saving it to another temp file. Randomized as to not
#delete a different file on the system.
sed '/^$/d' $1 > e984a57019dca4d99c605d3fb.txt
sed -i '1s/^/\n/' e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	lowercount=$(grep -E '[a-z]' | wc -l)
	lowerave=$(awk -v var1=$lowercount -v var2=$total_passes 'BEGIN { print  ( var1 / var2 ) }' | cut -d '.' -f 2 | cut -c 1,2)
	echo $lowercount "passwords with lowercase characters, $lowerave% of all passwords."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	uppercount=$(grep -E '[A-Z]' | wc -l)
	upperave=$(awk -v var1=$uppercount -v var2=$total_passes 'BEGIN { print  ( var1 / var2 ) }' | cut -d '.' -f 2 | cut -c 1,2)
	echo $uppercount "passwords with uppercase characters, $upperave% of all passwords."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	numbercount=$(grep -E '[0-9]' | wc -l)
	numave=$(awk -v var1=$numbercount -v var2=$total_passes 'BEGIN { print  ( var1 / var2 ) }' | cut -d '.' -f 2 | cut -c 1,2)
	echo $numbercount "passwords with numbers, $numave% of all passwords."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	speccount=$(grep -E '[!-@#$%^&{}*()_+=?/><.,~`|\]' | wc -l)
	specave=$(awk -v var1=$speccount -v var2=$total_passes 'BEGIN { print  ( var1 / var2 ) }' | cut -d '.' -f 2 | cut -c 1,2)
	echo $speccount "passwords with special characters, $specave% of all passwords."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	numberspecialcount=$(grep -E '[0-9]' | grep -E '[!-@#$%^&{}*()_+=?/><.,~`|\]' | wc -l)
	numspecave=$(awk -v var1=$numberspecialcount -v var2=$total_passes 'BEGIN { print  ( var1 / var2 ) }' | cut -d '.' -f 2 | cut -c 1,2)
	echo $numberspecialcount "passwords with numbers and special characters, $numspecave% of all passwords."
done < e984a57019dca4d99c605d3fb.txt

while IFS= read -r line; do
	twelveormore=$(grep -E '.{12,}' | wc -l)
	twelveave=$(awk -v var1=$twelveormore -v var2=$total_passes 'BEGIN { print  ( var1 / var2 ) }' | cut -d '.' -f 2 | cut -c 1,2)
	echo $twelveormore "passwords that are twelve characters or more, $twelveave% of all passwords."
done < e984a57019dca4d99c605d3fb.txt

#removing the temp file
rm e984a57019dca4d99c605d3fb.txt
echo
echo
echo "The top ten reused passwords are:"
echo -e "$top10reuse\n"
