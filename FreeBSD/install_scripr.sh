#!/bin/bash

# Get the operating system name
os_name=$(uname)

# Check if the operating system is not FreeBSD
if [ "$os_name" != "FreeBSD" ]; then
    echo "This script can only be run on FreeBSD."
    exit 1
fi

echo "Running on FreeBSD."

# Check if the script is running with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

if [ $? -eq 0 ]; then
    echo "Bash installed successfully."
    echo "Setting Bash as the default shell for root..."
    sudo chsh -s /usr/local/bin/bash root
    echo "Bash set as the default shell for root."
else
    echo "Failed to install Bash. Exiting..."
    exit 1
fi

# Function to prompt the user for a yes/no response
prompt_yes_no() {
    while true; do
        read -p "$1 (yes/no): " yn
        case $yn in
            [Yy]* ) return 0;;  # User answered yes
            [Nn]* ) return 1;;  # User answered no
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Check if the pkg command is available
if ! command -v pkg &> /dev/null; then
    echo "The 'pkg' package manager is not available. Please install it and run this script again."
    exit 1
fi

# Fetch updates and install them
echo "Checking for system updates..."
update_output=$(/usr/sbin/freebsd-update fetch)

# Check if there are updates to install
if echo "$update_output" | grep -q "No updates needed"; then
    echo "No updates are necessary. Proceeding with package installation."
else
    if /usr/sbin/freebsd-update install; then
        echo "System updated successfully."
    else
        echo "Failed to update the system."
        exit 1
    fi
fi

# Function to check if a package is already installed
is_installed() {
    pkg info "$1" &> /dev/null
}

# List of packages to install
packages=(
    unzip git curl node npm libxslt libxml2 fop gcc gmake make++-2.0_1 pkgconf gtk3 libspng-0.7.4 curl
    automake autoconf wget tmux libtool ncurses wkhtmltopdf xorg-fonts-7.7_1 libX11 lzlib-1.14 zlib-ng-2.2.1
    xorg-vfbserver wx30-gtk3 unixodbc postgresql14-server postgresql14-client sudo expat tiff jpeg-turbo libjpeg-turbo expat tiff
)

echo "Installing packages..."
for package in "${packages[@]}"; do
    if is_installed "$package"; then
        echo "$package is already installed."
    else
        echo "Installing $package..."
        if ! pkg install -y "$package"; then
            echo "Failed to install $package."
            exit 1
        fi
    fi
done

echo "All packages installed successfully."

# Offer to reboot the system if updates were installed
if echo "$update_output" | grep -q "No updates needed"; then
    echo "System reboot is not necessary."
else
    read -p "Do you want to reboot the system now? (y/N): " reboot_choice
    case "$reboot_choice" in
        [yY][eE][sS]|[yY])
            echo "Rebooting now..."
            reboot
            ;;
        *)
            echo "Reboot skipped. Please reboot manually later."
            ;;
    esac
fi

echo "SECTION II "
# Step 1: Create the Necessary Directory
echo "Creating /var/account directory if it doesn't exist..."
sudo mkdir -p /var/account
if [ $? -eq 0 ]; then
    echo "Directory /var/account created or already exists."
else
    echo "Failed to create /var/account directory."
    exit 1
fi

# Step 2: Create the Accounting File
echo "Creating the accounting file /var/account/pacct..."
sudo touch /var/account/pacct
if [ $? -eq 0 ]; then
    echo "Accounting file /var/account/pacct created successfully."
else
    echo "Failed to create the accounting file."
    exit 1
fi

# Step 3: Enable Process Accounting
echo "Enabling process accounting..."
sudo accton /var/account/pacct
if [ $? -eq 0 ]; then
    echo "Process accounting enabled successfully."
else
    echo "Failed to enable process accounting."
    exit 1
fi

# Step 4: Turn Process Accounting into a Service
echo 'Enabling process accounting as a service...'
sudo sysrc accounting_enable="YES"
if [ $? -eq 0 ]; then
    echo "Process accounting service enabled in /etc/rc.conf."
else
    echo "Failed to enable process accounting service in /etc/rc.conf."
    exit 1
fi

# Step 5: Start Process Accounting Service
echo "Starting the process accounting service..."
sudo service accounting start
if [ $? -eq 0 ]; then
    echo "Process accounting service started successfully."
else
    echo "Failed to start the process accounting service."
    exit 1
fi

# Step 6: Verifying Process Accounting
echo "Verifying process accounting by generating some activity..."
ls > /dev/null
echo "Testing process accounting" > /dev/null

echo "Displaying recent command activities from the accounting log..."
echo "To run  and test out lastcomm use the command below"
echo "lastcomm -f /var/account/pacct"

