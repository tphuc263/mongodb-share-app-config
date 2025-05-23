// MongoDB Sharding Distribution Test Script - Fixed Version
print("=== Testing MongoDB Sharding Distribution ===\n");

// Connect to shareapp database
const shareappDB = db.getSiblingDB("shareapp");

print("1. Inserting diverse test data...");

// Insert more diverse users
for (let i = 0; i < 200; i++) {
  shareappDB.users.insertOne({
    username: "test_" + String(i).padStart(3, "0"),
    email: "test" + i + "@example.com",
    fullName: "Test User " + i,
    createdAt: new Date(),
  });
}

print("✓ Inserted 200 additional users");

// Insert photos
for (let i = 0; i < 100; i++) {
  shareappDB.photos.insertOne({
    userId: ObjectId(),
    caption: "Test photo " + i,
    imageUrl: "https://example.com/photo" + i + ".jpg",
    createdAt: new Date(),
  });
}

print("✓ Inserted 100 photos");

// Insert tags with good distribution
const tags = [
  "nature",
  "sunset",
  "food",
  "travel",
  "portrait",
  "street",
  "landscape",
  "architecture",
  "pets",
  "family",
  "friends",
  "adventure",
  "city",
  "beach",
  "mountains",
  "coffee",
  "art",
  "music",
  "sports",
  "fashion",
];

tags.forEach((tag) => {
  shareappDB.tags.insertOne({
    name: tag,
    description: "Photos tagged with " + tag,
    createdAt: new Date(),
    usageCount: Math.floor(Math.random() * 100),
  });
});

print("✓ Inserted " + tags.length + " tags");

print("\n2. Manually splitting chunks...");

try {
  sh.splitAt("shareapp.users", { username: "test_100" });
  sh.splitAt("shareapp.users", { username: "user50" });
  print("✓ Split users collection chunks");
} catch (e) {
  print("Note: Some splits may already exist");
}

print("\n3. Enabling balancer...");
sh.startBalancer();
print("✓ Balancer started, waiting for redistribution...");

// Wait a bit for balancing
sleep(8000);

print("\n4. === DISTRIBUTION RESULTS ===\n");

print("Users Distribution:");
shareappDB.users.getShardDistribution();

print("\nTags Distribution:");
shareappDB.tags.getShardDistribution();

print("\nPhotos Distribution:");
shareappDB.photos.getShardDistribution();

print("\n5. === CLUSTER STATUS ===");
sh.status();

print("\n=== Test Complete! ===");
print("Cluster is ready for application use!");
print("Connection string: mongodb://localhost:27017/shareapp");
