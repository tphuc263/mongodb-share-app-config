@echo off
echo Creating MongoDB Sharding Directory Structure...

mkdir mongodb-cluster
cd mongodb-cluster

mkdir config-servers\cfg1
mkdir config-servers\cfg2
mkdir config-servers\cfg3

mkdir shard1\s1
mkdir shard1\s2
mkdir shard1\s3

mkdir shard2\s1
mkdir shard2\s2
mkdir shard2\s3

mkdir logs
mkdir scripts

echo Directory structure created successfully!
echo Location: %cd%
pause