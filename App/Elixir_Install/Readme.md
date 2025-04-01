
# Elixir Installation Guide

## Prerequisites

1. **Install Git**
    ```bash
    sudo apt-get install git
    ```

2. **Install asdf**
    Follow the instructions on the [asdf documentation](https://asdf-vm.com/guide/getting-started.html).

3. **Install Dependencies**
    ```bash
    sudo apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libwxgtk-webview3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk
    ```

## Install Erlang

4. **Add Erlang Plugin**
    ```bash
    asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
    ```

5. **Install Erlang**
    ```bash
    asdf install erlang 25.3.2
    ```

## Install Elixir

6. **Add Elixir Plugin**
    ```bash
    asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
    ```

7. **Install Elixir**
    ```bash
    asdf install elixir 1.15.5-otp-25
    ```

## Install Node.js

8. **Add Node.js Plugin**
    ```bash
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    ```

9. **Install Node.js**
    ```bash
    asdf install nodejs 18.18.2
    ```
