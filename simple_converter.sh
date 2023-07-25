#!/usr/bin/bash

# write your code here

print_menu() {
	echo "Select an option"
	echo "0. Type '0' or 'quit' to end program"
	echo "1. Convert units"
	echo "2. Add a definition"
	echo "3. Delete a definition"
}

echo -e "Welcome to the Simple converter!\n"
while true;
do
	print_menu
	read -r option
	case "$option" in
		"1"|"2"|"3")
			echo -e "Not implemented!\n";;

		"0" | "quit")
			echo "Goodbye!"
			break
			;;
		*)
			echo -e "Invalid option!\n";;
	esac
done