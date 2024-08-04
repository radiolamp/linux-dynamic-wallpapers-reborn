#!/bin/bash

# Directory containing the XML files (current directory)
XML_DIR="../xml"
DYNAMIC_WALLPAPERS_DIR="../dynamic-wallpapers"

# Function to process XML files
process_xml_files() {
    local directory=$1
    echo "Processing XML files in $directory"
    # Iterate over each .xml file in the directory
    for xml_file in "$directory"/*.xml; do
        if [ -f "$xml_file" ]; then
            # Perform the substitution and save changes in place
            sed -i 's|/usr/share/backgrounds/Dynamic_Wallpapers/|/usr/share/backgrounds/dynamic-wallpapers/|g' "$xml_file"
            echo "Updated $xml_file"
        else
            echo "No .xml files found in $directory."
        fi
    done
}

# Process XML files in both directories
process_xml_files "$XML_DIR"
process_xml_files "$DYNAMIC_WALLPAPERS_DIR"

echo "All XML files have been updated."

