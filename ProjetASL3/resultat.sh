#!/bin/bash

> report.txt
count_succes=0
count_erreur=0
for file in test/*/*; do
	name="$file"
	echo "$name" >> report.txt
    bin/./tpcas < "$file"  >> report.txt
    ret=$?
    if [ "$ret" -eq 0 ]; then
        # test réussi
         count_succes=$((count_succes + 1))
    else
        # test raté...
        count_erreur=$((count_erreur + 1))
    fi
done

echo "Nombre de tests reussis : " $((count_succes))
echo "Nombre de tests echoués : " $((count_erreur))
