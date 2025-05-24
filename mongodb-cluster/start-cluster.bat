@echo off
echo Starting MongoDB Sharding Cluster...

echo Starting Config Servers (27018-27020)...
start "Config Server 1" mongod --config config-server1.conf
timeout /t 3 /nobreak >nul
start "Config Server 2" mongod --config config-server2.conf  
timeout /t 3 /nobreak >nul
start "Config Server 3" mongod --config config-server3.conf
timeout /t 15 /nobreak >nul

echo Initializing Config Server Replica Set...
mongosh --port 27018 --eval "try { rs.initiate({ _id: 'cfgRS', configsvr: true, members: [{ _id: 0, host: 'localhost:27018' }, { _id: 1, host: 'localhost:27019' }, { _id: 2, host: 'localhost:27020' }] }); print('Config RS initialized'); } catch(e) { print('Config RS already exists or error:', e); }" --quiet
timeout /t 10 /nobreak >nul

echo Starting Shard 1 (27021-27023)...
start "Shard 1-1" mongod --config shard1-1.conf
timeout /t 3 /nobreak >nul
start "Shard 1-2" mongod --config shard1-2.conf
timeout /t 3 /nobreak >nul
start "Shard 1-3" mongod --config shard1-3.conf
timeout /t 10 /nobreak >nul

echo Starting Shard 2 (27024-27026)...
start "Shard 2-1" mongod --config shard2-1.conf
timeout /t 3 /nobreak >nul
start "Shard 2-2" mongod --config shard2-2.conf
timeout /t 3 /nobreak >nul
start "Shard 2-3" mongod --config shard2-3.conf
timeout /t 10 /nobreak >nul

echo Starting Mongos Router (27017)...
start "Mongos Router" mongos --config mongos.conf
timeout /t 10 /nobreak >nul

echo Checking cluster status...
netstat -an | findstr "27017" >nul
if %ERRORLEVEL% EQU 0 (
    echo SUCCESS: All instances running
    echo Now run: mongosh --port 27017 init-cluster.js
) else (
    echo WARNING: Mongos may not be running
)

pause