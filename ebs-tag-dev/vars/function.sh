#!/bin/bash
function isMatched() {
   	local param=$1
   	local existingKeysDataAsString="${@:2}"

	shopt -s nocasematch
   	 
	local matched="false"

	local existingKeysDataArr=$(echo $existingKeysDataAsString | tr " " "\n")
	for volumeExistingkey in $existingKeysDataArr
   	do	   

	   case $param in
	   		$volumeExistingkey)
			   	matched="true"
				break
				;;
			*)
				matched="false"
				;;	   
	   esac
	   
   	done

	if [ "$matched" == "true" ]; then
		echo "matched"
	else
		echo "unmatched"
	fi		

}
$@
