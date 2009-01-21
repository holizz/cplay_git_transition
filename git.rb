#!/usr/bin/env ruby

require 'time'
require 'set'
require 'changelog'

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
  `iconv -f ISO-8859-1 -t UTF-8 < pre/ChangeLog > pre/ChangeLog.utf8`
  changelog = ChangeLog.new('pre/ChangeLog.utf8')
  `mkdir -p #{dir}`
  old_dir=Dir.pwd
  Dir.chdir(dir)
  `touch cplay`
  `chmod 755 cplay`
  `git init`
  `git add cplay`
  files.each{|date,file|
    puts "#{date} #{file}"
    filename = file.split('/')[-1]
    if file.end_with? '.tar.gz'
      fdir = filename.dup
      fdir['.tar.gz']=''
      `tar xzf ../#{file}`
      `rm -rf #{fdir}/CVS`
      `rm -rf #{fdir}/po/CVS`

      newfiles = `find #{fdir}`.split("\n").map{|f|
        f.split('/')[1..-1].join('/')}.select{|f|f!=''}

      `mkdir -p po`
      `mv #{fdir}/po/* po/`
      `rmdir #{fdir}/po`
      `mv #{fdir}/* .`
      `rmdir #{fdir}`
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
    # Add the ChangeLog
    version = filename.match(/cplay-(.*?)($|\.tar\.gz$)/)[1]
    if changelog.versions.include?(version) or version=='1.47rc1'
      open('ChangeLog','w+') {|f|
        if version == '1.47rc1'
          cl = changelog.until('1.47rc2')
          cl[0] = ([cl[0].split("\n")[0]] +
                   cl[0].split("\n")[4..-1]).join("\n")+"\n"
          f.write(cl)
        else
          f.write(changelog.until(version))
        end
      }
      `git add ChangeLog`
    end
    if version != '1.46pre1+tags' # special case - should be a branch
      `GIT_AUTHOR_NAME='#{author}' GIT_AUTHOR_EMAIL='#{email}' GIT_AUTHOR_DATE='#{date}' git commit -m '#{filename}'`
    end
  }
  Dir.chdir(old_dir)
end

files = (get_files('old.dates') + get_files('pre.dates')).sort
do_git(files)
