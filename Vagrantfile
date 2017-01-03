#-*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
config.vm.box = "ubuntu/trusty64"
config.vm.network "private_network", ip: "192.168.33.10", auto_correct: true
config.vm.synced_folder "data", "/var/www/html"
config.vm.synced_folder "ebot", "/home/install"
config.vm.provision "fix-no-tty", type: "shell" do |s|
config.vm.synced_folder "transport", "/transport"
  s.privileged = false
  s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
end
config.vm.provider "virtualbox" do |vb|
#   # Display the VirtualBox GUI when booting the machine
#   vb.gui = true
#
#   # Customize the amount of memory on the VM:
  vb.memory = "2048"
  end

config.vm.provision "shell" do |s|
s.path = "../ebot.sh"
end
end
