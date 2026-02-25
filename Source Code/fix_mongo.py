import paramiko
import time

HOST = "66.63.168.107"
USER = "root"
PASSWORD = "Kn32iq853cv0tOSRPZ"

def run_cmd(ssh, cmd, timeout=30):
    print(f"\n>>> {cmd}")
    stdin, stdout, stderr = ssh.exec_command(cmd, timeout=timeout)
    out = stdout.read().decode('utf-8', errors='replace')
    err = stderr.read().decode('utf-8', errors='replace')
    if out.strip():
        print(out.strip()[:2000])
    if err.strip():
        print(f"STDERR: {err.strip()[:1000]}")
    return out.strip(), err.strip()

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
print(f"Connecting to {HOST}...")
ssh.connect(HOST, username=USER, password=PASSWORD, timeout=15)
print("Connected!\n")

# 1. Start MongoDB
print("=== Starting MongoDB ===")
run_cmd(ssh, "systemctl start mongod 2>&1 || mongod --fork --dbpath /var/lib/mongodb --logpath /var/log/mongodb/mongod.log 2>&1")
time.sleep(3)

# 2. Verify MongoDB is running
run_cmd(ssh, "ss -tlnp | grep 27017")
run_cmd(ssh, "mongosh --eval 'db.version()' 2>&1 | head -10")

# 3. Update .env to use local MongoDB
print("\n=== Updating .env to use local MongoDB ===")
env_content = """PORT=5000
MONGODB_CONNECTION_STRING=mongodb+srv://webtimeadmin:Admin10001@webtimemovieocean.4scvwbg.mongodb.net/webtimemovieocean?appName=webtimemovieocean
USE_IN_MEMORY_DB=false
JWT_SECRET=dev_super_secret_change_me
secretKey=dev_admin_secret
baseURL=http://66.63.168.107
"""
sftp = ssh.open_sftp()
with sftp.open('/www/wwwroot/backend/.env', 'w') as f:
    f.write(env_content)
sftp.close()
print("Updated .env file")

# 4. Verify .env
run_cmd(ssh, "cat /www/wwwroot/backend/.env")

# 5. Restart PM2
print("\n=== Restarting PM2 backend ===")
run_cmd(ssh, "pm2 flush backend 2>&1")
run_cmd(ssh, "pm2 restart backend 2>&1")
time.sleep(5)

# 6. Check logs
print("\n=== Checking logs ===")
run_cmd(ssh, "cat /root/.pm2/logs/backend-out.log")
run_cmd(ssh, "cat /root/.pm2/logs/backend-error.log | tail -10")

# 7. Save PM2 config
run_cmd(ssh, "pm2 save 2>&1")

# 8. Enable mongod on boot
run_cmd(ssh, "systemctl enable mongod 2>&1")

ssh.close()
print("\n=== Done ===")
