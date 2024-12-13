#!/usr/bin/env ruby

# This is aspirational, in hopes that external alerts might be someday possible
# Also hope to use it for growth forecasting

log_file = "/var/tmp/usage.log"
date = Time.now.strftime("%Y%m%d%H")

begin
  File.open(log_file, "a") do |log|
    # Get disk usage for root partition
    df_output = `df -h | grep ' /$'`
    log.puts "[#{date}] #{df_output}"
  end
rescue => e
  abort "Can't open file #{log_file}: #{e.message}"
end
