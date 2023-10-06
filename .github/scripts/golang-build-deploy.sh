#!/bin/bash

# Read the list.txt file and extract the file paths
while IFS= read -r line; do
  path=$(echo "$line" | sed 's#github/##;s#/#/#g;s/src.*//')
  echo "Processing $path"
  
  # Change directory to the extracted path
  cd "$path"
  
  # Run the build command
  GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o bootstrap
  
  # Return to the original directory
  cd -
done < list.txt
