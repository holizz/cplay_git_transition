#!/bin/sh

# get the files
./grab.sh

#NOTE: you will have to grab the rest manually at this point ...

# get the directory listings
wget http://web.archive.org/web/20050310155712/www.tf.hut.fi/~flu/cplay/pre/ -O pre.index
wget http://web.archive.org/web/20050310155712/www.tf.hut.fi/~flu/cplay/old/ -O old.index

# add a date for each file from dir listing
./dates.rb

# do all the git stuff
./git.rb
