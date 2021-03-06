#!/bin/bash
if [ -z $LOTUS_MINER_PATH ];then
  LOTUS_MINER_PATH=$LOTUS_STORAGE_PATH
fi
cd $LOTUS_MINER_PATH

source /etc/filecoin-mining.config

ip=$miner_internal_ip
if [ -z $ip ];then
echo -n "请输入miner IP地址: "
read ip
fi

sed -i "/\[API\]/aListenAddress = \"\/ip4\/$ip\/tcp\/2345\/http\""  config.toml
sed -i "/RemoteListenAddress/aRemoteListenAddress = \"$ip:2345\""  config.toml

sed -i '/\[Storage\]/aAllowUnseal = true'  config.toml
sed -i '/\[Storage\]/aAllowCommit = false'  config.toml
sed -i '/\[Storage\]/aAllowPreCommit2 = false'  config.toml
sed -i '/\[Storage\]/aAllowPreCommit1 = false'  config.toml
