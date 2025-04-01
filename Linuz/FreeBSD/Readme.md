# FreeBSD_POC

# Update package repository
```
sudo pkg update
```
# Install required packages
```
sudo pkg install -y unzip git curl node npm libxslt libxml2 fop gcc gmake make++-2.0_1 automake autoconf wget tmux libtool ncurses wkhtmltopdf xorg-fonts-7.7_1 xorg-vfbserver
```
```
sudo pkg install autoconf wx30-gtk3 unixodb
```
# Post-installation steps for node-gyp
```
sudo rm /usr/local/bin/node-gyp
```
```
sudo npm install -g node-gyp
```
# Verify installations
```
pkg info unzip git curl node npm libxslt libxml2 fop gcc g++ make automake autoconf 
```
```
wget tmux libtool ncurses wkhtmltopdf xorg-fonts xorg-vfbserver
```
```
which g++
```
```
which node-gyp
```

### Steps to Enable Process Accounting on FreeBSD

1. **Create the Necessary Directory**:
   Ensure the directory `/var/account` exists:
   
    ```sh
    sudo mkdir -p /var/account
    ```

2. **Create the Accounting File**:
   You need to create the accounting file manually before you can use it:

    ```sh
    sudo touch /var/account/pacct
    ```

3. **Enable Process Accounting**:
   Use the `accton` command to start accounting and point it to the created file:

    ```sh
    sudo accton /var/account/pacct
    ```

4. **Verify Process Accounting**:
   Run some commands to generate activity, and then use `lastcomm` to check the accounting log:

    ```sh
    ls
    echo "Testing process accounting"
    lastcomm -f /var/account/pacct
    ```

### Complete Steps Recap

Here are the complete commands you should run:

```sh
sudo mkdir -p /var/account
sudo touch /var/account/pacct
sudo accton /var/account/pacct
ls
echo "Testing process accounting"
lastcomm -f /var/account/pacct
```

### Additional Configuration for Boot

To ensure that process accounting starts automatically at boot, add the following to `/etc/rc.conf`:

```sh
echo 'accounting_enable="YES"' | sudo tee -a /etc/rc.conf
```
---------
fail2ban 
```sh
sudo portsnap fetch update
cd /usr/ports/security/py-fail2ban
sudo make deinstall install clean
```

2. **Check for the Service Script**:
   After installation, check that the service script has been created:
   
    ```sh
    ls /usr/local/etc/rc.d/fail2ban
    ```

#### Configure and Enable the Service
If the script is present, configure and enable Fail2Ban:

1. **Add Fail2Ban to Startup**:
   To ensure Fail2Ban starts on boot, add the following line to your `/etc/rc.conf`:

    ```sh
    echo 'fail2ban_enable="YES"' | sudo tee -a /etc/rc.conf
    ```

2. **Start the Service**:
   Now try to start the service again:
   
    ```sh
    sudo service fail2ban start
    ```

3. **Verify that Fail2Ban is Running**:
   Check that the service has started and is functioning:

    ```sh
    sudo fail2ban-client status
    ```

#### Address Socket Access Issue
If you still see errors about accessing the socket:

1. **Check Socket Permissions**:
   Ensure the directory and socket file `/var/run/fail2ban/fail2ban.sock` have the correct permissions. Fail2Ban usually runs as a non-root user but needs access to its own files.

    ```sh
    sudo ls -l /var/run/fail2ban/
    ```

    If the directory or socket does not exist or has incorrect permissions, you may need to manually adjust them or ensure the service creates them correctly when started.

2. **Ensure Correct Configuration**:
   Check your Fail2Ban configuration files (usually located in `/usr/local/etc/fail2ban/`) to ensure they are set up correctly and reference the correct paths and settings.


## SETUP FAIL2BAN 

Great! It looks like Fail2Ban is running correctly on your FreeBSD system. Now, you need to configure it to monitor and protect specific services. Here’s how to set up a jail for SSH, which is a common use case.

