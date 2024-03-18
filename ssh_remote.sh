#!/bin/bash

#================================================================
#   Copyright ? 2022 PowerLeader. All rights reserved.
#   
#   @FileName: git_clone_repos.sh
#   @Author: runing.yan
#   @Created Time:2024-03-12
#   @Description:
#
#================================================================



#!/bin/bash

# 远程服务器信息
remote_user="root"
remote_host="192.168.44.211"
remote_file="/mnt/share/nas/share/source/bhs_onetree_project/egs_downloads.tar.gz"
password="admin123456"

# 本地目录
local_dir="/home/runing.yan/egs_ast2600/build"

# 进入本地目录
#cd $local_dir || { echo "Failed to change directory"; exit 1; }

# 从远程服务器获取文件并解压
#ssh -o "BatchMode yes" -o "StrictHostKeyChecking=no" $remote_user@$remote_host "cat $remote_file" | tar -xzvf - -C ./ <<< "$password"

# ssh -o "StrictHostKeyChecking=no" $remote_user@$remote_host "cat $remote_file" | tar -xzvf - -C ./ 

# 执行SSH连接并自动输入密码
#ssh -o BatchMode=yes -o "StrictHostKeyChecking=no" -o PasswordAuthentication=yes -o PreferredAuthentications=password -o PubkeyAuthentication=no "$remote_user@$remote_host" << EOF

#ssh -o BatchMode=yes -o "StrictHostKeyChecking=no" -o PasswordAuthentication=yes -o PubkeyAuthentication=no "$remote_user@$remote_host" <<< "$password"

# 提示用户输入密码
#PASSWORD="admin123456"

set -x

SETSID=/usr/bin/setsid
tmp_file=/tmp/ssh_password

print_usage()
{

  if [ $? -ne 0 ]; then
    echo "
      usage:
          sshpass <ssh|scp> <options..> [--password PASSWORD]
      
          PASSWORD: ssh login password
    "
  fi  
}

check_password_file()
{
  if [ -e $tmp_file ]; then
      echo "File exists."
      rm -f $tmp_file
      exit
  else
      echo "File does not exist."
      echo "$password" > $tmp_file
  fi
}

#echo "File does not exist."
#check_password_file
if expr "$*" : ".*password:" >/dev/null
then
    echo "$password" > $tmp_file
    cat $tmp_file
    #rm -f $tmp_file
    exit
fi

#sshpass ssh $remote_user@$remote_host --password $password

export SSH_ASKPASS=$(cd `dirname $0`;pwd)/`basename $0`
$SETSID ssh $remote_user@$remote_host

set +x