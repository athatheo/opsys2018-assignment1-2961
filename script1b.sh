#!/bin/bash
while IFS='' read -r link || [[ -n "$link" ]]; do
   x="${link////-}" 
   if [[ ${link::1} != "#" ]]; then
	if grep -q "$link" storedURL.txt; then
	    mv "${x}new".txt "${x}old".txt 2> /dev/null
   	    curl $link -L --compressed -s > "${x}new".txt
    	    DIFF_OUTPUT="$(diff ${x}new.txt ${x}old.txt)"
            if [ "0" != "${#DIFF_OUTPUT}" ]; then
               DIFF_FAIL_OUTPUT="$(diff empty.txt ${x}new.txt)"
	       if [ "0" == "${#DIFF_FAIL_OUTPUT}" ]; then
	           echo "$link FAILED"
	       else 
		   echo "$link"
	       fi
            fi
	else 
	    echo "$link" >> storedURL.txt
            echo "$link INIT"
            touch "${x}new".txt
	    curl $link -L --compressed -s > "${x}new".txt
        fi
    fi
done < "$1"
