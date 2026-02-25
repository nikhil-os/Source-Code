import paramiko
import json
import os
import time

HOST = "66.63.168.107"
USER = "root"
PASSWORD = "Kn32iq853cv0tOSRPZ"

DB_DIR = os.path.join(os.path.dirname(__file__), "DB")

# Mapping: filename -> MongoDB collection name
COLLECTIONS = {
    "settings.json": "settings",
    "genres.json": "genres",
    "regions.json": "regions",
    "faqs.json": "faqs",
    "flags.json": "flags",
    "advertisements.json": "advertisements",
    "countrylivetvs.json": "countrylivetvs",
}

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
print(f"Connecting to {HOST}...")
ssh.connect(HOST, username=USER, password=PASSWORD, timeout=15)
print("Connected!\n")

sftp = ssh.open_sftp()

for filename, collection in COLLECTIONS.items():
    filepath = os.path.join(DB_DIR, filename)
    if not os.path.exists(filepath):
        print(f"SKIP: {filename} not found locally")
        continue

    # Read and transform the JSON: convert $oid, $date etc to simple values for mongoimport
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)

    # mongoimport can handle extended JSON, upload and import directly
    remote_path = f"/tmp/{filename}"
    print(f"Uploading {filename} -> {remote_path}")
    sftp.put(filepath, remote_path)

    # Import into MongoDB
    cmd = f"mongoimport --db mova --collection {collection} --file {remote_path} --jsonArray --drop 2>&1"
    print(f">>> {cmd}")
    stdin, stdout, stderr = ssh.exec_command(cmd, timeout=30)
    out = stdout.read().decode('utf-8', errors='replace')
    err = stderr.read().decode('utf-8', errors='replace')
    if out.strip():
        print(out.strip())
    if err.strip():
        print(f"STDERR: {err.strip()}")
    print()

sftp.close()

# Restart backend to pick up settings
print("=== Restarting backend ===")
stdin, stdout, stderr = ssh.exec_command("pm2 restart backend --update-env 2>&1", timeout=15)
print(stdout.read().decode('utf-8', errors='replace').strip()[:1000])

time.sleep(5)

# Verify
print("\n=== Checking backend logs ===")
stdin, stdout, stderr = ssh.exec_command("tail -20 /root/.pm2/logs/backend-out.log", timeout=10)
print(stdout.read().decode('utf-8', errors='replace').strip()[:1500])

stdin, stdout, stderr = ssh.exec_command("tail -5 /root/.pm2/logs/backend-error.log", timeout=10)
err_out = stdout.read().decode('utf-8', errors='replace').strip()
if err_out:
    print(f"\nErrors: {err_out[:500]}")

ssh.close()
print("\n=== Database seeding complete ===")
