Rsyslog is a rocket-fast system for log processing.

## Installation

`sudo rsyslogd -v`

`systemctl status rsyslog`

`sudo apt update`
`sudo apt-get install software-properties-common`
`sudo apt update`

`sudo add-apt-repository ppa:adiscon/v8-stable`
`sudo apt-get update`
`sudo apt-get install rsyslog`

## Configuration

### Configuring HAProxy Logging Directives

`sudo cat /etc/haproxy/haproxy.cfg`

log         /dev/log local0

`ls /var/lib/haproxy/dev`

`sudo systemctl status haproxy.service`

### Configuring Rsyslog to Collect HAProxy Logs

`sudo nano /etc/rsyslog.d/49-haproxy.conf`


```yaml
# Create an additional socket in haproxy's chroot in order to allow logging via
# /dev/log to chroot'ed HAProxy processes
$AddUnixListenSocket /var/lib/haproxy/dev/log

# Send HAProxy messages to a dedicated logfile
:programname, startswith, "haproxy" {
  /var/log/haproxy.log
  .@192.168.100.10:5514
  stop
}
```

OR 

```yaml
# Create an additional socket in haproxy's chroot in order to allow logging via
# /dev/log to chroot'ed HAProxy processes
$AddUnixListenSocket /var/lib/haproxy/dev/log
# Send HAProxy messages to a dedicated logfile
#if $programname startswith 'agent haproxy' then /var/log/haproxy.log
if $programname startswith 'haproxy' then /var/log/haproxy.log
#$FileCreateMode 0644
#$MaxMessageSize 66k
#$template haproxy,"%rawmsg%\n"
#local0.* /var/log/haproxy.log;haproxy
local0.* /var/log/haproxy.log
#if $syslogtag contains 'haproxy' then u/192.168.1.65:12201
*.* @@192.168.100.10:5514
#&~
& stop
```

OR 

```yaml

# Create an additional socket in haproxy's chroot in order to allow logging via
# /dev/log to chroot'ed HAProxy processes
$template GRAYLOGRFC5424,"<%PRI%>%PROTOCOL-VERSION% %TIMESTAMP:::date-rfc3339% %HOSTNAME% %APP-NAME% %PROCID% %MSGID% %STRUCTURED-DATA% %msg%\n"
$AddUnixListenSocket /var/lib/haproxy/dev/log

# Send HAProxy messages to a dedicated logfile
if $programname startswith 'haproxy' then /var/log/haproxy.log
if $syslogtag contains 'haproxy' then @192.168.100.10:5514;GRAYLOGRFC5424
&~
```

## provides TCP syslog reception

`sudo nano /etc/rsyslog.conf`

Find these and uncomment TCP
``` 
# provides UDP syslog reception
#module(load="imudp")
#input(type="imudp" port="514")

# provides TCP syslog reception
#module(load="imtcp")
#input(type="imtcp" port="514")
```

`sudo systemctl restart rsyslog.service`

`sudo ss -tulnp | grep "rsyslog"`


```yaml
#
# Include all config files in /etc/rsyslog.d/
#
$IncludeConfig /etc/rsyslog.d/*.conf
*.* u/192.168.100.10:5514:RSYSLOG_SyslogProtocol23Format
#$ModLoad imfile
#$InputFileName /var/log/haproxy.log
$ModLoad imfile
$InputFileName /var/log/haproxy.log
$InputFileTag haproxy
#$InputFileStateFile stat-mysql-error
#$InputFileSeverity error
$InputFileFacility local3
$InputRunFileMonitor
local3.* @@1192.168.100.10:5514
*.* @192.168.1.65:12201
```

`sudo systemctl restart rsyslog`


## Testing your configuration

`logger 'test from client'`

`sudo tail /var/log/syslog`


### Setting up the remote log storage location

`sudo nano /etc/rsyslog.conf`

```
$template RemoteLogs,"/var/log/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs
& ~
```

## NOTE
*.* @@0.0.0.0:514 - TCP
*.* @0.0.0.0:514 - UDP
*.* syntax determines that all log entries on the server should be forwarded
If you want to forward only specific logs, you can specify the service name instead of * such as cron.* @@0.0.0.0:514 or apache2.* @@0.0.0.0:514


## Configuring remote logging to a server over TCP 

`sudo nano /etc/rsyslog.d/10-remotelog.conf`

```yaml

*.* action(type="omfwd"
      queue.type="linkedlist"
      queue.filename="example_fwd"
      action.resumeRetryCount="-1"
      queue.saveOnShutdown="on"
      target="example.com" port="30514" protocol="tcp"
     )
```

`systemctl restart rsyslog`

`logger test`

cat /var/log/remote/msg/hostname/root.log
Feb 25 03:53:17 hostname root[6064]: test


----------------

`/etc/rsyslog.d/49-haproxy.conf`

# Create an additional socket in haproxy's chroot in order to allow logging via

# /dev/log to chroot'ed HAProxy processes

$AddUnixListenSocket /var/lib/haproxy/dev/log
# Send HAProxy messages to a dedicated logfile
#if $programname startswith 'agent haproxy' then /var/log/haproxy.log
if $programname startswith 'haproxy' then /var/log/haproxy.log
#$FileCreateMode 0644
#$MaxMessageSize 66k
#$template haproxy,"%rawmsg%\n"
#local0.* /var/log/haproxy.log;haproxy
local0.* /var/log/haproxy.log
#if $syslogtag contains 'haproxy' then u/192.168.1.65:12201
*.* @@192.168.1.65:12201
#&~
& stop


`/etc/rsyslog.conf`


....

#
# Include all config files in /etc/rsyslog.d/
#
$IncludeConfig /etc/rsyslog.d/*.conf
*.* u/192.168.1.65:12201:RSYSLOG_SyslogProtocol23Format
#$ModLoad imfile
#$InputFileName /var/log/haproxy.log
$ModLoad imfile
$InputFileName /var/log/haproxy.log
$InputFileTag haproxy
#$InputFileStateFile stat-mysql-error
#$InputFileSeverity error
$InputFileFacility local3
$InputRunFileMonitor
local3.* @@192.168.1.65:12201
*.* @192.168.1.65:12201