### Configure Fail2Ban for SSH

1. **Copy the Default Configuration**:
   If you haven't already, copy the default configuration file to the working configuration file:

   ```sh
   sudo cp /usr/local/etc/fail2ban/jail.conf /usr/local/etc/fail2ban/jail.local
   ```

### Commands Recap

1. **Edit Jail Configuration**:

   ```sh
   sudo nano /usr/local/etc/fail2ban/jail.local
   ```

   Add:

   ```ini
   [sshd]
   enabled = true
   port = ssh
   filter = sshd
   logpath = /var/log/auth.log
   maxretry = 3
   bantime = 1h
   ```

2. **Restart Fail2Ban**:

   ```sh
   sudo service fail2ban restart
   ```

3. **Verify Jail Status**:

   ```sh
   sudo fail2ban-client status sshd
   ```

4. **Simulate Failed Logins**:

   ```sh
   ssh wronguser@localhost
   ```

5. **Check Banned IPs**:

   ```sh
   sudo fail2ban-client status sshd
   ```

**ONLY FOLLOW THE STEPS BELOW IF THERE IS AN ERROR OR ISSUE**

6. **Restart Fail2Ban**:

   ```sh
   sudo service fail2ban restart
   ```

7. **Ensure Socket Directory Exists and Has Correct Permissions**:

   ```sh
   sudo mkdir -p /var/run/fail2ban
   sudo chown -R root:wheel /var/run/fail2ban
   sudo chmod 755 /var/run/fail2ban
   ```

8. **Start Fail2Ban**:

   ```sh
   sudo service fail2ban start
   ```

9. **Verify Socket File**:

   ```sh
   ls -l /var/run/fail2ban/
   ```

## POSTGRESQL 
### Install PostgreSQL Server

1. **Install PostgreSQL Server**:
   Install the PostgreSQL server package:

   ```sh
   sudo pkg install postgresql14-server postgresql14-client
   ```

2. **Verify Installation**:
   Check if the PostgreSQL service script is available in `/usr/local/etc/rc.d/`:

   ```sh
   ls -l /usr/local/etc/rc.d/postgresql
   ```
### Initialize and Start PostgreSQL

3. **Enable PostgreSQL in rc.conf**:
   Add PostgreSQL to your system's startup configuration:

   ```sh
   sudo sysrc postgresql_enable=yes
   ```

4. **Initialize the Database Cluster**:
   Initialize the database cluster:

   ```sh
   sudo /usr/local/etc/rc.d/postgresql initdb
   ```

5. **Start PostgreSQL Server**:
   Start the PostgreSQL server:

   ```sh
   sudo /usr/local/etc/rc.d/postgresql start
   ```

### Set Up and Test PostgreSQL

6. **Switch to the PostgreSQL User**:
   Switch to the `postgres` user to create a database user and a new database:

   ```sh
   sudo su - postgres
   ```

7. **Create a PostgreSQL User**:
   Create a new PostgreSQL user:

   ```sh
   createuser --interactive
   ```

   Follow the prompts to create a new user.

8. **Create a New Database**:
   Create a new database:

   ```sh
   createdb mydatabase
   ```

   Replace `mydatabase` with the name of your desired database.

9. **Test the PostgreSQL Connection**:
   Connect to the PostgreSQL database using the `psql` command-line tool:

   ```sh
   psql -U myuser -d mydatabase
   ```

   Replace `myuser` with your PostgreSQL user and `mydatabase` with the name of your database.

## INSTALLING AND CONFIGURING TZ.DATA
### Configure System Timezone

1. **Run tzsetup**:
   This command allows you to set the system timezone interactively:

   ```sh
   sudo tzsetup
   ```

   Follow the prompts to select your region and timezone.

2. **Verify Timezone Setting**:
   After setting the timezone, you can verify it using the `date` command:

   ```sh
   date
   ```

### Updating Timezone Data

