#!/bin/bash

file=$1
S3_BUCKET_NAME="my-unique-bucket-golang-lambda-test"

while read line; do
  # Remove starting and ending square brackets using parameter expansion
  line="${line#\[}"  # Remove starting square bracket
  line="${line%\]}"  # Remove ending square bracket
  printf '%s\n' "$line"
  IFS=',' read -ra parts <<< "$line"

  # Iterate over the split parts and echo each one
  for part in "${parts[@]}"; do
    # Remove any leading or trailing spaces
    directory_path=$(echo "$part" | tr -d '[:space:]' | sed 's/"//g' | sed 's#^github/##;s#/main\.go$##')
    printf '%s\n' "$directory_path"

    # Extract the path without the filename and the initial 'lambda/' part
    zip_name=$(dirname "$directory_path" | sed 's|^lambda/||')

    # Determine if the last segment is 'src' or not
    last_segment=$(basename "$zip_name")

    if [ "$last_segment" = "src" ]; then
      # Remove the last segment if it is 'src'
      zip_name =$(dirname "$zip_name")
    fi

    # Replace '/' with '_'
    result=$(echo "$zip_name" | tr '/' '_')

    printf '%s\n' "$result"


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
        # zip_name=$(echo "$directory_path" | awk -F'/' '{print $2}')

        # Check the exit status of the build command
        if [ $? -eq 0 ]; then
            echo "Build in directory $directory_path succeeded:"
            echo "$build_output"
            # Zip the bootstrap file
            zip -q "$result.zip" bootstrap
            ls -la
            pwd
            echo "Bootstrap file zipped as bootstrap.zip"
            echo "Uploading to AWS S3"
            aws s3 cp "$result.zip" "s3://$S3_BUCKET_NAME/$result.zip"

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
