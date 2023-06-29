#!/bin/bash

echo "LOG : NTP offset script run start"

allservers=$(cat /etc/ntp.conf | grep -v "#" | grep server | cut -d " " -f 2)

IFS=$'\n' serverarray=($allservers)

i=0
len=${#serverarray[@]}
while [ $i -lt $len ];
do
    echo echo "LOG : Testing with NTP Server : ${serverarray[$i]}"
    offset=$(ntpdate -d ${serverarray[$i]} | grep "adjust time server" | cut -d " " -f 10)
    echo "LOG : Offset is : ${offset}"

    # Removing '+'' from offset value if it's positive 
    value=$(echo ${offset} | cut -d "+" -f 2)

    # Creating Metric Ingest Line
    mint_line="aix.ntp.offset,ntp_server=\"${serverarray[$i]}\" ${value}"
    
    # check to make sure return offset value is a number
    re='^[-]?[0-9]+([.][0-9]+)?$'

    if [[ $value =~ $re ]]; then
      echo "LOG : ${mint_line}"
      # send mint line in via OneAgent dynatrace_ingest tool 
      /opt/dynatrace/oneagent/agent/tools/dynatrace_ingest -v "${mint_line}"

      # optionally use local ingest API instead of dynatrace_ingest tool
      # curl --data "${mint_line}" http://localhost:14499/metrics/ingest -H "Content-Type: text/plain; charset=utf-8"

    else
      echo "LOG : ERROR could not collect NTP offset : ${mint_line} : ${$value}"
    fi 

    let i++
done

# optionally use logs ingest to send in success message
# curl -i -X POST "http://localhost:14499/v2/logs/ingest"  -H "Content-Type: application/json; charset=utf-8" -d "{\"content\": \"Ran NTP Offset Script Successfully\", \"severity\" : \"INFO\"}"

echo "LOG : NTP offset script run complete"