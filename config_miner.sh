#!/bin/bash
if [ -n $LOTUS_MINER_PATH ];then
  LOTUS_STORAGE_PATH=$LOTUS_MINER_PATH
fi
cd $LOTUS_STORAGE_PATH
echo -n "请输入miner IP地址: "
read ip
sed -i "/\[API\]/aListenAddress = \"\/ip4\/$ip\/tcp\/2345\/http\""  config.toml
sed -i "/RemoteListenAddress/aRemoteListenAddress = \"$ip:2345\""  config.toml

sed -i '/\[Storage\]/aAllowUnseal = false'  config.toml
sed -i '/\[Storage\]/aAllowCommit = false'  config.toml
sed -i '/\[Storage\]/aAllowPreCommit2 = false'  config.toml
sed -i '/\[Storage\]/aAllowPreCommit1 = false'  config.toml