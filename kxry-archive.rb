#!/usr/bin/env ruby
require 'fileutils'

if Time.now.strftime("%M").to_i > 0
  duration = 3600 - (Time.now.min * 60 + Time.now.sec)
end

def logme(msg)
  log = "/var/log/kxry.log"
  logtime = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  msg.chomp!
  
  File.open(log, "a") do |f|
    output = "[#{logtime}] (kxry-archive) #{msg}\n"
    if ENV['TERM']
      puts output
    else
      f.write(output)
    end
  end
rescue => e
  warn "Can't log: #{e.message}"
end

PRG = "kxry"
LENGTH = "3600"
if duration
  LENGTH = duration
end
CMD = "/usr/bin/ffmpeg"

unless File.exist?(CMD)
  logme("Error, command #{CMD} not found.")
  exit(1)
end

date = `date +%Y%m%d%H`.chomp
url = "http://listen.xray.fm/stream"
npath = "/home/linda/radio"
opath = "/var/tmp"
fname = "#{PRG}#{date}.mp3"
if duration
  fname = "#{PRG}#{date}.part.mp3"
end
args = " -i #{url} -f mp3 -t #{LENGTH} #{fname}"
cmd = CMD + args

Dir.chdir(opath)
logme("doing command: #{cmd}...")

unless system(cmd)
  logme("Error: #{PRG} stream grab failed", "Stream command failed for \"#{PRG}\"")
  exit(1)
end

unless File.size?("#{opath}/#{fname}")
  logme("Error: #{PRG} stream grab didn't go well", "Something went wrong, output file is missing or has no size.")
  exit(1)
end

logme("completed recording #{PRG} for #{date}")
FileUtils.mv("#{opath}/#{fname}", npath)
logme("File #{fname} moved to #{npath}")
exit
