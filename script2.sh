

#!/bin/bash
mkdir assignments
tar -xzf "$1"
for i in $(find . -name '*.txt')
do
	if [[ ${i: -4} == ".txt" ]]
	then
		while IFS='' read -r link || [[ -n "$link" ]]; do
   			if [[ ${link::1} != "#" ]]; then
				if [[ ${link::5} == "https" ]]; then
					cd assignments; git clone -q $link > /dev/null 2> /dev/null
					if [ $? -eq 0 ]; then
  					  echo "$link Cloning OK" 
					else
					  >&2 echo "$link Cloning FAILED"
					fi
					break
				fi
			fi
		done < $i
	fi
	cd ..
done
cd assignments
for dir in */
do
	temp=$dir 
	dir=${dir%*/}
	echo "${dir##*/}:"	
	cd $temp
	count_txt=$(find . -name "*.txt" -not -path "*.git*" | wc -l)
	count_dir=$(find . -mindepth 1 -not -path "*.git*" -type d | wc -l)
	count_all=$(find . -not -path "*.git*" | wc -l)
	count_nottxt=`expr $count_all - $count_txt - $count_dir - 1`
	echo "Number of directories: $count_dir"
	echo "Number of txt files: $count_txt"
	echo "Number of other files: $count_nottxt"
	if [[ $count_nottxt != 0 ]] || 
	   [[ $count_dir != 1 ]] ||
	   [[ count_txt != 3 ]]
	then
		echo "Directory structure is NOT OK."
	else
	if [ -e ./dataA.txt ]
	then
		if [ -d more ]
		then
			cd more
			if [ -e ./dataB.txt ]
			then
				if [ -e ./dataC.txt ]
				then
					count_all=$(find . | wc -l)
					count_all=`expr $count_all - 1`
					if [[ $count_all == 2 ]]
					then
						echo "Directroy structure is OK."
					else
						echo "$count_all Directory sturcutre is NOT OK."
					fi
				else
					echo "Directory structure is NOT OK."
				fi
			else
				echo "Directory structure is NOT OK."
			fi
			cd ..
		else
			echo "Directory structure is NOT OK."
		fi
	else
		echo "Directory structure is NOT OK."
	fi
	fi
	cd ..
done
