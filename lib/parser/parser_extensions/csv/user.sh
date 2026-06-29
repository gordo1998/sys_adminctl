#!/bin/bash

csv_user_parser(){
	local file="$1"

	while IFS="," read -r user path_user;do
        [[ -z "$user" ]] && continue
		echo "$user|$path_user"
	done < "$file" 
}

csv_user_delete_parser() {
	local file="$1"

	while read -r user;do
        [[ -z "$user" ]] && continue
		echo "$user"
	done < "$file"
}