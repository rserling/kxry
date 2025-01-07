# KXRY - hourly recording and audio file management

## Description
A set of scripts creates hourly audio files from the broadcast. One (1) week of 256kb/s mp3 files are kept. Older files are re-encoded to smaller mono mp3 at a separate NAS storage path. A web interface enables browsing the files.

### Scripts
* **kxry-archive.rb**: the main script which grabs the stream using ffmpeg, writes them to **/var/tmp** and after each hour moves them from **/var/tmp** to **/home/linda/radio/**. This can be run manually and a record will be done to the end of the current hour. Also will finish the hour on system restart.
* **kxry-prune.rb**: checks for files older than 7 days, re-encodes them and outputs to NAS
* **disk.rb**: checks root disk usage and logs it. This is an interim band-aid and should not be needed long-term. Logs will provide a growth trend to manage. It might be fine as it is. 

Scripts log to **/var/log/kxry.log**

### Support Files
* **index.php**: the web interface for user access of the files
* **kxry.css**: lovely styles for web interface
* **kxry.conf**: the nginx site config

## Dependencies
* Some \*nix flavour (currently **debian 11.9** on **raspberry pi**)
* ruby
* nginx 
* ffmpeg, lame 
 
## Prerequisites
* user **linda** with dir **/home/linda/radio**
* NAS mount at **/home/linda/radio/archive**
* Web content dir **/var/www/html/archive**
* Log file **/var/log/kxry.log** writable by linda

## Implementation
Scripts are run from cron thusly:
````
#@reboot /home/linda/bin/kxry-archive.rb 2>&1
0 * * * * /home/linda/bin/kxry-archive.rb 2>&1
30 0 * * * /home/linda/bin/kxry-prune.rb 2>&1
21 12 * * * /home/linda/bin/disk.rb 2>&1
````

### :rotating_light:Doomsday Scenario (a.k.a. Slow Moving Train Wreck)
If the NFS mount to NAS is interrupted, **kxry-prune.rb** will switch output to the legacy USB volume at **/home/linda/radio/older**, this will provide a 30GB "buffer" for the long-term archiving. So the lost NAS condition will result in filled failover storage after about **113 days** (3.7 months). At that point, another **3 weeks** of unpruned primary recordings will fill the root disk. 

## To Do
Action items have been captured as [Issues](rserling/kxry/issues) in this repository.

Messaging is a challenge and probably requires a 3rd-party $ervice

## Authors

Erik Lyons, a.k.a. ErikNerd

## Version History

* 1.0
    * A half-baked PERL version
* 2.0
    * Somewhat more baked Ruby version (see To Do)

## License

This project is licensed under the [ErikNerd] License - see the LICENSE.md file for details, if the file exists. If it does not yet exist, please ignore it.

## Acknowledgments

Thanks to Dave Fulton for voluminous feedback, some constructive
