#!/bin/bash
used_memory=`/usr/local/bin/redis-cli info |grep 'used_memory:'|awk -F 'used_memory:' '{printf("%d",$2)}'`
max_memory=`/usr/local/bin/redis-cli config get maxmemory|grep -v 'memory'`

STATE_OK=0   
STATE_WARNING=1   
STATE_CRITICAL=2   
STATE_UNKNOWN=3   
max_memory=$[$max_memory/1024/1024]
used_memory=$[$used_memory/1024/1024]

if [ $used_memory -lt $(($max_memory-100)) ];then 
    echo "TEST OK;max_memory is $max_memory M;used_memory is $used_memory M|used=$used_memory" 
    exit $STATE_OK 
elif [ $used_memory -gt $(($max_memory-100)) ] || [ $used_memory -eq $(($max_memory-100)) ];then 
    echo "TEST CRITICAL;max_memory is $max_memory M;used_memory is $used_memory M|used=$used_memory" 
    exit $STATE_CRITICAL
else  
    echo "UNKNOWN STATE" 
    exit $STATE_UNKNOWN 
fi 

