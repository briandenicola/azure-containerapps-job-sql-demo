#!/bin/bash

# this runs at Codespace creation - not part of pre-build

echo "$(date)    post-create start" >> ~/status

#Install jq
apt update
apt install -y jq

#Install Taskdev
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
echo 'export PATH=$PATH:~/.local/bin' >> ~/.zshrc

#Install az extensions
sudo az aks install-cli -y
sudo az extension add --name application-insights -y
sudo az extension add --name aks-preview -y

echo "$(date)    post-create complete" >> ~/status
