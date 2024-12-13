#!/usr/bin/env ruby

dir = "/home/linda/radio"

# Handle logging
def logme(msg)
  log = "/var/log/kxry.log"
  logtime = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  msg.chomp!

  File.open(log, "a") do |f|
    output = "[#{logtime}] (kxry-prune) #{msg}\n"
    if ENV['TERM']
      puts output
    else
      f.write(output)
    end
  end
rescue => e
  warn "Can't log: #{e.message}"
end

# Change to target directory
Dir.chdir(dir) do
  # Find MP3 files and squish them
  Dir.glob("*.mp3").each do |file|
    # Check if file is older than 7 days
    days_old = (Time.now - File.mtime(file)) / (24 * 60 * 60)
    
    if days_old > 7
      # Attempt to re-encode the file
      if system("/bin/lame", "-a", "-m", "m", "-b", "24", "--quiet", file, "archive/#{file}")
        logme("Squished file #{file} to archive path")
        # Re-encoding succeeded, try to remove original file
        begin
          File.unlink(file)
          logme("Removed file #{file}")
        rescue => e
          logme("Unable to unlink file #{file}: #{e.message}")
        end
      else
        logme("Re-encoding failed on file #{file}")
      end
    else
      if ENV['TERM']
        logme("File #{file} deemed to be younger than 7 days, skipping.")
      end
    end
  end
end
