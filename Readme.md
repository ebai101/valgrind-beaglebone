# Valgrind for BeagleBone Black

Instructions for building valgrind-3.9.0 for the BeagleBone Black using Vagrant. This tested on a Windows 8.1 host system running Vagrant 1.6.3.

## Vagrant Box Details

* Uses 'hashicorp/precise32' Ubuntu 12.04 LTS 32-bit base box
* Provisioning done via shell
    - Installs build-essentials plus other basic build tools
    - Installs selected ARM toolchain
    - Downloads and unpacks valgrind-3.9.0 sources from http://valgrind.org/downloads/valgrind-3.9.0.tar.bz2
    - Copies two build scripts into valgrind source directory to ease compilation and packing completed binaries

## Configuring 

This environment is setup to build using either the ARM toolchain in the Ubuntu repositories (arm-linux-gnueabi) or using Mentor Graphics Sourcery CodeBench Lite toolchain (arm-none-linux-gnueabi).  

To select between the two uncomment either line 23 or 24 in `Vagrantfile`

* Ubuntu ARM toolchain: `crosscompiler = 'ubuntu'`
* Sourcery CodeBench: `crosscompiler = 'sourcery'`

**Note:** Sourcery CodeBench Lite must be downloaded separately from [Mentor Graphics](http://www.mentor.com/embedded-software/sourcery-tools/sourcery-codebench/editions/lite-edition/) (registration required, free download). Provisioning configured for the 2014.05-29 release. Download the 'IA32 GNU/Linux TAR' file and place the resulting .tar.bz2 file (e.g. arm-2014.05-29-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2) into this folder.

The Ubuntu ARM toolchain does make smaller binaries (157MB vs 204MB for the entire build directory).

## Building Valgrind

* Clone this repository
* Start vagrant: `vagrant up`. This will download the 'hashicorp/precise32' box if it's not already available, create the VM instance, and provision it according to the selected toolchain.
* SSH into the new box: `vagrant ssh`
* Navigate to the valgrind source directory: `$ cd ~/valgrind-3.9.0`
* Run the build script: `$ ./beaglebone-build.sh`
* Valgrind binaries will be installed to `/opt/valgrind`.  **Note:** the prefix path is embedded into the valgrind binaries so you'll need to install the binaries to the same location on the BBB or add a simlink.
* To package the binaries and move them outside of the vagrant environment, run the postbuild script: `$ ./beaglebone-postbuild.sh`.  This will create `valgrind-beaglebone.tar.gz` in the host root directory (the same folder as this Readme).

## Deploying Valgrind to a BBB

Valgrind is a large binary (>150MB or >200MB depending on the toolchain choice) so if you have one of the older 2 GB eMMC BBBs, you may want to store the binaries on a uSD card.  Instructions for setting one up can be found [here](http://elinux.org/Beagleboard:MicroSD_As_Extra_Storage).  I'll describe deployment to the uSD card below.

* Copy binaries to BBB: `scp vagrant-beaglebone.tar.gz root@<beaglebone ip address>:/media/BEAGLEBONE/.`
* SSH into BBB: `ssh root@<beaglebone ip address>`
* Unpack binaries to uSD card: `cd /media/BEAGLEBONE; tar -xzvf valgrind-beaglebone.tar.gz`
* Since the valgrind binaries require installation to `/opt/valgrind`, we'll create a simlink to the uSD install: `ln -s /media/BEAGLEBONE/opt/valgrind /opt/valgrind`
* If you want to use valgrind from remote GUI tools such as Qt Creator, you might also want to simlink valgrind into the default system path (Qt Creator in Windows won't allow '/' in the valgrind path): `ln -s /opt/valgrind/bin/valgrind /usr/bin/valgrind`

## Prebuild Binaries

Prebuild binaries for the BeagleBone are provided in separate branches:

* Branch 'build-sourcery': Sourcery CodeBench Lite build, `valgrind-beaglebone-sourcerycodebenchlite.tar.gz`
* Branch 'build-ubuntu': Ubuntu ARM build, `valgrind-beaglebone-ubuntuarm.tar.gz`