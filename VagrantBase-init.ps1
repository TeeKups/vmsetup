<#
.SYNOPSIS
    VagrantBase-init automatically gets a Hyper-V base box ready after a fresh installation.
.DESCRIPTION
    VagrantBase-init automatically gets a Hyper-V base box ready after a fresh installation.

    Guest requirements:
        - ssh server
        - User 'vagrant' with password 'vagrant'
            - Should have privileges to run commands as root via 'sudo' 

    Host requirements:
        - python
        - awk
        - sed

    Supported guest operating systems:
        - Debian 12
.PARAMETER IP
    IP Address of the target guest machine
.PARAMETER KEY
    (Optional) Path to the private key file used for ssh-ing into the guest machine
.EXAMPLE
    .\VagrantBase-init.ps1 172.29.240.10
.NOTES
    Author: Juhani Kupiainen
    Date:   25.08.2024
#>
param(
    [Parameter(Mandatory=$true)][string] $ip,
    [string] $key = ".\keys\id_ed25519"
)
$host_ip=$(netsh interface ip show config name="vEthernet (Default Switch)" | findstr "IP Address" | awk -F' ' '{ print $3 }')
echo "Log onto guest machine as 'vagrant' and run the following commands:"
echo "    mkdir -p `$HOME/.ssh"
echo "    wget $host_ip`:8000/$( echo $key | sed -e 's@^\.\\@@' -e 's@\\@/@g' ).pub -O `$HOME/.ssh/authorized_keys"
echo "    chmod 0700 `$HOME/.ssh"
echo "    chmod 0600 `$HOME/.ssh/*"
$processOptions = @{
    FilePath = "python"
    WorkingDirectory = "$PSScriptRoot"
    ArgumentList = "-m", "http.server", "-d", "$PSScriptRoot", "8000"
    PassThru = $true
    WindowStyle = "Hidden"
}
$process = Start-Process @processOptions

echo ""
Read-Host -Prompt "Press any key to continue or CTRL+C to quit" | Out-Null
$process.kill()

echo ""
echo "You will now be prompted for the password for user 'vagrant'"
echo "The password is 'vagrant'"
echo ""

ssh vagrant@$ip -i $key ":
    sudo -S echo 'vagrant ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/vagrant
    sudo sed 's/#\(UseDNS\).*/\1 yes/' -i /etc/ssh/sshd_config

    sudo apt-get install -y \
    xrdp \
    hyperv-daemons \
    cifs-utils

    sudo groupadd -r samba
    samba_gid=`"`$(getent group samba | cut -d: -f3)`"
    sudo usermod -a -G samba vagrant

    sudo systemctl stop xrdp
    sudo systemctl stop xrdp-sesman

    sudo sed 's@port=3389@port=vsock://-1:3389@g' -i /etc/xrdp/xrdp.ini
    sudo sed 's/security_layer=negotiate/security_layer=rdp/g' -i /etc/xrdp/xrdp.ini
    sudo sed 's/crypt_level=high/crypt_level=none/g' -i /etc/xrdp/xrdp.ini
    sudo sed 's/bitmap_compression=true/bitmap_compression=false/g' -i /etc/xrdp/xrdp.ini
    sudo sed 's/FuseMountName=thinclient_drives/FuseMountName=shared-drives/g' -i /etc/xrdp/sesman.ini
    sudo sed 's/allowed_users=console/allowed_users=anybody/g' -i /etc/X11/Xwrapper.config

    echo 'blacklist vmw_vsock_vmci_transport' | sudo tee /etc/modprobe.d/blacklist-vmw_vsock_vmci_transport.conf
    echo 'hv_sock' | sudo tee /etc/modules-load.d/hv_sock.conf

    sudo systemctl daemon-reload
    sudo systemctl start xrdp"

echo ""
echo "You may now export the VM"