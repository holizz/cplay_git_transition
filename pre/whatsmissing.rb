#!/usr/bin/env ruby

require 'set'

should_be = Set.new(`cut -d/ -f10 pre.ls`.split("\n"))
actually_is = Set.new(`ls`.split("\n"))

(should_be - actually_is).sort.each {|a|
  puts a
}
