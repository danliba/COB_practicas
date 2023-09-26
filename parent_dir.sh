#!/bin/bash

# Parent directory
parent_dir="/mnt/c/Users/danli/2005"

# Loop through subdirectories 01 to 12
for subdir in {01..12}; do
    # Move files from the current subdirectory to the parent directory
    mv "$parent_dir/$subdir/"* "$parent_dir/"
done
