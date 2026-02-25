import paramiko
import sys

HOST = "66.63.168.107"
USER = "root"
PASSWORD = "Kn32iq853cv0tOSRPZ"

def run_cmd(ssh, cmd, timeout=30):
    print(f"\n>>> {cmd}")
    stdin, stdout, stderr = ssh.exec_command(cmd, timeout=timeout)
    out = stdout.read().decode('utf-8', errors='replace')
    err = stderr.read().decode('utf-8', errors='replace')
    if out.strip():
        print(out.strip())
    if err.strip():
        print(f"STDERR: {err.strip()}")
    return out.strip(), err.strip()

try:
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(HOST, username=USER, password=PASSWORD, timeout=15)
    print("Connected!\n")

    # 1. Test if port 5000 responds locally on VPS
    print("=== Testing backend locally on VPS ===")
    run_cmd(ssh, "curl -s -o /dev/null -w '%{http_code}' http://localhost:5000/health || echo 'CURL_FAILED'")
    
    # 2. Check backend code on VPS - see if it binds to 0.0.0.0
    print("\n=== Checking VPS backend code ===")
    run_cmd(ssh, "cat /www/wwwroot/backend/.env 2>/dev/null || echo 'NO_ENV'")
    run_cmd(ssh, "tail -10 /www/wwwroot/backend/index.js 2>/dev/null || echo 'NO_INDEX'")
    
    # 3. Update the backend index.js to bind to 0.0.0.0
    print("\n=== Updating backend to bind to 0.0.0.0 ===")
    run_cmd(ssh, """sed -i "s/app.listen(PORT, () => {/app.listen(PORT, '0.0.0.0', () => {/" /www/wwwroot/backend/index.js""")
    run_cmd(ssh, """sed -i 's/listening on " + PORT/listening on 0.0.0.0:" + PORT/' /www/wwwroot/backend/index.js""")
    
    # 4. Restart backend with pm2
    print("\n=== Restarting backend ===")
    run_cmd(ssh, "pm2 list")
    run_cmd(ssh, "pm2 restart all")
    
    import time
    time.sleep(3)
    
    # 5. Verify it's running again
    print("\n=== Verification ===")
    run_cmd(ssh, "ss -tlnp | grep 5000")
    run_cmd(ssh, "curl -s -o /dev/null -w '%{http_code}' http://localhost:5000/health || echo 'CURL_FAILED'")
    run_cmd(ssh, "pm2 logs --lines 10 --nostream 2>/dev/null || echo 'no pm2 logs'")

    print("\n=== Done! ===")
    ssh.close()

except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
