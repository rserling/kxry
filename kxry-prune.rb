#!/usr/bin/env ruby

dir = "/home/linda/radio"

# Handle logging
log_file = "#{dir}/kxry-prune.log"
date = Time.now.strftime("%Y-%m-%d %H:%M:%S")
if ENV['TERM'].nil?
  $stdout.reopen(log_file, 'a')
  $stdout.sync = true
else
  # Keep output to terminal
  begin
    File.open(log_file, 'a') or warn("Can't open logfile #{log_file}")
  rescue => e
    warn("Can't open logfile #{log_file}: #{e.message}")
  end
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
        puts "[#{date}] Squished file #{file} to archive path"
        # Re-encoding succeeded, try to remove original file
        begin
          File.unlink(file)
          puts "[#{date}] Removed file #{file}"
        rescue => e
          puts "[#{date}] Unable to unlink file #{file}: #{e.message}"
        end
      else
        puts "[#{date}] Re-encoding failed on file #{file}"
      end
    else
      puts "[#{date}] File #{file} deemed to be younger than 7 days, skipping."
    end
  end
end
