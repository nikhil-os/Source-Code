import paramiko
import sys
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
        print(out.strip())
    if err.strip():
        print(f"STDERR: {err.strip()}")
    return out.strip(), err.strip()

try:
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    print(f"Connecting to {HOST}...")
    ssh.connect(HOST, username=USER, password=PASSWORD, timeout=15)
    print("Connected!\n")

    # 1. Check OS
    run_cmd(ssh, "cat /etc/os-release | head -3")

    # 2. Check if Node.js is installed
    run_cmd(ssh, "which node && node -v || echo 'NODE_NOT_FOUND'")

    # 3. Check if port 5000 is already listening
    run_cmd(ssh, "ss -tlnp | grep 5000 || echo 'PORT_5000_NOT_LISTENING'")

    # 4. Check firewall status
    out, _ = run_cmd(ssh, "which ufw && ufw status || echo 'UFW_NOT_FOUND'")
    if "UFW_NOT_FOUND" in out:
        run_cmd(ssh, "which firewall-cmd && firewall-cmd --state || echo 'FIREWALLD_NOT_FOUND'")

    # 5. Open port 5000 in firewall
    print("\n=== Opening port 5000 ===")
    if "UFW_NOT_FOUND" not in out:
        run_cmd(ssh, "ufw allow 5000/tcp")
        run_cmd(ssh, "ufw reload")
        run_cmd(ssh, "ufw status")
    else:
        # Try firewalld
        run_cmd(ssh, "firewall-cmd --permanent --add-port=5000/tcp 2>/dev/null || iptables -A INPUT -p tcp --dport 5000 -j ACCEPT")
        run_cmd(ssh, "firewall-cmd --reload 2>/dev/null || echo 'used iptables'")

    # 6. Check if pm2 is installed
    run_cmd(ssh, "which pm2 || echo 'PM2_NOT_FOUND'")

    # 7. Check if there's a project folder
    run_cmd(ssh, "ls -la /root/ | head -20")
    run_cmd(ssh, "find /root /home /var/www -maxdepth 3 -name 'package.json' -path '*/backend/*' 2>/dev/null | head -5 || echo 'NO_BACKEND_FOUND'")

    # 8. Check running node processes
    run_cmd(ssh, "ps aux | grep node | grep -v grep || echo 'NO_NODE_PROCESSES'")

    print("\n=== VPS Diagnosis Complete ===")
    ssh.close()

except Exception as e:
    print(f"Connection failed: {e}")
    sys.exit(1)
