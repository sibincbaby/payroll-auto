#!/bin/bash

TARGET_DIR="/usr/local/bin/payroll"
LAST_RUN_FILE="$TARGET_DIR/mypayroll_last_run_date"

CURRENT_DATE=$(date +%F)

if [ -f "$LAST_RUN_FILE" ]; then
    LAST_RUN_DATE=$(cat "$LAST_RUN_FILE")
    if [ "$LAST_RUN_DATE" == "$CURRENT_DATE" ]; then
        echo "The script has already run today. Exiting."
        exit 0
    fi
fi

CHROME_PATH=$(which google-chrome)

if [ -z "$CHROME_PATH" ]; then
    echo "Google Chrome not found. Please make sure it is installed and in your PATH."
    exit 1
fi

echo "$CURRENT_DATE" > "$LAST_RUN_FILE"
URL="https://v1.mypayrollmaster.online/Dashboard/empdashboard"

$CHROME_PATH "$URL"

