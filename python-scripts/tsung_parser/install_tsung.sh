#!/bin/bash
# Install tsung 1.6

yum -y install erlang perl perl-RRD-Simple.noarch perl-Log-Log4perl-RRDs.noarch gnuplot perl-Template-Toolkit python27-matplotlib 
wget http://tsung.erlang-projects.org/dist/tsung-1.6.0.tar.gz
tar xvzf  tsung-1.6.0.tar.gz
cd tsung-1.6.0 && ./configure && make && make install
