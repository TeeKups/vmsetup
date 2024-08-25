# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "jkupiainen/debian12"
  config.ssh.private_key_path = "./keys/id_ed25519"
  config.ssh.key_type = :ed25519

  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 5000, host: 5000
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  config.vm.synced_folder ".", "/vagrant", 
    type: "smb",
    smb_password: "samba",
    smb_username: "samba"

  config.vm.provider "hyperv" do |hyperv|
    hyperv.cpus = 6
    hyperv.enable_virtualization_extensions = true
    hyperv.enable_checkpoints = true
    hyperv.enable_automatic_checkpoints = false
    hyperv.enable_enhanced_session_mode = true
    hyperv.maxmemory = 8192
    hyperv.memory = 2048
    hyperv.vmname = "jkupiainen_debian12"
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get upgrade -y
    apt-get install -y pipx
    pipx install ansible
    export PATH="$PATH:$HOME/.local/pipx/venvs/ansible/bin"
    cd /vagrant/ansible
    ansible-playbook -i inventories/devenv -e host_ip=172.29.240.1 -e user=juhani -e dwm=False -e gnome=False site.yml
  SHELL
end
