#!/bin/bash

# I hate using caps lock so I renamed things

# Directory containing the XML files (current directory)
XML_DIR="../xml"

# Iterate over each .xml file in the directory
for xml_file in "$XML_DIR"/*.xml; do
    if [ -f "$xml_file" ]; then
        # Perform the substitution and save changes in place
        sed -i 's|/usr/share/backgrounds/Dynamic_Wallpapers/|/usr/share/backgrounds/dynamic-wallpapers/|g' "$xml_file"
        echo "Updated $xml_file"
    else
        echo "No .xml files found in $XML_DIR."
        exit 1
    fi
done

echo "All XML files have been updated."

