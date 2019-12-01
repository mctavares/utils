#!/bin/bash

clear
if [ $# -ne 0 ]; then
	for i in "$@"
	do
	case $i in
		-f=*|--filename=*)
		FILENAME="${i#*=}"
		shift # past argument=value
		;;
		-s=*|--sha256=*)
		INPUT_SHA256="${i#*=}"
		shift # past argument=value
		;;
	esac
	done
	if [ -f "${FILENAME}" ]; then
		SHA256=$( sha256sum "${FILENAME}" )
		# SHA contains the hash and the full filename separated by spaces
		# Therefore, we split at the space
		IFS=' ' read -r -a RESULT <<< "${SHA256}"
		# Trim whitespace
		SHA256=$(echo -e "${RESULT[0]}" | tr -d '[:space:]')
		if [ "$SHA256" = "$INPUT_SHA256" ]; then
			echo "Match"
		else
			echo "Do not match"
		fi
	else
		echo "File ${FILENAME} not found. Did you include the full path?"
	fi
else
	echo "Simple bash script to compare sha256 values. Useful when downloading " \
	 "a file from the internet and you need to compare the provided with the" \
	 "generated sha256 value."
	echo "Usage: "	
	echo "compare_sha256 -f=<full path filename> -s=<sha256 value to be compared>"
	echo "Or"
	echo "compare_sha256 -filename=<full path filename> -sha256=<sha256 value to be compared>"
fi
