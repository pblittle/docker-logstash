# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  config.vm.box = "phusion-open-ubuntu-12.04-amd64"
  config.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/ubuntu-12.04.3-amd64-vbox.box"

  config.vm.network :private_network, ip: "192.168.33.10"
  config.vm.network :forwarded_port, guest: 514, host: 514
  config.vm.network :forwarded_port, guest: 9292, host: 9292

  config.vm.synced_folder "./", "/vagrant"

  pkg_cmd = "wget -q -O - https://get.docker.io/gpg | apt-key add -;" \
    "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list;" \
    "apt-get update -qq; apt-get install -q -y --force-yes lxc-docker; "
  pkg_cmd << "usermod -a -G docker vagrant; "

  config.vm.provision :shell, :inline => pkg_cmd
end
