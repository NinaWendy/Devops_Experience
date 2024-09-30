#!/bin/bash

echo "Installing PostgreSQL..."
sudo apt update
sudo apt install -y postgresql

echo "Checking PostgreSQL service status..."
sudo systemctl status postgresql.service
