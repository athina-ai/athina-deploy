#!/bin/bash

# Input .env file
input=".env"
# Output .env.example file
output=".env.example"

# Keywords to search for in the variable names, adjusted for broader matching
keywords="token|secret|key|password|client_id|airtable|prompt_|webhook"

# Ensure the match is case-insensitive by incorporating it into the regex
pattern="^([^#=]*($keywords)[^#=]*)=.*$"


# Ensure the match is case-insensitive
shopt -s nocasematch

# Check if the output file already exists
if [ -f "$output" ]; then
    echo "$output exists. Removing it..."
    rm "$output"
fi

# Read .env file line by line
while IFS= read -r line
do
    # Skip comments
    if [[ $line =~ ^#.* ]]; then
        echo "$line" >> "$output"
        continue
    fi

    # Find lines that match the pattern and replace their values
    if [[ $line =~ $pattern ]]; then
        # Extract the key name (everything before the "=")
        key=$(echo $line | cut -d '=' -f 1)
        # Append the key with a placeholder value to the output file
        echo "${key}=YOUR_VALUE_HERE" >> "$output"
    else
        # For lines that don't match the pattern, just copy them as is
        echo "$line" >> "$output"
    fi
done < "$input"

echo ".env.example has been created."
