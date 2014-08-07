#!/bin/sh

tar -czvf /home/vagrant/valgrind-beaglebone.tar.gz /opt/valgrind
cp -rf /home/vagrant/valgrind-beaglebone.tar.gz /vagrant/.
rm -rf /home/vagrant/valgrind-beaglebone.tar.gz
