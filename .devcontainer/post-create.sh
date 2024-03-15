#!/bin/bash

# this runs at Codespace creation - not part of pre-build

echo "$(date)    post-create start" >> ~/status

#Install jq
apt update
apt install -y jq

# Install sqlcmd
curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/prod.list)"
apt-get update
apt-get install -y sqlcmd

#Install Taskdev
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
echo 'export PATH=$PATH:~/.local/bin' >> ~/.zshrc

#Install az extensions
sudo az aks install-cli -y
sudo az extension add --name application-insights -y
sudo az extension add --name log-analytics -y
sudo az extension add --name containerapp -y

echo "$(date)    post-create complete" >> ~/status
