#!/bin/bash

# Function to show usage
usage() {
  echo "Usage: $0 {DV|IT|UA|PD} <source_folder> <target_folder>"
  exit 1
}

# Check if all parameters are provided
if [ "$#" -ne 3 ]; then
  usage
fi

# Assign variables
ENV=$1
SOURCE_FOLDER=$2
TARGET_FOLDER=$3

# Validate environment
if [[ ! "$ENV" =~ ^(DV|IT|UA|PD)$ ]]; then
  echo "Error: Invalid environment. Allowed values are DV, IT, UA, PD."
  usage
fi

# Ensure the source folder exists
if [ ! -d "$SOURCE_FOLDER" ]; then
  echo "Error: Source folder does not exist."
  exit 1
fi

# Ensure the target folder exists, or create it
if [ ! -d "$TARGET_FOLDER" ]; then
  echo "Target folder does not exist. Creating it..."
  mkdir -p "$TARGET_FOLDER"
fi

# Get a list of files with the environment prefix in the source folder
for file in "$SOURCE_FOLDER"/"$ENV"_*; do
  # Ensure we have valid files to process
  [ -e "$file" ] || continue
  
  # Extract the base filename, remove the environment prefix and underscore
  basefile=$(basename "$file" | sed "s/^$ENV\_//")

  # Check if a file already exists in the target folder, delete it
  if [ -e "$TARGET_FOLDER/$basefile" ]; then
    echo "Deleting existing file: $TARGET_FOLDER/$basefile"
    rm -f "$TARGET_FOLDER/$basefile"
  fi

  # Create a symlink from the source file to the target folder
  ln -s "$file" "$TARGET_FOLDER/$basefile"
  echo "Created symlink for $file -> $TARGET_FOLDER/$basefile"
done