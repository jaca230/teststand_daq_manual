#!/bin/bash
# File: teststand_daq_manual_v1/scripts/publish.sh

# Determine the script directory
SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
    DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
    SOURCE=$(readlink "$SOURCE")
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
script_directory=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

# Change to the script directory
cd "$script_directory/.."

# Build the project
mkdocs build

# Check if the PDF document exists
pdf_source="site/pdf/document.pdf"
pdf_destination="docs/pdfs/manual.pdf"

if [ -f "$pdf_source" ]; then
    echo "Copying $pdf_source to $pdf_destination"
    cp -f "$pdf_source" "$pdf_destination"
else
    echo "Error: $pdf_source not found. Exiting."
    exit 1
fi

# Rebuild the project to include the copied PDF
mkdocs build

# Deploy the project
mkdocs gh-deploy

echo "Publish process completed successfully."
