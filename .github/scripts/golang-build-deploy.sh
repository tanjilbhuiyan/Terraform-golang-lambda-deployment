#!/bin/bash

# Set your AWS S3 bucket name
S3_BUCKET_NAME="my-builds-for-golang-lambda-test"

# Read the file and process each line
while IFS= read -r line; do
  # Remove leading and trailing whitespace and quotes
  line=$(echo "$line" | sed -e 's/^"//' -e 's/"$//')

  # Extract the directory path from the line
  dir_path=$(dirname "$line")

  # Navigate to the directory
  cd "$dir_path" || { echo "Failed to change directory to $dir_path"; exit 1; }

  # Build the Go code with specified parameters
  GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o bootstrap

  # Create a ZIP file
  zip -q -r bootstrap.zip bootstrap

  # Upload the ZIP file to S3
  aws s3 cp bootstrap.zip "s3://$S3_BUCKET_NAME/$(basename "$line").zip"

  # Clean up
  rm -f bootstrap bootstrap.zip

  # Return to the original directory
  cd - || { echo "Failed to return to the original directory"; exit 1; }

done < list.txt

echo "Processing complete"
