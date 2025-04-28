#! bin/bash
# Script to configure HAProxy logging
sudo nano /etc/rsyslog.d/50-default.conf

----- 

#  Default rules for rsyslog.
*.*                                                     @@192.18.76.110:5514
#
#                       For more information see rsyslog.conf(5) and /etc/rsyslog.conf

#
# First some standard log files.  Log by facility.
#
auth,authpriv.*                 /var/log/auth.log
*.*;auth,authpriv.none          -/var/log/syslog
#cron.*                         /var/log/cron.log
#daemon.*                       -/var/log/daemon.log
local7.*                        /mnt/web/tmp/log/*
kern.*                          -/var/log/kern.log
#lpr.*                          -/var/log/lpr.log
mail.*                          -/var/log/mail.log
#user.*                         -/var/log/user.log

#
# Logging for the mail system.  Split it up so that
# it is easy to write scripts to parse these files.
#
#mail.info                      -/var/log/mail.info
#mail.warn                      -/var/log/mail.warn
mail.err                        /var/log/mail.err

#
# Some "catch-all" log files.
#
#*.=debug;\
#       auth,authpriv.none;\
#       news.none;mail.none     -/var/log/debug
#*.=info;*.=notice;*.=warn;\
#       auth,authpriv.none;\
#       cron,daemon.none;\
#       mail,news.none          -/var/log/messages

#
# Emergencies are sent to everybody logged in.
#
*.emerg                         :omusrmsg:*

#
# I like to have messages displayed on the console, but only on a virtual
# console I usually leave idle.
#
#daemon,mail.*;\
#       news.=crit;news.=err;news.=notice;\
#       *.=debug;*.=info;\
#       *.=notice;*.=warn       /dev/tty8



----




---- # Add the following lines to the file /etc/rsyslog.d/app.conf

$ModLoad imfile
$InputFilePollInterval 10
$PrivDropToGroup adm
$InputFileName /mnt/Pesaflow/pesaflow_web/tmp/log/*
$InputFileTag Web3
$InputFileStateFile Stat-APP
$InputFileSeverity app
$InputFileFacility local7
$InputRunFileMonitor
$InputFilePersistStateInterval 1000



-----
# Restart rsyslog service to apply changes

sudo systemctl restart rsyslog


Combine log folders script

```yaml

#!/bin/bash

DEST="/var/log/combined-app-logs"
sudo mkdir -p "$DEST"

declare -A SOURCES
SOURCES["platform"]="/home/ubuntu/platform/_build/prod/rel/web/tmp/log"
SOURCES["africa"]="/mnt/africa/_build/prod/rel/web/tmp/log"

for TAG in "${!SOURCES[@]}"; do
  SRC="${SOURCES[$TAG]}"
  sudo find "$SRC" -type f -print0 | while IFS= read -r -d '' file; do
    FILENAME=$(basename "$file")
    sudo cp "$file" "$DEST/${TAG}_${FILENAME}"
    echo "Copied: $file → $DEST/${TAG}_${FILENAME}"
  done
done
```