If you need to ensure your timezone data is up-to-date, FreeBSD updates this data through its regular updates. You can ensure you have the latest updates by running:

```sh
sudo freebsd-update fetch install
```


## Elixir & Erlang

1. **Install bash** : (this command installs bash to freebsd and then changes the shell to bash for the root user)
```sh 
pkg install bash && chsh -s /usr/local/bin/bash root
```
NB : Switching between shell to switch back to csh just type ``` csh ``` and to switch to Bash type ``` bash ```
     To set the default shell as bash use the command ``` chsh -s /usr/local/bin/bash ``` and for csh use ``` chsh -s /bin/csh ```
     By maintaining and adjusting these files, you can ensure each shell behaves as you expect when you switch to it.
        This files are :
                1. ** Bash **:``` .bashrc, .bash_profile```
                2. ** Csh **: ``` .cshrc, .login ```

2. **Set the environment variables**:
- Add asdf to Bash Configuration --> Add the following lines to .bashrc to ensure asdf is initialized in each new shell session:
add the following
```
# Set asdf environment
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
```

3. **Git clone asdf **:
```
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
```

4. **Install Elixir**:
```
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir 1.14.3-otp-24 
asdf global elixir 1.14.3-otp-24
asdf install elixir 1.12.2-otp-24
asdf global elixir 1.12.2-otp-24

```
5. **Install Erlang**:
```
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf install erlang 24.0
```
6. ** Verify Installation ** :
```
elixir -v
erlang -version
```

7. **Fixing erlang issues**:
Clone the repository from GitHub using the 3.2 branch:
-> https://github.com/wxWidgets/wxWidgets/archive/refs/tags/v3.2.5.tar.gz
```
cd /usr/local/src  # Navigate to the source directory
git clone --recurse-submodules --depth 1 --branch 3.2 https://github.com/wxWidgets/wxWidgets.git
cd wxWidgets
```
**Configure the Build** : 
```
./configure --with-gtk=3 --enable-webview --enable-unicode --prefix=/usr/local
```
**Compile and install wxWidgets:**:
```
gmake
gmake install
```
**test the wx-config **
```
wx-config --version
```

=================================================================================================================================================================
## FIXING A MISSING DEPENDANCY KERL 

1.**Clone the repository**:
        ```
        git clone https://github.com/kerl/kerl.git ~/.kerl
        ```

2.** Make sure kerl is executable**
```
chmod a+x ~/.kerl/kerl
```

3. ** Add kerl to the PATH (for bash) **
```
echo 'export PATH="$HOME/.kerl:$PATH"' >> ~/.bashrc
source ~/.bashrc
```
4. ** OR Add kerl to the PATH (for zsh) **
```
echo 'export PATH="$HOME/.kerl:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

5. ** Verify kerl **
```
which kerl

