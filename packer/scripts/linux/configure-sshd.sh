#!/usr/bin/env -S bash -eu
# basic sshd configuration

echo ">> Configuring SSH..."
sudo sed -i 's/.*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/.*PubKeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/.*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# On Ubuntu 24.04, cloud-init owns /etc/ssh/sshd_config.d/50-cloud-init.conf and
# re-creates it with PasswordAuthentication no on each boot (since ssh_pwauth defaults
# to false). This drop-in tells cloud-init to keep password auth enabled.
echo "ssh_pwauth: true" | sudo tee /etc/cloud/cloud.cfg.d/99-packer-ssh.cfg > /dev/null
