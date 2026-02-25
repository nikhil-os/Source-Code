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

# 1. Update .env on VPS
print("=== Updating .env on VPS ===")
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

# 2. Verify .env
run_cmd(ssh, "cat /www/wwwroot/backend/.env")

# 3. Flush logs and restart PM2
print("\n=== Restarting backend ===")
run_cmd(ssh, "pm2 flush backend 2>&1")
run_cmd(ssh, "pm2 restart backend --update-env 2>&1")

time.sleep(8)

# 4. Check logs
print("\n=== Checking logs ===")
run_cmd(ssh, "cat /root/.pm2/logs/backend-out.log")
run_cmd(ssh, "tail -10 /root/.pm2/logs/backend-error.log")

# 5. Save PM2
run_cmd(ssh, "pm2 save 2>&1")

ssh.close()
print("\n=== Done ===")
