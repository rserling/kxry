# KXRY - hourly recording and audio file management

## Description
A set of scripts creates hourly audio files from the broadcast. One (1) week of 256kb/s mp3 files are kept. Older files are re-encoded to smaller mono mp3 at a separate NAS storage path. A web interface enables browsing the files.

### Scripts
* **kxry-archive.rb**: the main script which grabs the stream using ffmpeg, writes them to /var/tmp and after each hour moves them from /var/tmp to /home/linda/radio/ 
* **kxry-prune.rb**: checks for files older than 7 days, re-encodes them and outputs to NAS 
* **disk.rb**: checks root disk usage and logs it. This is an interim band-aid and should not be needed long-term. Logs will provide a growth trend to manage. It might be fine as it is.
### Support Files
* **index.php**: the web interface for user access to the files
* **kxry.css**: lovely styles for web interface
* **kxry.conf**: the nginx site config 

## Dependencies
* Some \*nix flavour (currently **debian 11.9** on **raspberry pi**)
* ruby
* nginx 
* ffmpeg, lame 
 
## Prerequisites
* user **linda** with dir /home/linda/radio
* NAS mount at /home/linda/radio/archive
* Web content dir /var/www/html/archive

## Implementation
Scripts are run from cron thusly:
````
#@reboot /home/linda/bin/kxry-archive.rb 2>&1
0 * * * * /home/linda/bin/kxry-archive.rb 2>&1
30 0 * * * /home/linda/bin/kxry-prune.rb 2>&1
21 12 * * * /home/linda/bin/disk.rb 2>&1
````
## To Do
### Easy/Doable
* Logging should all go to one file, right now it is 2 or 3
* Ideally should not run from cron but be a continuous daemon-like process managed under systemd
* The main record script **kxry-archive.rb** should calculate on invocation how many seconds are left in the hour and apply that to ffmpeg for duration
### Hard/Moneys
* It should be possible to send alerts as SMS or e-mail or whatever
* The disk checker **disk.rb** should send alerts before root is full

## Authors

Erik Lyons, a.k.a. ErikNerd

## Version History

* 1.0
    * A half-baked PERL version
* 2.0
    * Somewhat more baked Ruby version (see To Do)

## License

This project is licensed under the [ErikNerd] License - see the LICENSE.md file for details

## Acknowledgments

Thanks to Dave Fulton for voluminous feedback, some constructive
