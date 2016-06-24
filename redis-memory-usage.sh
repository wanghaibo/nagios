#!/bin/bash
redis_cli=`whereis redis-cli|awk '{print $NF}'`
if [[ $redis_cli =~ ":" ]];then
    echo "can not find redis-cli"
    exit
fi

#初始化参数
CRITICAL=100
PORT=6379
#分析参数
while getopts "c:P:a:h" opt
do
    case $opt in
        c ) CRITICAL=$OPTARG;;
        P ) PORT=$OPTARG;;
        a ) PASSWORD="-a "$OPTARG;;
        ? ) 
        echo "-c 剩余容量critical值 -a redis密码 -P 端口"
        exit 1;; 
    esac
done
used_memory=`$redis_cli $PASSWORD -p $PORT info |grep 'used_memory:'|awk -F 'used_memory:' '{printf("%d",$2)}'`
max_memory=`$redis_cli $PASSWORD -p $PORT config get maxmemory|grep -v 'memory'`

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