```
6. **Test kerl**
```
kerl
```
=================================================================================================================================================================

## If Erlang is not building use the github link below to fix the issue

First issue:

```
https://github.com/erlang/otp/commit/c2eb69239622046093c25e986dd606ea339c59a9?diff=unified&w=0
```

Second issue:
```
https://github.com/asdf-vm/asdf-erlang/issues/257
```

1. **Set Environment Variables:**
   You're on the right path with setting environment variables. Since the OpenSSL version is the system default, it's likely in the `/usr/local` directories. Configure your environment variables like this:
   ```sh
   export CFLAGS="-O2 -g -I/usr/local/include"
   export LDFLAGS="-L/usr/local/lib"
   export KERL_CONFIGURE_OPTIONS="--with-ssl=/usr/local"
   ```

2. **Verify OpenSSL Path with Command:**
   Check the version of OpenSSL to ensure it’s the one you’re referencing:
   ```sh
   openssl version
   ```

3. **Proceed with Erlang Installation:**
   Now that the environment variables are correctly set up, proceed with installing Erlang:
   ```sh
   asdf install erlang 24.0
   ```

## FINALIZING ERLANG AND ELIXIR INSTALLATION
1. **Set Erlang Version in asdf:**
   You need to specify which version of Erlang `asdf` should use. This is done by adding it to the `.tool-versions` file in your home directory. Open or create this file and add the following line:
   ```sh
   echo "erlang 24.0" >> ~/.asdf/.tool-versions
   ```

2. **Set Elixir Version (if installed):**
   Similarly, if you have Elixir installed, specify its version. If you've not yet installed Elixir, you can skip this step. Assuming you want to use Elixir 1.12.3, for example:
   ```sh
   echo "elixir 1.12.3" >> ~/.asdf/.tool-versions
   ```

3. **Test the Installation:**
   After setting the versions, test again to ensure they are recognized:
   ```sh
   erl -version
   elixir -v
   ```
## NB 
. **Install Specific Versions of Elixir:**
   ```sh
   asdf install elixir 1.14.3-otp-24
   asdf install elixir 1.12.2-otp-24
   ```

. **Set a Global Default:**
   You can set a global version for all projects, or specify locally for individual projects:
   ```sh
   asdf global elixir 1.14.3-otp-24  # Sets 1.14.3-otp-24 as the default globally
   ```

. **Switching Between Versions:**
   When you need to switch to another version for a specific project:
   ```sh
   asdf local elixir 1.12.2-otp-24  # Sets 1.12.2-otp-24 just for the current directory
   ```
   and
   ``` 
   asdf local elixir 1.14.3-otp-24  # Sets 1.12.2-otp-24 just for the current directory
   ```

## INSTALL AND CONFIGURE THE WAZUH AGENT 

1. Step 1 : Download the required version of wazuh
```
 curl -Ls https://github.com/wazuh/wazuh/archive/v4.3.10.tar.gz | tar zx
```

2. Go to the src folder and build the dependancies :
```
cd $HOME/wazuh-4.3.10/src && gmake deps
```

3. Next BUild the package 
```
gmake TARGET=agent

```

OR 

Run the installation script after getting the dependancies 
```
cd .. && ./install.sh
```

## Starting and stopping wazuh 

1. To start wazuh from the binary run: 
```
/var/ossec/bin/wazuh-control start
```

2. To stop the binary run :
```
/var/ossec/bin/wazuh-control stop
```

** OPTION B **

## ADDING WAZUH AGENT AS A SERVICE TO ALLOW SIMPLICITY 
1. **Open the Service Script:**
   ```sh
   nano /usr/local/etc/rc.d/wazuh-agent
   ```

2. **Ensure the Script Has Correct Content:**
   Make sure the script content matches the following:

   ```sh
   #!/bin/sh
   #
   # PROVIDE: wazuh_agent
   # REQUIRE: DAEMON
   # KEYWORD: shutdown
   #
   # Add the following lines to /etc/rc.conf to enable this service:
   #
   # wazuh_agent_enable="YES"
   #
   . /etc/rc.subr

   name="wazuh_agent"
   rcvar="wazuh_agent_enable"
   command="/var/ossec/bin/wazuh-control"
   start_cmd="${command} start"
   stop_cmd="${command} stop"
   restart_cmd="${command} restart"
   status_cmd="${command} status"

   load_rc_config $name
   run_rc_command "$1"
   ```

3. **Make the Script Executable:**
   Ensure the script is executable by setting the correct permissions:

   ```sh
   chmod +x /usr/local/etc/rc.d/wazuh-agent
   ```

4. **Enable the Service:**
   Ensure the service is enabled in `/etc/rc.conf`:

   ```sh
   echo 'wazuh_agent_enable="YES"' >> /etc/rc.conf
   ```

5. **Start the Service:**
   Start the Wazuh agent service:

   ```sh
   service wazuh-agent start
   ```

### Verify the Service Status:

Check the status of the Wazuh agent to ensure it is running:

```sh
service wazuh-agent status