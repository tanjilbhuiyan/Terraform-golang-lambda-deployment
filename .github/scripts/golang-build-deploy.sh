#!/bin/bash

# Read the list.txt file line by line
while IFS= read -r line; do
  # Remove the "github/" prefix and "/src/main.go" suffix
  path="${line#github/}"
  path="${path%/main.go}"
  # Print the extracted path
  echo "$path"
done < list.txt
