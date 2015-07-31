
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"


# todo: #1 - dynamic ip using numNodes -- REF http://nitschinger.at/A-Couchbase-Cluster-in-Minutes-with-Vagrant-and-Puppet
# todo: #2 - dynamic creation/deletion of nodes for testing
nodes = [
    {
        :hostname     => 'agent1',
        :ip           => '192.168.0.43',
        :box          => 'ubuntu/trusty64',
        :fport        => "8082",
        :init         => "./puppet/ubuntu_puppet_install_bootstrap.sh",
        :ram          => "2046"
    },
    {
        :hostname     => 'agent2',
        :ip           => '192.168.0.44',
        :box          => 'ubuntu/trusty64',
        :fport        => "8083",
        :init         => "./puppet/ubuntu_puppet_install_bootstrap.sh"
    },
    {
        :hostname     => 'agent3',
        :ip           => '192.168.0.45',
        :box          => 'ubuntu/trusty64',
        :fport        => "8084",
        :init         => "./puppet/ubuntu_puppet_install_bootstrap.sh"
    },
    {
        :hostname     => 'ossim-uvm',
        :ip           => '192.168.0.12',
        :box          => 'ossim',
        :box_url      => 'https://www.dropbox.com/s/2w6jmymqdz5ubhc/ossim.box?dl=0',
        :fport        => "8086",
        :init         => "./puppet/centos_puppet_install_bootstrap.sh" ,
        :ram          => '8096'
    },
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

   # Consistent Execution against all registered nodes
    nodes.each do |node|
        config.vm.define node[:hostname] do |node_config|
          node_config.vm.box = node[:box]
          node_config.vm.host_name = node[:hostname]
         # node_config.vm.network "public_network", bridge: 'en0: Wi-Fi (AirPort)'
          memory = node[:ram] ? node[:ram] : 1024;
          node_config.vm.provider :virtualbox do |vb|
            vb.gui = true
            vb.customize ['modifyvm', :id, '--name', node[:hostname], '--memory', memory.to_s ]
          end
          node_config.vm.network :private_network , ip: node[:ip] # type: "dhcp" - doesn't appear to work
          node_config.vm.synced_folder './', '/tmp/vagrant' # always mount shared folder in /tmp
          node_config.vm.network "forwarded_port", guest: "80", host: node[:fport]
          node_config.vm.provision :shell, path: node[:init], privileged: true #todo: defect - not working for centos
          node_config.vm.post_up_message = "Post Complete message - Yeah!"
        end
    end

    # Run Puppet Manifests
    # todo: application specific environment deployment Deployment REF: http://blog.devteaminc.co/conditional-vagrant-environments/
    # todo: concurrent deployment ref: https://github.com/joemiller/sensu-tests/blob/master/para-vagrant.sh
    config.vm.provision :puppet do |puppet|
                puppet.manifests_path = 'puppet/manifests'
                puppet.module_path    = 'puppet/modules'
                puppet.manifest_file  = 'ossim_build_install.pp'
      # todo: implement v2 role logic
      #         puppet.manifest_file  = 'profile_base.pp'
    end
end