# Step 7: Echo Useful Commands
echo "Process accounting has been set up. Here are some useful commands you can run:"
echo "| Command Description                               | Command                                      |"
echo "|--------------------------------------------------|----------------------------------------------|"
echo "| Display a basic summary of commands              | sa                                           |"
echo "| Show detailed information for each command       | sa -u                                        |"
echo "| Sort by total CPU time                           | sa -b                                        |"
echo "| List all commands, including rarely used ones    | sa -a                                        |"
echo "| Display statistics per user                      | sa -m                                        |"
echo "| Use an alternate accounting file                 | sa -f /path/to/alternate/accounting_file     |"
echo "| Sort and print by total number of disk I/O ops   | sa -D                                        |"
echo "| Interactive command filtering                    | sa -v 10                                     |"
echo "| Report time in seconds per call                  | sa -j                                        |"
echo "| Show the ratio of real time to CPU time          | sa -t                                        |"
echo "| Truncate accounting files after processing       | sa -s                                        |"
echo "| Display total amount of logins                   | ac                                           |"
echo "| Display total amount of logins per user          | ac -p                                        |"
echo "| Display total amount of logins for root user     | ac root                                      |"
echo "| Display information about all executed commands  | lastcomm                                     |"
echo "| Display information with paging                  | lastcomm | less                              |"

echo "Process accounting setup and configuration is complete."


if prompt_yes_no "Do you want to install Fail2Ban?"; then
    echo "SECTION III"
    # Step 1: Install Fail2Ban
    echo "Fetching and updating ports..."
    read -p "Is this the first time you are running portsnap? (yes/no): " first_time

    if [ "$first_time" = "yes" ]; then
        sudo portsnap fetch
        sudo portsnap extract
    else
        sudo portsnap fetch update
    fi
    echo "Ports have been updated successfully."
 
    if [ $? -eq 0 ]; then
        echo "Ports updated successfully."
    else
        echo "Failed to update ports."
        exit 1
    fi

    # Ask the user if they want to reinstall Fail2Ban
    if prompt_yes_no "Do you want to reinstall Fail2Ban (this will remove any existing installation first)?"; then
        reinstall=true
    else
        reinstall=false
    fi

    # Step 1: Install Fail2Ban
    echo "Installing Fail2Ban..."
    cd /usr/ports/security/py-fail2ban || { echo "Failed to navigate to Fail2Ban port directory."; exit 1; }

    if $reinstall; then
        echo "Reinstalling Fail2Ban..."
        sudo make deinstall install clean
    else
        echo "Installing Fail2Ban without deinstalling the current version..."
        sudo make install clean
    fi

    if [ $? -eq 0 ]; then
        echo "Fail2Ban installed successfully."
    else
        echo "Failed to install Fail2Ban."
        exit 1
    fi


    # Step 2: Check for the Service Script
    echo "Checking if the Fail2Ban service script exists..."
    if [ -f /usr/local/etc/rc.d/fail2ban ]; then
        echo "Fail2Ban service script found."
    else
        echo "Fail2Ban service script not found. Installation might have failed."
        exit 1
    fi

    # Step 3: Enable Fail2Ban at Startup
    echo 'Enabling Fail2Ban service at startup...'
    sudo sysrc fail2ban_enable="YES"
    if [ $? -eq 0 ]; then
        echo "Fail2Ban service enabled in /etc/rc.conf."
    else
        echo "Failed to enable Fail2Ban service in /etc/rc.conf."
        exit 1
    fi

    # Step 4: Configure Fail2Ban for SSH
    echo "Configuring Fail2Ban for SSH monitoring..."

    # File to modify
    CONFIG_FILE="/usr/local/etc/fail2ban/jail.local"

    # Ensure jail.local file exists
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Copying default jail configuration to jail.local..."
        sudo cp /usr/local/etc/fail2ban/jail.conf "$CONFIG_FILE"
        if [ $? -eq 0 ]; then
            echo "Copied successfully."
        else
            echo "Failed to copy jail configuration."
            exit 1
        fi
    fi

    # Function to update the [sshd] section directly by line numbers using awk
    update_sshd_section_directly() {
        local file="$1"
        echo "Updating the [sshd] section directly by line numbers..."

        # Define the line range
        line_range=$(awk '/^\[sshd\]/ {start = NR; next} start && /^\[/ {print start, NR - 1; exit}' /usr/local/etc/fail2ban/jail.conf)
        local start_line=$(echo $line_range | cut -d ' ' -f 1)
        local end_line=$(echo $line_range | cut -d ' ' -f 2)

        echo "Start line: $start_line"
        echo "End line: $end_line"
    
        # Ensure we remove any potential duplicate section headers
        # Remove the section first
        sed -i '' "${start_line},${end_line}d" "$file"

        # Use awk to replace a specific line range with new content
        awk -v start="$start_line" -v end="$end_line" '
        NR == start+1 {
            print "enabled = true"
            print "port = ssh"
            print "filter = sshd"
            print "logpath = /var/log/auth.log"
            print "maxretry = 3"
            print "bantime = 1h"
            print "mode = normal"
            print "backend = %(sshd_backend)s"
        }
        NR < start || NR > end
        ' "${file}" > "$file"
    }

    # Apply the configuration
    update_sshd_section_directly "$CONFIG_FILE"

    if [ $? -eq 0 ]; then
        echo "SSH configuration updated successfully in $CONFIG_FILE."
    else
        echo "Failed to update SSH configuration."
        exit 1
    fi

    # Reload Fail2Ban to apply changes
    sudo fail2ban-client reload
    echo "Fail2Ban configuration reloaded."


    # Step 5: start Fail2Ban Service
    echo "Starting the Fail2Ban service..."
    sudo service fail2ban start
    if [ $? -eq 0 ]; then
        echo "Fail2Ban service started successfully."
    else
        echo "Failed to start Fail2Ban service."
        exit 1
    fi

    # Step 6: Verify Fail2Ban SSH Jail Status
    echo "Verifying SSH jail status in Fail2Ban..."
    sudo fail2ban-client status sshd
    if [ $? -eq 0 ]; then
        echo "SSH jail is active and monitored by Fail2Ban."
    else
        echo "Failed to verify SSH jail status."
    fi

    # Step 7: Provide Useful Fail2Ban Commands
    echo "Fail2Ban setup is complete. Here are some useful commands to manage and view banned clients:"
    echo "| Description                                | Command                                      |"
    echo "|--------------------------------------------|----------------------------------------------|"
    echo "| List all active jails                      | sudo fail2ban-client status                  |"
    echo "| Check status of a specific jail (e.g., sshd)| sudo fail2ban-client status sshd             |"
    echo "| List banned IPs in a specific jail         | sudo fail2ban-client status sshd             |"
    echo "| Unban an IP address in a specific jail     | sudo fail2ban-client set sshd unbanip <IP>   |"

    echo "Fail2Ban has been configured and is monitoring SSH. You can manage jails and banned clients using the commands listed above."

    # Final step to handle socket access issues if needed
    echo "Checking socket permissions..."
    if [ ! -d /var/run/fail2ban ]; then
        sudo mkdir -p /var/run/fail2ban
    fi
    sudo chown -R root:wheel /var/run/fail2ban
    sudo chmod 755 /var/run/fail2ban
    if [ $? -eq 0 ]; then
        echo "Socket directory permissions set correctly."
    else
        echo "Failed to set socket directory permissions."
        exit 1
    fi

