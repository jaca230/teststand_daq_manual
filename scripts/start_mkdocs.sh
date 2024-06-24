#!/bin/bash
# File: teststand_daq_manual_v1/scripts/start_mkdocs.sh

# Determine the script directory
SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
    DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
    SOURCE=$(readlink "$SOURCE")
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
script_directory=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

# Default IP and port
IP_PORT="127.0.0.1:8000"

# Help function
show_help() {
    echo "Usage: ./start_mkdocs.sh [OPTIONS]"
    echo "Start the MkDocs server using screen."
    echo ""
    echo "Options:"
    echo "  -a, --address IP_PORT  Specify the IP address and port (default: 127.0.0.1:8000)"
    echo "  -h, --help             Show this help message and exit"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -a|--address)
            IP_PORT="$2"
            shift
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Navigate to the project directory
cd "$script_directory/../"

# Check if screen session already exists
if screen -list | grep -q "mkdocs_server"; then
    echo "MkDocs server screen session is already running."
    exit 1
fi

# Start MkDocs server in a screen session
screen -dmS mkdocs_server mkdocs serve -a $IP_PORT

echo "MkDocs server started at http://$IP_PORT using screen."
echo "To attach to the screen session, use: screen -r mkdocs_server"

