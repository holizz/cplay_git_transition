#!/bin/sh

# extract the files from the archives in src/ (already done)

# get the directory listings (already done)
#wget http://web.archive.org/web/20050310155712/www.tf.hut.fi/~flu/cplay/pre/ -O pre.index
#wget http://web.archive.org/web/20050310155712/www.tf.hut.fi/~flu/cplay/old/ -O old.index

# add a date for each file from dir listing
./dates.rb

#TODO: add dates for files in {old,pre}/extra from tarball

# do all the git stuff
./git.rb
