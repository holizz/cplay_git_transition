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
  }.map{|a,b|"#{a}\t#{b}"}.join("\n")+"\n"
end

open('pre.dates','w').write(get_dates(open('pre.index').read))
open('old.dates','w').write(get_dates(open('old.index').read))
