# Valgrind for BeagleBone Black

Instructions for building valgrind-3.9.0 for the BeagleBone Black using Vagrant. Modified by me (Ethan) for macOS and Bela.

## Vagrant Box Details

* Uses 'hashicorp/precise32' Ubuntu 12.04 LTS 32-bit base box
* Provisioning done via shell
    - Installs build-essentials plus other basic build tools
    - Installs selected ARM toolchain
    - Downloads and unpacks valgrind-3.9.0 sources from http://valgrind.org/downloads/valgrind-3.9.0.tar.bz2
    - Copies two build scripts into valgrind source directory to ease compilation and packing completed binaries

## Building Valgrind

* Clone this repository
* Start vagrant: `vagrant up`. This will download the 'hashicorp/precise32' box if it's not already available, create the VM instance, and provision it according to the selected toolchain.
* SSH into the new box: `vagrant ssh`
* Navigate to the valgrind source directory: `cd ~/valgrind-3.9.0`
* Run the build script: `sh ./beaglebone-build.sh`
* Valgrind binaries will be installed to `/opt/valgrind`.  **Note:** the prefix path is embedded into the valgrind binaries so you'll need to install the binaries to the same location on the BBB or add a simlink.
* To package the binaries and move them outside of the vagrant environment, run the postbuild script: `sh ./beaglebone-postbuild.sh`.  This will create `valgrind-beaglebone.tar.gz` in the host root directory (the same folder as this Readme).

## Deploying Valgrind to a BBB

* Copy binaries to BBB: `scp valgrind-beaglebone.tar.gz root@<beaglebone ip address>:~`
* SSH into BBB: `ssh root@<beaglebone ip address>`
* Unpack binaries to uSD card: `tar -xzvf valgrind-beaglebone.tar.gz`
* Move the binaries into place: `mv opt/valgrind /opt/valgrind`
* Link into system path: `ln -s /opt/valgrind/bin/valgrind /usr/bin/valgrind`
* Clean up: `rm -rf opt valgrind-beaglebone.tar.gz`