#!/bin/bash
# vg中如果还有pe没分配，可用这个命令将剩余pe分配完

vgscan
echo -n "请输入卷组名："
read vgname

free_pe=$(vgdisplay|grep Free|awk '{print $5}')
if [[ $free_pe -gt 0 ]];then
  lvextend -l +$free_pe /dev/$vgname/root
  resize2fs -p /dev/$vgname/root
fi
