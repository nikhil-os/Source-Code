import paramiko
import os
import time

HOST = "66.63.168.107"
USER = "root"
PASSWORD = "Kn32iq853cv0tOSRPZ"

# Paths
LOCAL_SEED_FILE = os.path.join(os.path.dirname(__file__), "admin", "admin", "backend", "seed_dummy_movies.js")
REMOTE_BACKEND_PATH = "/www/wwwroot/backend"
REMOTE_SEED_FILE = f"{REMOTE_BACKEND_PATH}/seed_dummy_movies.js"

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
print(f"Connecting to {HOST}...")
ssh.connect(HOST, username=USER, password=PASSWORD, timeout=15)
print("Connected!\n")

sftp = ssh.open_sftp()

# Upload the updated seed file
print(f"Uploading {LOCAL_SEED_FILE} -> {REMOTE_SEED_FILE}")
sftp.put(LOCAL_SEED_FILE, REMOTE_SEED_FILE)
print("Uploaded seed_dummy_movies.js successfully!\n")

# Stop the backend
print("Stopping backend...")
stdin, stdout, stderr = ssh.exec_command("pm2 stop backend 2>&1", timeout=30)
print(stdout.read().decode('utf-8', errors='replace'))

# Start the backend to trigger seeding
print("Starting backend to trigger seeding...")
stdin, stdout, stderr = ssh.exec_command("pm2 start backend 2>&1", timeout=60)
print(stdout.read().decode('utf-8', errors='replace'))

# Wait for seeding to complete
print("\nWaiting 20 seconds for seeding to complete...")
time.sleep(20)

# Check the logs
print("Checking pm2 logs for seeding status...")
stdin, stdout, stderr = ssh.exec_command("pm2 logs backend --lines 80 --nostream 2>&1", timeout=30)
logs = stdout.read().decode('utf-8', errors='replace')
print(logs)

sftp.close()
ssh.close()

print("\n✅ Done! Movies should now be seeded in MongoDB Atlas.")
