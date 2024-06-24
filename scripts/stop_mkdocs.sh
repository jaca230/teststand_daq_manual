#!/bin/bash
# File: teststand_daq_manual_v1/scripts/stop_mkdocs.sh

# Check if screen session exists and kill it
if screen -list | grep -q "mkdocs_server"; then
    screen -S mkdocs_server -X quit
    echo "MkDocs server screen session stopped."
else
    echo "MkDocs server screen session is not running."
fi

