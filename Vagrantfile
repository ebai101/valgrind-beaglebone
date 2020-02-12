# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "hashicorp/precise32"

  # This vagrant box will allow you to build valgrind using either 
  # the arm toolchain in the Ubuntu repositories (arm-linux-gnueabi) or
  # Mentor Graphics Sourcery Codebench Lite (arm-none-linux-gnueabi).
  #
  # Note: using Sourcery Codebench requires the Linux binaries for ARM to be 
  # externally downloaded. See Readme.md for more details
  #
  # Uncomment one of the following two lines to select compiler.
  # crosscompiler = 'sourcery'
  crosscompiler = 'ubuntu'

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "valgrind-3.9.0", "/valgrind_source"
  
  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with CFEngine. CFEngine Community packages are
  # automatically installed. For example, configure the host as a
  # policy server and optionally a policy file to run:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.am_policy_hub = true
  #   # cf.run_file = "motd.cf"
  # end
  #
  # You can also configure and bootstrap a client to an existing
  # policy server:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.policy_server_address = "10.0.2.15"
  # end

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.
  #
  # config.vm.provision "puppet" do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "site.pp"
  # end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision "chef_solo" do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { mysql_password: "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision "chef_client" do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"

  # Tried these, but wouldn't work for BBB: gcc-arm-linux-gnueabi g++-arm-linux-gnueabi cpp-arm-linux-gnueabi
    # install some packages via apt-get
  $script = <<SCRIPT
echo "I am provisioning..."
date > /etc/vagrant_provisioned_at
echo "Updating package listings"
sudo apt-get update
echo "Installing basic build packages"
sudo apt-get install -y subversion build-essential libncurses5-dev zlib1g-dev gawk git ccache gettext libssl-dev xsltproc dos2unix
echo "Finished provisioning"
SCRIPT
  config.vm.provision "shell", inline: $script


  if crosscompiler == 'sourcery'
  # if using sourcery codebench lite
    $script = <<SCRIPT
echo "Installing Beaglebone ARM toolchain (arm-none-linux-gnueabi)"
cp /vagrant/arm-2014.05-29-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2 /home/vagrant/.
cd /home/vagrant
bzip2 -d arm-2014.05-29-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
tar -xf arm-2014.05-29-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar
echo "Finished toolchain provisioning"
SCRIPT
    config.vm.provision "shell", inline: $script
  else
# if using gcc-arm-linux-gnueabi from Ubuntu sources
  $script = <<SCRIPT
echo "Installing Beaglebone ARM toolchain (arm-linux-gnueabi)"
sudo apt-get install -y gcc-arm-linux-gnueabi g++-arm-linux-gnueabi cpp-arm-linux-gnueabi 
echo "Finished toolchain provisioning"
SCRIPT
  config.vm.provision "shell", inline: $script
  end

   $script = <<SCRIPT
echo "Starting valgrind specific provisioning"
echo "Downloading valgrind sources"
cd /home/vagrant
wget -q http://valgrind.org/downloads/valgrind-3.9.0.tar.bz2
echo "Download complete"
echo "Unpacking valgrind"
bzip2 -d valgrind-3.9.0.tar.bz2
tar -xf valgrind-3.9.0.tar
echo "Copying build scripts"
cp /vagrant/beaglebone-build.sh /home/vagrant/valgrind-3.9.0/.
dos2unix /home/vagrant/valgrind-3.9.0/beaglebone-build.sh
chown vagrant:vagrant /home/vagrant/valgrind-3.9.0/beaglebone-build.sh
cp /vagrant/beaglebone-postbuild.sh /home/vagrant/valgrind-3.9.0/.
dos2unix /home/vagrant/valgrind-3.9.0/beaglebone-postbuild.sh
chown vagrant:vagrant /home/vagrant/valgrind-3.9.0/beaglebone-postbuild.sh
echo "Finished provisioning"
echo "Usage: "
echo "   - Run ./beaglebone-build.sh in /home/vagrant/valgrind-3.9.0 to build valgrind"
echo "   - Run ./beaglebone-postbuild.sh in /home/vagrant/valgrind-3.9.0 to package binaries as valgrind-beaglebone.tar.gz in /vagrant"
SCRIPT
  config.vm.provision "shell", inline: $script

end
