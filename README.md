# file_integrity_check

Bash script that monitors for your files for changes. It creates
s a database of files available on the directory stipulated and
it's hashes. This database file is used to against to verify the
integrity of file whenever there is change made to a file. If th
-e hash changes, then the incident is reported. You could also r
-eprogram this to take corrective action to make sure the system
secure. For instance, suppose a hacker modified the configuratio
-n file of apache from remote location, it could identify and re
-store the original file from a specific path where copy of conf
-iguration file is added.

Dependencies: bash, inotify-tools, CONFIG_INOTIFY

This script is tested on `bash version 4.3.48(1)' on Ubuntu.
