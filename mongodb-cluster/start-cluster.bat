@echo off
echo Starting MongoDB Sharding Cluster...

echo Starting Config Servers...
start "Config Server 1" mongod --config config-server1.conf
timeout /t 2
start "Config Server 2" mongod --config config-server2.conf  
timeout /t 2
start "Config Server 3" mongod --config config-server3.conf
timeout /t 5

echo Starting Shard 1...
start "Shard 1-1" mongod --config shard1-1.conf
timeout /t 2
start "Shard 1-2" mongod --config shard1-2.conf
timeout /t 2  
start "Shard 1-3" mongod --config shard1-3.conf
timeout /t 5

echo Starting Shard 2...
start "Shard 2-1" mongod --config shard2-1.conf
timeout /t 2
start "Shard 2-2" mongod --config shard2-2.conf
timeout /t 2
start "Shard 2-3" mongod --config shard2-3.conf
timeout /t 10

echo Starting Mongos Router...
start "Mongos Router" mongos --config mongos.conf

echo All MongoDB instances started!
echo Wait 30 seconds before running init-cluster.bat
pause

# Linux/Mac (start-cluster.sh)
#!/bin/bash
echo "Starting MongoDB Sharding Cluster..."

echo "Starting Config Servers..."
mongod --config config-server1.conf --fork
sleep 2
mongod --config config-server2.conf --fork
sleep 2
mongod --config config-server3.conf --fork
sleep 5

echo "Starting Shard 1..."
mongod --config shard1-1.conf --fork
sleep 2
mongod --config shard1-2.conf --fork
sleep 2
mongod --config shard1-3.conf --fork
sleep 5

echo "Starting Shard 2..."
mongod --config shard2-1.conf --fork
sleep 2
mongod --config shard2-2.conf --fork
sleep 2
mongod --config shard2-3.conf --fork
sleep 10

echo "Starting Mongos Router..."
mongos --config mongos.conf --fork

echo "All MongoDB instances started!"
echo "Wait 30 seconds before running init-cluster.sh"