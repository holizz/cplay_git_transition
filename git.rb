#!/usr/bin/env ruby

require 'time'
require 'set'

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
    filename = file.split('/')[-1]
    if file.end_with? '.tar.gz'
      dir = filename.dup
      dir['.tar.gz']=''
      `tar xzf ../#{file}`
      `rm -rf #{dir}/CVS`
      `rm -rf #{dir}/po/CVS`

      newfiles = `find #{dir}`.split("\n").map{|f|
        f.split('/')[1..-1].join('/')}.select{|f|f!=''}

      `mv #{dir}/* .`
      `mv #{dir}/po/* po/`
      `rmdir #{dir}/po`
      `rmdir #{dir}`
      curfiles = `find .`.split("\n").map{|f|
        f.split('/')[1..-1].join('/')}.select{|f|
          not f.start_with? '.'}.select{|f|f!=''}

      # Remove files not present in the latest tarball
      (Set.new(curfiles) - Set.new(newfiles)).each{|f| `git rm #{f}`}

      newfiles.each{|f| `git add #{f}`}
    else
      `cp ../#{file} cplay`
      `git add cplay`
    end
    `GIT_AUTHOR_NAME='#{author}' GIT_AUTHOR_EMAIL='#{email}' GIT_AUTHOR_DATE='#{date}' git commit -m '#{filename}'`
  }
  Dir.chdir(old_dir)
end

files = (get_files('old.dates') + get_files('pre.dates')).sort
do_git(files)