else
    echo "Skipping Section."
fi

echo "SECTION IV"
echo "Checking if the PostgreSQL service script exists..."
if [ -f /usr/local/etc/rc.d/postgresql ]; then
    echo "PostgreSQL service script found."
else
    echo "PostgreSQL service script not found. Please check the installation."
    exit 1
fi

echo 'Enabling PostgreSQL service at startup...'
sudo sysrc postgresql_enable="YES"
if [ $? -eq 0 ]; then
    echo "PostgreSQL service enabled in /etc/rc.conf."
else
    echo "Failed to enable PostgreSQL service in /etc/rc.conf."
    exit 1
fi

# Step 3: Check if PostgreSQL is already running
echo "Checking if PostgreSQL is already running..."
if pgrep -x "postgres" > /dev/null; then
    echo "PostgreSQL is already running. Skipping initialization and startup."
    skip_initdb=true
else
    echo "PostgreSQL is not running. Proceeding with initialization and startup."
    skip_initdb=false
fi

# Step 4: Initialize the Database Cluster (if not already running)
if [ "$skip_initdb" = false ]; then
    echo "Initializing the PostgreSQL database cluster..."

    # Define the data directory
    DATA_DIR="/var/db/postgres/data14"

    if [ -d "$DATA_DIR" ] && [ "$(ls -A $DATA_DIR)" ]; then
        echo "Directory $DATA_DIR exists and is not empty."
        if prompt_yes_no "Do you want to remove the existing data directory and reinitialize the database cluster?"; then
            sudo rm -rf "$DATA_DIR"
            echo "Existing data directory removed."
        else
            echo "Skipping database cluster initialization."
            skip_initdb=true
        fi
    else
        echo "Directory $DATA_DIR does not exist or is empty. Proceeding with initialization."
        skip_initdb=false
    fi

    if [ "$skip_initdb" = false ]; then
        sudo /usr/local/etc/rc.d/postgresql initdb
        if [ $? -eq 0 ]; then
            echo "Database cluster initialized successfully."
        else
            echo "Failed to initialize database cluster."
            exit 1
        fi
    else
        echo "Database cluster initialization skipped."
    fi

    # Start PostgreSQL Server (if not already running)
    echo "Starting the PostgreSQL server..."
    sudo /usr/local/etc/rc.d/postgresql start
    if [ $? -eq 0 ]; then
        echo "PostgreSQL server started successfully."
    else
        echo "Failed to start PostgreSQL server."
        exit 1
    fi
