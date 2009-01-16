#!/usr/bin/env ruby

require 'time'

def get_files(dates)
  open(dates).read.split("\n").map{|l|
    l.match(/^(.+)\t(.+)$/)[1,2]
  }.map{|f,d|
    [Time.parse(d),f]
  }.select{|d,f|
    f =~ /^cplay-/
  }.map{|d,f|
      [d,"#{dates[0..2]}/#{f}"]
    }.select{|d,f|
      File.exist? f
    }
end

def do_git(files)
  author = 'Ulf Betlehem'
  email = 'flu@iki.fi'
  dir='cplay_git'
  `mkdir -p #{dir}`
  old_dir=Dir.pwd
  Dir.chdir(dir)
  `touch cplay`
  `chmod 755 cplay`
  `git init`
  `git add cplay`
  puts "hello"
  files.each{|date,file|
    puts "#{date} #{file}"
    `cp ../#{file} cplay`
    `GIT_AUTHOR_NAME='#{author}' GIT_AUTHOR_EMAIL='#{email}' GIT_AUTHOR_DATE='#{date}' git commit -am '#{file[4..-1]}'`
  }
  Dir.chdir(old_dir)
end

files = (get_files('old.dates') + get_files('pre.dates')).sort
do_git(files)
