#!/bin/bash

# Read each line from list.txt
while IFS= read -r line; do
  # Remove the leading "github/" and trailing "/src/main.go" from the line
  file_path=$(echo "$line" | sed 's/github\///;s/\/src\/main.go//')

  # Navigate to the directory
  cd "$file_path" || { echo "Error: Could not change directory to $file_path"; exit 1; }

  # Run the Go build command
  GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o bootstrap

  # Check if the build was successful
  if [ $? -eq 0 ]; then
    echo "Build successful in $file_path"
  else
    echo "Error: Build failed in $file_path"
  fi

  # Return to the original directory
  cd -
done < list.txt