else
    echo "Skipping initialization and startup since PostgreSQL is already running."
fi


echo "SECTION V"
if prompt_yes_no "Do you want to setup Timezone?"; then
    sudo tzsetup
    echo "Verifying the timezone setting..."
    date
else
    echo "Skipping timezone configuration."
fi

if prompt_yes_no "Do you want to update the timezone data?"; then
    sudo freebsd-update fetch install
else
    echo "Skipping timezone data update."
fi


echo "SECTION VI"
if prompt_yes_no "Do you want to set up asdf environment variables in .bashrc?"; then
    echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
    echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
    echo "asdf environment variables added to .bashrc."
else
    echo "Skipping asdf environment setup."
fi

# Git clone asdf
if prompt_yes_no "Do you want to clone the asdf repository?"; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    echo "asdf repository cloned."
    source "$HOME/.asdf/asdf.sh"
    source "$HOME/.asdf/completions/asdf.bash"
else
    echo "Skipping asdf repository cloning."
fi

#  Install Elixir
if prompt_yes_no "Do you want to install Elixir using asdf?"; then
    asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
    read -p "Enter the version of Elixir to install (e.g., 1.14.3-otp-24): " elixir_version
    asdf install elixir $elixir_version
    asdf global elixir $elixir_version
    echo "Elixir $elixir_version installed and set as global version."
else
    echo "Skipping Elixir installation."
fi


# Check for the initial prompt for Erlang installation
if prompt_yes_no "Do you want to install Erlang using asdf and handle known issues?"; then
    # Ask about compiling wxWidgets
    if prompt_yes_no "Do you want to fix wxWidgets dependency for Erlang?"; then
        echo "Fixing wxWidgets dependency for Erlang..."
        cd /usr/local/src
        git clone --recurse-submodules --depth 1 --branch 3.2 https://github.com/wxWidgets/wxWidgets.git
        cd wxWidgets
        ./configure --with-gtk=3 --enable-webview --enable-unicode --prefix=/usr/local
        gmake && sudo gmake install
        if [ $? -eq 0 ]; then
            wx-config --version
            echo "wxWidgets installed successfully."
        else
            echo "Failed to install wxWidgets."
            exit 1
        fi
    fi

    # Ask about compiling OpenSSL
    if prompt_yes_no "Do you want to compile OpenSSL?"; then
        git clone -b OpenSSL_1_1_1-stable --single-branch https://github.com/openssl/openssl.git
        cd openssl
        ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib
        gmake && gmake test && sudo gmake install
        if [ $? -eq 0 ]; then
            echo "OpenSSL compiled and installed."
        else
            echo "Failed to compile OpenSSL."
            exit 1
        fi
    fi

    # Ensure the environment variables are set correctly for Erlang installation
    export KERL_CONFIGURE_OPTIONS="--with-wx-config=/usr/local/bin/wx-config --with-ssl=/usr/local/ssl"
    echo "Environment variables set for Erlang installation."


    # Install Erlang
    echo "Installing Erlang using asdf..."
    asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
    read -p "Enter the version of Erlang to install (e.g., 24.0): " erlang_version
    asdf install erlang $erlang_version
    asdf global erlang $erlang_version
    echo "Erlang $erlang_version installed and set as global version."
else
    echo "Skipping Erlang installation."
fi



# Verify Installation of Elixir and Erlang
if prompt_yes_no "Do you want to verify the installation of Elixir and Erlang?"; then
    elixir -v
    erl -version
else
    echo "Skipping verification."
fi

if prompt_yes_no "Do you want to install and configure the Wazuh Agent?"; then
    echo "Downloading Wazuh Agent..."
    curl -Ls https://github.com/wazuh/wazuh/archive/v4.3.10.tar.gz | tar zx

    echo "Building Wazuh Agent dependencies..."
    cd $HOME/wazuh-4.3.10/src
    gmake deps

    echo "Building the Wazuh Agent package..."
    gmake TARGET=agent

    echo "Wazuh Agent installation and configuration completed."
else
    echo "Skipping Wazuh Agent installation."
fi


echo "Script execution completed."

