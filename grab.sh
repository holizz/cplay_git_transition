#!/bin/zsh

grab_dir() {
mkdir -p "$1"
URL="http://web.archive.org/web/20050310155712/www.tf.hut.fi/~flu/cplay/$1/"
wget ${URL} -qO - | grep 'a href' | cut -d'"' -f6 | awk '{print "'${URL}'" $0}' | grep -v '\?C=N;O=D' | wget -P "$1" -ci -
}

grab_dir old
grab_dir pre
