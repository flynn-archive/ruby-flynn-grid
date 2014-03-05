# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

def docker_args(follower)
  args = "-v=/var/run/docker.sock:/var/run/docker.sock -p=1113:1113"
  args += " -e=ETCD_PEERS=10.47.2.10:55001" if follower
  args
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "flynn-precise64"
  config.vm.box_url = "https://s3.amazonaws.com/flynn/flynn-virtualbox-ubuntu_12.04.3-amd64.box"
  config.vm.box_download_checksum = "d222d515e83e0d8a547c55f9e5cbaec703fd414f0d761193d9fee1c6066504cf"
  config.vm.box_download_checksum_type = "sha256"

  config.vm.define "n0" do |n|
    n.vm.network "private_network", ip: "10.47.2.10"
    n.vm.provision "docker" do |d|
      d.run "flynn/host", args: docker_args(false), cmd: "-external 10.47.2.10 -attribute name=n0"
    end
  end

  config.vm.define "n1" do |n|
    n.vm.network "private_network", ip: "10.47.2.11"
    n.vm.provision "docker" do |d|
      d.run "flynn/host", args: docker_args(true), cmd: "-external 10.47.2.11 -attribute name=n1"
    end
  end

  config.vm.define "n2" do |n|
    n.vm.network "private_network", ip: "10.47.2.12"
    n.vm.provision "docker" do |d|
      d.run "flynn/host", args: docker_args(true), cmd: "-external 10.47.2.12 -attribute name=n2"
    end
  end
end
