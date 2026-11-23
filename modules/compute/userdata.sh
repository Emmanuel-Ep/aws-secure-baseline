#!/bin/bash
#use this for your user data(script from top to bottom)
#install httpd (Linux 2 version)
yum install -y amazon-efs-utils
yum install -y python3-pip 
pip3 install botocore
mkdir -p /mnt/efs
echo "${efs_id}:/ /mnt/efs efs _netdev,tls 0 0" >> /etc/fstab
mount -a -t efs
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello world from $(hostname -f)</h1>"> /var/www/html/index.html