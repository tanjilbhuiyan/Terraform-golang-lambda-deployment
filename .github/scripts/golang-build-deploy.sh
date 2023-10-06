#!/bin/bash

# Set your AWS S3 bucket name
S3_BUCKET_NAME="your-s3-bucket-name"

# Read the file and process each line
while IFS= read -r line; do
  # Remove leading and trailing whitespace and quotes
  line=$(echo "$line" | sed -e 's/^"//' -e 's/"$//')

  # Remove the "github/lambda/" prefix from the path
  modified_line=$(echo "$line" | sed -e 's/github\/lambda\///')

  # Extract the directory path from the modified line
  dir_path=$(dirname "$modified_line")

  # Extract the filename without extension
  file_name=$(basename "$modified_line" .go)

  # Navigate to the directory
  cd "$dir_path" || { echo "Failed to change directory to $dir_path"; exit 1; }

  # Build the Go code with specified parameters
  GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o bootstrap

  # Create a ZIP file with the desired filename
  zip -q -r "$file_name.zip" bootstrap

  # Upload the ZIP file to S3
  aws s3 cp "$file_name.zip" "s3://$S3_BUCKET_NAME/$file_name.zip"

  # Clean up
  rm -f bootstrap "$file_name.zip"

  # Return to the original directory
  cd - || { echo "Failed to return to the original directory"; exit 1; }

done < list.txt

echo "Processing complete"
