from pymongo import MongoClient

# MongoDB Atlas connection
MONGO_URI = "mongodb+srv://webtimeadmin:Admin10001@webtimemovieocean.4scvwbg.mongodb.net/webtimemovieocean?retryWrites=true&w=majority"

# Connect to MongoDB Atlas
client = MongoClient(MONGO_URI)
db = client['webtimemovieocean']

# Show all users first
print("Current users (before cleanup):")
for user in db.users.find():
    print(f"  - ID: {user.get('_id')} | email: {user.get('email', 'no email')} | isBlock: {user.get('isBlock', 'N/A')} | identity: {user.get('identity', 'N/A')}")

# Delete all users to start fresh
result = db.users.delete_many({})
print(f"\nDeleted {result.deleted_count} users - starting fresh")

# Also ensure the app is active
result2 = db.settings.update_many({}, {"$set": {"isAppActive": True}})
print(f"Updated {result2.modified_count} settings to isAppActive: true")

print("\nCurrent user count:", db.users.count_documents({}))

client.close()
print("\nDone - clean slate for testing!")
