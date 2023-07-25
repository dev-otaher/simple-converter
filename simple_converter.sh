#!/usr/bin/bash

# write your code here

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
	if [ $1 -eq 2 ] && [ $(is_definition $2) -eq 1 ] && [ $(is_number $3) -eq 1 ]; then
		echo 1
	else
		echo 0
	fi
}

echo "Enter a definition:"
read -a user_input

arr_length="${#user_input[@]}"
definition="${user_input[0]}"
constant="${user_input[1]}"

result=$(is_input_correct $arr_length $definition $constant)
if [ $result -eq 1 ]; then
	echo "Enter a value to convert:"
	read value
	while [ $(is_number $value) -ne 1 ]
	do
		echo "Enter a float or integer value!"
   		read value
	done
	r=$(bc -l <<< "$constant * $value")
	echo "Result:" $r
	
else
	echo "The definition is incorrect!"
fi