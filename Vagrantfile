# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX = 'ubuntu-14.04-amd64-vbox'
BOX_URL = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/#{BOX}.box"
BOX_MEMORY = ENV['BOX_MEMORY'] || '1024'

MACHINE_IP = ENV['MACHINE_IP'] || '192.168.33.10'

$provision_vagrant = <<SCRIPT
set -ex
echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
apt-get update -qq
apt-get install -q -y --force-yes lxc-docker
usermod -a -G docker vagrant
docker version
SCRIPT

Vagrant.configure('2') do |config|

  config.vm.box = BOX
  config.vm.box_url = BOX_URL

  config.vm.network :private_network, ip: MACHINE_IP
  config.vm.network :forwarded_port, guest: 9292, host: 9292

  config.vm.synced_folder './', '/vagrant'

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']
    vb.customize ['modifyvm', :id, '--memory', BOX_MEMORY]
  end

  config.vm.provision :shell, :inline => $provision_vagrant
end
