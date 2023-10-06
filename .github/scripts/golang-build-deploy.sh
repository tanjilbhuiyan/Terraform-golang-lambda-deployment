#!/bin/bash

file=$1
S3_BUCKET_NAME="my-unique-bucket-golang-lambda-test"

while read line; do
  # Remove starting and ending square brackets using parameter expansion
  line="${line#\[}"  # Remove starting square bracket
  line="${line%\]}"  # Remove ending square bracket

  IFS=',' read -ra parts <<< "$line"

  # Iterate over the split parts and echo each one
  for part in "${parts[@]}"; do
    # Remove any leading or trailing spaces
    directory_path=$(echo "$part" | tr -d '[:space:]' | sed 's/"//g' | sed 's#^github/##;s#/main\.go$##')

      # Check if the directory exists
    if [ -d "$directory_path" ]; then
        # Store the current directory
        current_dir="$(pwd)"

        # Change to the target directory
        cd "$directory_path"

        # Run the build command in the directory
        echo "Building in directory $directory_path:"
        # Run the build command in the directory and capture the output
        build_output=$(GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o bootstrap 2>&1)
        zip_name=$(echo "$directory_path" | awk -F'/' '{print $2}')

        # Check the exit status of the build command
        if [ $? -eq 0 ]; then
            echo "Build in directory $directory_path succeeded:"
            echo "$build_output"
            # Zip the bootstrap file
            zip -q "$zip_name.zip" bootstrap
            echo "Bootstrap file zipped as bootstrap.zip"
            echo "Uploading to AWS S3"
            aws s3 cp "$zip_name.zip" "s3://$S3_BUCKET_NAME/$zip_name.zip"

        else
            echo "Build in directory $directory_path failed:"
            echo "$build_output"
        fi

        # Return to the original directory
        cd "$current_dir"
    else
        echo "Directory $directory_path does not exist."
    fi
  done

done < list.txt
