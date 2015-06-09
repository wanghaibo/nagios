#!/bin/bash
redis_cli=`whereis redis-cli|awk '{print $NF}'`
if [[ $redis_cli =~ ":" ]];then
    echo "can not find redis-cli"
    exit
fi
used_memory=`$redis_cli info |grep 'used_memory:'|awk -F 'used_memory:' '{printf("%d",$2)}'`
max_memory=`$redis_cli config get maxmemory|grep -v 'memory'`

#初始化参数
CRITICAL=100
#分析参数
while getopts "c:h" opt
do
    case $opt in
        t ) TYPE=$OPTARG;;
        w ) WARNING=$OPTARG;;
        c ) CRITICAL=$OPTARG;;
        ? ) 
        echo "-c 剩余容量critical值"
        exit 1;; 
    esac
done

STATE_OK=0   
STATE_WARNING=1   
STATE_CRITICAL=2   
STATE_UNKNOWN=3   
max_memory=$[$max_memory/1024/1024]
used_memory=$[$used_memory/1024/1024]

if [ $used_memory -lt $(($max_memory-$CRITICAL)) ];then 
    echo "TEST OK;max_memory is $max_memory M;used_memory is $used_memory M|used=$used_memory" 
    exit $STATE_OK 
elif [ $used_memory -gt $(($max_memory-$CRITICAL)) ] || [ $used_memory -eq $(($max_memory-$CRITICAL)) ];then 
    echo "TEST CRITICAL;max_memory is $max_memory M;used_memory is $used_memory M|used=$used_memory" 
    exit $STATE_CRITICAL
else  
    echo "UNKNOWN STATE" 
    exit $STATE_UNKNOWN 
fi 

