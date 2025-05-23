@echo off
echo Stopping MongoDB Sharding Cluster...

echo Stopping Mongos...
mongosh --port 27017 --eval "db.adminCommand('shutdown')" --quiet 2>nul

echo Stopping Shards...
mongosh --port 27018 --eval "db.adminCommand('shutdown')" --quiet 2>nul
mongosh --port 27023 --eval "db.adminCommand('shutdown')" --quiet 2>nul
mongosh --port 27024 --eval "db.adminCommand('shutdown')" --quiet 2>nul
mongosh --port 27020 --eval "db.adminCommand('shutdown')" --quiet 2>nul
mongosh --port 27025 --eval "db.adminCommand('shutdown')" --quiet 2>nul
mongosh --port 27026 --eval "db.adminCommand('shutdown')" --quiet 2>nul

echo Stopping Config Servers...
mongosh --port 27019 --eval "db.adminCommand('shutdown')" --quiet 2>nul
mongosh --port 27021 --eval "db.adminCommand('shutdown')" --quiet 2>nul
mongosh --port 27022 --eval "db.adminCommand('shutdown')" --quiet 2>nul

echo All MongoDB instances stopped!
pause