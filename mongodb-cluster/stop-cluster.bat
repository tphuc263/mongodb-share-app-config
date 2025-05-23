@echo off
echo Stopping MongoDB Sharding Cluster...

echo Stopping Mongos...
mongo --port 27017 --eval "db.adminCommand('shutdown')"

echo Stopping Shards...
mongo --port 27018 --eval "db.adminCommand('shutdown')"
mongo --port 27023 --eval "db.adminCommand('shutdown')"
mongo --port 27024 --eval "db.adminCommand('shutdown')"
mongo --port 27020 --eval "db.adminCommand('shutdown')"
mongo --port 27025 --eval "db.adminCommand('shutdown')"
mongo --port 27026 --eval "db.adminCommand('shutdown')"

echo Stopping Config Servers...
mongo --port 27019 --eval "db.adminCommand('shutdown')"
mongo --port 27021 --eval "db.adminCommand('shutdown')"
mongo --port 27022 --eval "db.adminCommand('shutdown')"

echo All MongoDB instances stopped!
pause

# Linux/Mac (stop-cluster.sh)
#!/bin/bash
echo "Stopping MongoDB Sharding Cluster..."

echo "Stopping Mongos..."
mongo --port 27017 --eval "db.adminCommand('shutdown')"

echo "Stopping Shards..."
mongo --port 27018 --eval "db.adminCommand('shutdown')"
mongo --port 27023 --eval "db.adminCommand('shutdown')"
mongo --port 27024 --eval "db.adminCommand('shutdown')"
mongo --port 27020 --eval "db.adminCommand('shutdown')"
mongo --port 27025 --eval "db.adminCommand('shutdown')"
mongo --port 27026 --eval "db.adminCommand('shutdown')"

echo "Stopping Config Servers..."
mongo --port 27019 --eval "db.adminCommand('shutdown')"
mongo --port 27021 --eval "db.adminCommand('shutdown')"
mongo --port 27022 --eval "db.adminCommand('shutdown')"

echo "All MongoDB instances stopped!"