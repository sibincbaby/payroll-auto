#!/bin/bash
# Author: sibincbaby
# Latest Update: 2023-11-04
echo "***** Payroll Master Auto Login *****"
echo "What Will It Do:"
echo "# Automatically open the 'mypayrollmaster' website when you log in to your system."
echo "# Note: Automating the login process may require additional browser setup."
echo "# Uninstallation:"
echo "# To remove this automation, you can use the provided uninstall option in the script."

echo "Select an option:"
echo "1. Install My Payroll Script"
echo "2. Uninstall My Payroll Script"
read -p "Enter your choice (1 or 2): " choice

# Define the target directory for the openUrl.sh script
TARGET_DIR="/usr/local/bin/payroll"
if [ "$choice" == "1" ]; then
    # Check if the target directory exists, create it if not
    if [ ! -d "$TARGET_DIR" ]; then
        sudo mkdir -p "$TARGET_DIR"
    fi

    # File to store the last run date
    LAST_RUN_FILE="$TARGET_DIR/mypayroll_last_run_date"
    sudo touch "$LAST_RUN_FILE"
    # Give read and write permissions to all users
    sudo chmod a+rw "$LAST_RUN_FILE"

    # Define the script file
    SCRIPT_FILE="$TARGET_DIR/openUrl.sh"


    # Define the content of the openUrl.sh script
    OPENURL_SCRIPT_CONTENT="#!/bin/bash\n\n"
    OPENURL_SCRIPT_CONTENT+="TARGET_DIR=\"$TARGET_DIR\"\n"
    OPENURL_SCRIPT_CONTENT+="LAST_RUN_FILE=\"\$TARGET_DIR/mypayroll_last_run_date\"\n\n"
    OPENURL_SCRIPT_CONTENT+="CURRENT_DATE=\$(date +%F)\n\n"
    OPENURL_SCRIPT_CONTENT+="if [ -f \"\$LAST_RUN_FILE\" ]; then\n"
    OPENURL_SCRIPT_CONTENT+="    LAST_RUN_DATE=\$(cat \"\$LAST_RUN_FILE\")\n"
    OPENURL_SCRIPT_CONTENT+="    if [ \"\$LAST_RUN_DATE\" == \"\$CURRENT_DATE\" ]; then\n"
    OPENURL_SCRIPT_CONTENT+="        echo \"The script has already run today. Exiting.\"\n"
    OPENURL_SCRIPT_CONTENT+="        exit 0\n"
    OPENURL_SCRIPT_CONTENT+="    fi\n"
    OPENURL_SCRIPT_CONTENT+="fi\n\n"
    OPENURL_SCRIPT_CONTENT+="CHROME_PATH=\$(which google-chrome)\n\n"
    OPENURL_SCRIPT_CONTENT+="if [ -z \"\$CHROME_PATH\" ]; then\n"
    OPENURL_SCRIPT_CONTENT+="    echo \"Google Chrome not found. Please make sure it is installed and in your PATH.\"\n"
    OPENURL_SCRIPT_CONTENT+="    exit 1\n"
    OPENURL_SCRIPT_CONTENT+="fi\n\n"
    OPENURL_SCRIPT_CONTENT+="echo \"\$CURRENT_DATE\" > \"\$LAST_RUN_FILE\"\n"
    OPENURL_SCRIPT_CONTENT+="URL=\"https://v1.mypayrollmaster.online/Dashboard/empdashboard\"\n\n"
    OPENURL_SCRIPT_CONTENT+="\$CHROME_PATH \"\$URL\"\n"

    # Create and write the openUrl.sh script content
    echo -e "$OPENURL_SCRIPT_CONTENT" | sudo tee "$SCRIPT_FILE" > /dev/null

    # Make the script file executable
    sudo chmod +x "$SCRIPT_FILE"

    # Step 1: Create the mypayroll.desktop file
    # ... Rest of your installation code
        cat > ~/.config/autostart/mypayroll.desktop <<EOL
[Desktop Entry]
Type=Application
Name=My Payroll
Exec=$TARGET_DIR/openUrl.sh
Icon=system-run
X-GNOME-Autostart-enabled=true
EOL

    # Step 2: Make the script file executable
    chmod +x ~/.config/autostart/mypayroll.desktop

    echo "Payroll script installed successfully."
    echo "To enable automatic login to the payroll website, please log out and log back in or reboot your system."

elif [ "$choice" == "2" ]; then
    # Uninstall the script
    sudo rm -rf "$TARGET_DIR"
    rm ~/.config/autostart/mypayroll.desktop
    echo "Payroll script uninstalled successfully."

else
    echo "Invalid choice. Please enter '1' to install or '2' to uninstall."
fi


# Prompt to press Enter to exit
read -p "Press Enter to exit..."

