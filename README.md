# Hyper-V vagrant box

Instructions on how to create a Hyper-V box for Vagrant.
The instructions were created with Debian 12 using the netinstaller.

A base box is available at [https://jkupiainen.fi/vagrant/boxes/debian12.box](https://jkupiainen.fi/vagrant/boxes/debian12.box). Feel free to use it.

If you use the above base box, you can skip directly into step 6 in the following instructions.

## Quick reference

1. Create a Generation 2 Debian12 machine in Hyper-V
    * Remember to disable SecureBoot
    * Do NOT install GNOME / any other desktop environment
    * Install SSH
    * Do NOT set root password
    * Create user 'vagrant' with password 'vagrant' 
2. Run '.\VagrantBase-init.ps1' with the IP address off the guest as the argument and follow instructions
    * You can see the IP address in the 'Networking' tab in Hyper-V Manager
3. Export the machine into 'boxes' folder
4. Remove the 'Snapshots' folder 
5. Run commands:
```
cd boxes/<dir> && tar -cvzf ../debian12.box ./* && cd ../..
vagrant box add --provider=hyperv <name> file://$((Get-ChildItem boxes/debian12.box).fullname)
.\pre-vagrant-up.ps1
vagrant up
```

## Use my premade box

You may also use my premade box.
Note that you must use the keys from this repo.

```
vagrant box add http://jkupiainen.fi/vagrant/boxes/debian12/metadata.json
.\pre-vagrant-up.ps1
vagrant up
```
