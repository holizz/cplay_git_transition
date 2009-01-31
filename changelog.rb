#!/usr/bin/env ruby

class ChangeLog
  attr_reader :log
  def initialize(filename)
    file = open(filename).read
    @log = []
    file.split("\n").each{|line|
      if line =~ /^\d{4}-\d{2}-\d{2}  /
        @log << ""
      end
      @log[-1] << line+"\n"
    }
  end
  def versions
    res = {}
    @log.each_with_index{|entry,i|
      if entry =~ /\t\*\*\* v?(\d\.\d+\S*)\s/ or
        entry =~ /\t* cplay ?\(([^\)]+)\)/
        res[$1] = i
      end
    }
    res
  end
  def until(version)
    if version == '1.47rc1'
      cl = self.until('1.47rc2')
      cl[0] = ([cl[0].split("\n")[0]] +
               cl[0].split("\n")[4..-1]).join("\n")+"\n"
      cl
    else
      @log[versions[version]..-1]
    end
  end
end

if __FILE__ == $0
  changelog = ChangeLog.new('pre/ChangeLog.utf8')
  changelog.log.each{|entry|
    puts entry
    puts "="*78
  }
  puts changelog.until('1.45')
end
