#!/bin/bash

# Define the start and end dates for the loop
start_date="20050101"
end_date="20051231"

# Loop through dates
current_date="$start_date"
while [[ "$current_date" -le "$end_date" ]]; do
    # Construct the input and output file names
    input_file="${current_date}_d-CMCC--RFVL-MFSe3r1-MED-b20200901_re-sv01.00.nc"
    output_file="${current_date}.nc"

    # Run the cdo command
    cdo -sellonlatbox,6,-6,34,44 "$input_file" "$output_file"

    # Increment the current date by one day
    current_date=$(date -d "$current_date + 1 day" +"%Y%m%d")
done
