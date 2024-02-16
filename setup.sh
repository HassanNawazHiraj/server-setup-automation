#!/bin/bash

echo "Starting setup..."

# Update and upgrade packages
sudo apt update && sudo apt upgrade -y

# Ask user if they want to set up SSH and add it to the firewall
read -p "Do you want to setup firewall (ufw) and only allow ssh port (22)? (recommended) (y/n): " setup_ssh

if [[ $setup_ssh == "y" ]]; then
    # setup ssh
    ./setup-ssh.sh
fi

# Ask user for the username to create
read -p "Do you want to set up a user? (recommended) (Y/n): " setup_user
setup_user=${setup_user:-y}

./create-user.sh

echo "Setup complete."
echo -e "\nPlease login using your new user"
