# AIX NTP Offset Monitoring 

## Prerequisites
- Dynatrace OneAgent v1.269+ for AIX
- `curl` to ingest log messages
- `curl` or use the included `dynatrace_ingest` tool for metric ingestion

## Purpose 
Included with Dynatrace OneAgent version 1.269+ is the ability to send ingest metric datapoints and logs via the OneAgent API interface (or the `dynatrace_ingest` tool for metrics). The default path for the `dynatrace_ingest` tool is `/opt/dynatrace/oneagent/agent/tools/dynatrace_ingest`

The [aix-ntp-offset.sh](./aix-ntp-offset.sh) is an example script that parses the /etc/ntp.conf file to find the configured NTP servers and tests the offset between that server and the host the script is running on. It has examples of both how to use the `dynatrace_ingest` cli tool as well as sending metrics and logs via the local OneAgent APIs. 

## Extensions 2.0 
**This custom extension will need to be built,signed, and uploaded by the user**
Please follow the instructions here to do that : [Use Dynatrace CLI](https://www.dynatrace.com/support/help/shortlink/sign-extension#dt-cli)


Included in this repository is a custom Extensions 2.0 extension that defines both the metadata for the ingested metric as well as injects a chart card on to the host screen as seen below : 

![AIX Host Screen](./images/AIX%20Host%20Screen.png)

## Schedule 
**Scheduling this script to run periodically is the responsiblity of the user as this script is designed to run once per execution.**

Below is an example of how to schedule this script to run every 1 minute via cron. 

  ```bash 
    $ crontab -e 

    # Dynatrace NTP Offset Monitoring 
    * * * * * /path/to/script/aix-ntp-offset.sh
  ```

## Tested Versions 
Tested ingestion methods: 
- metrics : `dynatrace_ingest` & `curl` 
- logs    : `curl`

Tested on AIX Versions with OneAgent version v1.269 
- AIX, ver. 7.3 TL 0, SP 1
- AIX, ver. 7.2 TL 4, SP 1 
- AIX, ver. 7.2 TL 3, SP 6
- AIX, ver. 7.1 TL 5, SP 3
- AIX, ver. 6.1 TL 9, SP 12