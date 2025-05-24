// MongoDB Sharding Initialization Script

print("=== MongoDB Sharding Cluster Initialization ===");

// Step 1: Initialize Config Server Replica Set
print("\n1. Initializing Config Server Replica Set (27018-27020)...");
try {
  conn = new Mongo("localhost:27018");
  db = conn.getDB("admin");

  result = rs.initiate({
    _id: "cfgRS",
    configsvr: true,
    members: [
      { _id: 0, host: "localhost:27018" },
      { _id: 1, host: "localhost:27019" },
      { _id: 2, host: "localhost:27020" },
    ],
  });

  print("Config Server RS initialized:", result.ok ? "SUCCESS" : "FAILED");

  // Wait for replica set to be ready
  print("Waiting for config servers to be ready...");
  sleep(15000);
} catch (e) {
  print("Config Server initialization error:", e);
}

// Step 2: Initialize Shard 1 Replica Set
print("\n2. Initializing Shard 1 Replica Set(27021-27023)...");
try {
  conn = new Mongo("localhost:27021");
  db = conn.getDB("admin");

  result = rs.initiate({
    _id: "shard1RS",
    members: [
      { _id: 0, host: "localhost:27021" },
      { _id: 1, host: "localhost:27022" },
      { _id: 2, host: "localhost:27023" },
    ],
  });

  print("Shard 1 RS initialized:", result.ok ? "SUCCESS" : "FAILED");
  sleep(10000);
} catch (e) {
  print("Shard 1 initialization error:", e);
}

// Step 3: Initialize Shard 2 Replica Set
print("\n3. Initializing Shard 2 Replica Set (27024-27026)...");
try {
  conn = new Mongo("localhost:27024");
  db = conn.getDB("admin");

  result = rs.initiate({
    _id: "shard2RS",
    members: [
      { _id: 0, host: "localhost:27024" },
      { _id: 1, host: "localhost:27025" },
      { _id: 2, host: "localhost:27026" },
    ],
  });

  print("Shard 2 RS initialized:", result.ok ? "SUCCESS" : "FAILED");
  sleep(10000);
} catch (e) {
  print("Shard 2 initialization error:", e);
}

// Step 4: Connect to Mongos and Add Shards
print("\n4. Adding Shards to Cluster...");
try {
  conn = new Mongo("localhost:27017");
  db = conn.getDB("admin");

  // Add Shard 1
  result1 = sh.addShard(
    "shard1RS/localhost:27021,localhost:27022,localhost:27023"
  );
  print("Shard 1 added:", result1.ok ? "SUCCESS" : "FAILED");

  // Add Shard 2
  result2 = sh.addShard(
    "shard2RS/localhost:27024,localhost:27025,localhost:27026"
  );
  print("Shard 2 added:", result2.ok ? "SUCCESS" : "FAILED");

  sleep(5000);
} catch (e) {
  print("Adding shards error:", e);
}

// Step 5: Enable Sharding and Setup Collections
print("\n5. Setting up ShareApp Database Sharding...");
try {
  conn = new Mongo("localhost:27017");
  db = conn.getDB("admin");

  // Enable sharding for shareapp database
  result = sh.enableSharding("shareapp");
  print("Database sharding enabled:", result.ok ? "SUCCESS" : "FAILED");

  // Shard collections
  collections = [
    { name: "shareapp.users", key: { username: 1 } },
    { name: "shareapp.photos", key: { userId: 1 } },
    { name: "shareapp.likes", key: { photoId: 1, userId: 1 } },
    { name: "shareapp.comments", key: { photoId: 1 } },
    { name: "shareapp.follows", key: { followerId: 1 } },
    { name: "shareapp.tags", key: { name: "hashed" } },
    { name: "shareapp.photo_tag", key: { photoId: 1 } },
  ];

  collections.forEach(function (col) {
    try {
      result = sh.shardCollection(col.name, col.key);
      print("Sharded " + col.name + ":", result.ok ? "SUCCESS" : "FAILED");
    } catch (e) {
      print("Error sharding " + col.name + ":", e);
    }
  });
} catch (e) {
  print("Database setup error:", e);
}

// Step 6: Create Indexes
print("\n6. Creating Indexes...");
try {
  conn = new Mongo("localhost:27017");
  db = conn.getDB("shareapp");

  // Users indexes
  db.users.createIndex({ email: 1 });
  db.users.createIndex({ createdAt: -1 });

  // Photos indexes
  db.photos.createIndex({ userId: 1, createdAt: -1 });
  db.photos.createIndex({ createdAt: -1 });

  // Likes indexes
  db.likes.createIndex({ photoId: 1, createdAt: -1 });
  db.likes.createIndex({ userId: 1 });

  // Comments indexes
  db.comments.createIndex({ photoId: 1, createdAt: 1 });
  db.comments.createIndex({ userId: 1 });

  // Follows indexes
  db.follows.createIndex({ followingId: 1, createdAt: -1 });
  db.follows.createIndex({ followerId: 1, followingId: 1 });

  // PhotoTags indexes
  db.photo_tag.createIndex({ tagId: 1 });
  db.photo_tag.createIndex({ photoId: 1, tagId: 1 });

  print("Indexes created: SUCCESS");
} catch (e) {
  print("Index creation error:", e);
}

// Step 7: Display Cluster Status
print("\n7. Cluster Status:");
try {
  conn = new Mongo("localhost:27017");
  db = conn.getDB("admin");
  sh.status();
} catch (e) {
  print("Status check error:", e);
}

print("\n=== Initialization Complete! ===");
print("Connect your application to: mongodb://localhost:27017/shareapp");
