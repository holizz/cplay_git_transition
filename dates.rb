#!/usr/bin/env ruby

require 'time'

# {old,pre}.index are the index.htmls wgot from the Wayback Machine

def get_dates(input)
  input.split("\n").select{|l|
    (l =~ /a href/ and not l =~ /Parent Directory/)
  }.map{|l|
    l.match(%r&a href="([^"]+)".*</a>\s+(\S+\s+\S+)\s&)[1,2]
  }.map{|a,b|
    [a,Time.parse(b)]
  }
end

def get_tar_dates(existing,tar,prefix)
  (`tar tvzf #{tar}`.split("\n").map{|l|l.split[3..-1]}.map{|d,t,f|
    [f,Time.parse("#{d} #{t}")]
  }.select{|f,d|
    f.match(%r&^#{prefix}[^/]+$&)
  }.map{|f,d|
    [f.sub(/#{prefix}/,''),d]
  }.select{|f,d|
    not existing.any? {|ef,ed| f==ef }
  } + existing).sort
end

def format(input)
  input.map{|a,b|"#{a}\t#{b}"}.join("\n")+"\n"
end

pre = get_tar_dates(get_dates(open('pre.index').read),'src/cplay.release.tar.gz','release/pre/')
old = get_tar_dates(get_dates(open('old.index').read),'src/cplay.release.tar.gz','release/')
open('pre.dates','w').write(format(pre))
open('old.dates','w').write(format(old))
