#!/usr/bin/bash

# write your code here
echo "Enter a definition:"

read -a user_input
arr_length="${#user_input[@]}"
definition="${user_input[0]}"
constant="${user_input[1]}"

re="[a-z]+_to_[a-z]+"
re_constant="^\-?[0-9]+\.?[0-9]*$"

if [ "$arr_length" -eq 2 ] && [[ "$definition" =~ $re ]] && [[ "$constant" =~ $re_constant ]]; then
	echo "The definition is correct!"
else
	echo "The definition is incorrect!"
fi