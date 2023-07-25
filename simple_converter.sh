#!/usr/bin/bash

is_number() {
	re_constant="^\-?[0-9]+\.?[0-9]*$"
	if [[ $1 =~ $re_constant ]]; then
		echo 1
	else
		echo 0
	fi
}

is_definition() {
	re_definition="^[a-z]+_to_[a-z]+$"
	if [[ $1 =~ $re_definition ]]; then
		echo 1
	else
		echo 0
	fi
}

is_input_correct() {
	if [ "$1" -eq 2 ] && [ "$(is_definition "$2")" -eq 1 ] && [ "$(is_number "$3")" -eq 1 ]; then
		echo 1
	else
		echo 0
	fi
}

print_menu() {
	printf "Select an option\n"
	printf "0. Type '0' or 'quit' to end program\n"
	printf "1. Convert units\n"
	printf "2. Add a definition\n"
	printf "3. Delete a definition\n"
}

get_lines_count() {
	wc -l "$1" | cut -d ' ' -f 1
}

add_line() {
	echo "$1" >> "$2"
}

add_definition() {
	file_name="$1"
	while true;
	do
		printf "Enter a definition:\n"
		read -ra user_input
		arr_length="${#user_input[@]}"
		definition="${user_input[0]}"
		constant="${user_input[1]}"
		case $(is_input_correct "$arr_length" "$definition" "$constant") in
			1)
				add_line "${user_input[*]}" "$file_name"
				break
				;;
			0)
				printf "The definition is incorrect!\n";;
			*)
				printf "Unknown error!\n";;
		esac
	done
	printf "\n"
}

print_definitions() {
	nl -w 1 -s ". " "$1"
}

delete_line() {
	sed -i "${1}d" "$2"
}

is_empty_file() {
	lines_count="$(get_lines_count "$1")"
	if [ "$lines_count" = "0" ]; then
		echo 1
	else
		echo 0
	fi
}

create_file_if_not_exists() {
	if [ ! -f "$1" ]; then
		touch "$1"
	fi
}

delete_definition() {
	file_name="$1"
	create_file_if_not_exists "$file_name"
	if [ "$(is_empty_file "$file_name")" -eq 1 ]; then
		printf "Please add a definition first!\n"
	else
		printf "Type the line number to delete or '0' to return\n"
		print_definitions "$file_name"
		while true;
		do
			lines_count="$(get_lines_count "$1")"
			read -r line_number
			if [ "$line_number" -ge 1 ] && [ "$line_number" -le "$lines_count" ]; then
				delete_line "$line_number" "$file_name"
				break
			elif [ "$line_number" -eq 0 ]; then
				break
			else
				printf "Enter a valid line number!\n"
			fi
		done
	fi
	printf "\n"
}

convert() {
	file_name=$1
	create_file_if_not_exists "$file_name"
	if [ "$(is_empty_file "$file_name")" -eq 1 ]; then
		printf "Please add a definition first!\n"
	else
		printf "Type the line number to convert units or '0' to return\n"
		print_definitions "$file_name"
		while true;
		do
			lines_count="$(get_lines_count "$1")"
			read -r line_number
			if [ "$(is_number "$line_number")" -eq 1 ] && [ "$line_number" -ge 1 ] && [ "$line_number" -le "$lines_count" ]; then
				printf "Enter a value to convert:\n"
				while true;
				do
					read -r input
					if [ "$(is_number "$input")" -eq 1 ]; then
						line=$(sed "${line_number}!d" "$file_name")
						constant=$(echo "$line" | cut -d " " -f 2)
						result=$(bc <<< "$input*$constant")
						printf "Result: %s\n" "$result"
						break
					else
						printf "Enter a float or integer value!\n"
					fi
				done
				break
			elif [ "$(is_number "$line_number")" -eq 1 ] && [ "$line_number" -eq 0 ]; then
				break
			else
				printf "Enter a valid line number!\n"
			fi
		done
	fi
	printf "\n"
}

printf "Welcome to the Simple converter!\n"
while true;
do
	print_menu
	read -r selected_option
	case "$selected_option" in
		"0" | "quit")
			printf "Goodbye!\n"
			break
			;;
		"1")
			convert definitions.txt;;
		"2")
			add_definition definitions.txt;;
		"3")
			delete_definition definitions.txt;;
		*)
			printf "Invalid option!\n";;
	esac
done