@echo off
echo Stopping MongoDB Sharding Cluster...

echo Stopping Mongos...
mongosh --port 27017 --eval "db.adminCommand('shutdown')" --quiet 2>nul
timeout /t 3 /nobreak >nul

echo Force killing mongos processes...
taskkill /f /im mongos.exe 2>nul

echo Stopping Shards...
mongosh --port 27018 --eval "db.adminCommand('shutdown')" --quiet 2>nul
mongosh --port 27023 --eval "db.adminCommand('shutdown')" --quiet 2>nul
mongosh --port 27024 --eval "db.adminCommand('shutdown')" --quiet 2>nul
mongosh --port 27020 --eval "db.adminCommand('shutdown')" --quiet 2>nul
mongosh --port 27025 --eval "db.adminCommand('shutdown')" --quiet 2>nul
mongosh --port 27026 --eval "db.adminCommand('shutdown')" --quiet 2>nul
timeout /t 3 /nobreak >nul

echo Stopping Config Servers...
mongosh --port 27019 --eval "db.adminCommand('shutdown')" --quiet 2>nul
mongosh --port 27021 --eval "db.adminCommand('shutdown')" --quiet 2>nul
mongosh --port 27022 --eval "db.adminCommand('shutdown')" --quiet 2>nul
timeout /t 3 /nobreak >nul

echo Force killing remaining mongod processes...
taskkill /f /im mongod.exe 2>nul

echo Cleaning up PID files...
del logs\*.pid 2>nul

echo Checking remaining processes...
set REMAINING=0
tasklist | findstr mongod >nul && set REMAINING=1
tasklist | findstr mongos >nul && set REMAINING=1

if %REMAINING%==1 (
    echo WARNING: Some MongoDB processes may still be running
    tasklist | findstr "mongod mongos"
) else (
    echo SUCCESS: All MongoDB instances stopped!
)

echo.
echo You can now safely start the cluster again.
pause