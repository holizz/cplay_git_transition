#!/usr/bin/env ruby

require 'set'

should_be = Set.new(`cut -d/ -f10 old.ls`.split("\n"))
actually_is = Set.new(`ls`.split("\n"))

(should_be - actually_is).sort.each {|a|
  puts "http://web.archive.org/web/*/http://www.tf.hut.fi/~flu/cplay/old/"+a
}
