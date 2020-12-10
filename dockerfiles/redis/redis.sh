#!/bin/bash

# 邪魔なファイルを削除。
rm -f \
    /data/conf/r7000i.log \
    /data/conf/r7001i.log \
    /data/conf/r7002i.log \
    /data/conf/r7003i.log \
    /data/conf/r7004i.log \
    /data/conf/r7005i.log \
    /data/conf/nodes.7000.conf \
    /data/conf/nodes.7001.conf \
    /data/conf/nodes.7002.conf \
    /data/conf/nodes.7003.conf \
    /data/conf/nodes.7004.conf \
    /data/conf/nodes.7005.conf ;

#redisを6台クラスターモードで(クラスターモードの設定はredis.conf)起動。
# nodes.****.conf はそれぞれ別々のファイルを指定する必要がある。
redis-server /data/conf/redis.conf --port 7000 --cluster-config-file /data/conf/nodes.7000.conf --daemonize yes ;
redis-server /data/conf/redis.conf --port 7001 --cluster-config-file /data/conf/nodes.7001.conf --daemonize yes ;
redis-server /data/conf/redis.conf --port 7002 --cluster-config-file /data/conf/nodes.7002.conf --daemonize yes ;
#redis-server /data/conf/redis.conf --port 7003 --cluster-config-file /data/conf/nodes.7003.conf --daemonize yes ;
#redis-server /data/conf/redis.conf --port 7004 --cluster-config-file /data/conf/nodes.7004.conf --daemonize yes ;
#redis-server /data/conf/redis.conf --port 7005 --cluster-config-file /data/conf/nodes.7005.conf --daemonize yes ;

REDIS_LOAD_FLG=true;

#全てのredis-serverの起動が完了するまでループ。
while $REDIS_LOAD_FLG;
do
    sleep 1;
    redis-cli -p 7000 info 1> /data/conf/r7000i.log 2> /dev/null;
    if [ -s /data/conf/r7000i.log ]; then
        :
    else
        continue;
    fi
    redis-cli -p 7001 info 1> /data/conf/r7001i.log 2> /dev/null;
    if [ -s /data/conf/r7001i.log ]; then
        :
    else
        continue;
    fi
    redis-cli -p 7002 info 1> /data/conf/r7002i.log 2> /dev/null;
    if [ -s /data/conf/r7002i.log ]; then
        :
    else
        continue;
    fi
#    redis-cli -p 7003 info 1> /data/conf/r7003i.log 2> /dev/null;
#    if [ -s /data/conf/r7003i.log ]; then
#        :
#    else
#        continue;
#    fi
#    redis-cli -p 7004 info 1> /data/conf/r7004i.log 2> /dev/null;
#    if [ -s /data/conf/r7004i.log ]; then
#        :
#    else
#        continue;
#    fi
#    redis-cli -p 7005 info 1> /data/conf/r7005i.log 2> /dev/null;
#    if [ -s /data/conf/r7005i.log ]; then
#        :
#    else
#        continue;
#    fi
    #redis-serverの起動が終わったらクラスター・レプリカの割り当てる。
    #ipを127.0.0.1で割り当てるとphpで不具合が起こるのでpublic ipを指定。
#    yes "yes" | redis-cli --cluster create 172.16.239.10:7000 172.16.239.10:7001 172.16.239.10:7002 172.16.239.10:7003 172.16.239.10:7004 172.16.239.10:7005 --cluster-replicas 1;
#    yes "yes" | redis-cli --cluster create 172.16.239.10:7000 172.16.239.10:7001 172.16.239.10:7002 172.16.239.10:7003 172.16.239.10:7004 172.16.239.10:7005;
    yes "yes" | redis-cli --cluster create 172.16.239.10:7000 172.16.239.10:7001 172.16.239.10:7002;
    REDIS_LOAD_FLG=false;
done