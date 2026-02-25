import paramiko
import time

VPS = '66.63.168.107'
USER = 'root'
PASS = 'Kn32iq853cv0tOSRPZ'

c = paramiko.SSHClient()
c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
c.connect(VPS, username=USER, password=PASS)

def run(cmd, timeout=30):
    print(f'\n>>> {cmd}')
    _, o, e = c.exec_command(cmd, timeout=timeout)
    try:
        out = o.read().decode()
        if out: print(out.strip())
    except Exception as ex:
        print(f'(timeout/error: {ex})')
    try:
        err = e.read().decode()
        if err: print(f'STDERR: {err.strip()}')
    except:
        pass

# 1. Restart PM2
print('=== Restarting backend ===')
run('pm2 flush backend 2>&1')
run('pm2 restart backend --update-env 2>&1')

print('\nWaiting 6 seconds...')
time.sleep(6)

# 2. Check logs
print('=== Checking logs ===')
run('cat /root/.pm2/logs/backend-out.log')
run('cat /root/.pm2/logs/backend-error.log 2>&1 | tail -5')

# 3. Test API endpoints
print('\n=== Testing APIs ===')
run('curl -s -H "key: dev_admin_secret" http://localhost:5000/setting | head -c 200')
run('curl -s -H "key: dev_admin_secret" http://localhost:5000/genre | head -c 200')
run('curl -s -H "key: dev_admin_secret" http://localhost:5000/region | head -c 200')

# 4. Test quickLogin-style user creation (loginType=2)
print('\n=== Testing quickLogin user creation ===')
run("""curl -s -X POST http://localhost:5000/user/login -H "Content-Type: application/json" -H "key: dev_admin_secret" -d '{"email":"quick@test.com","loginType":"2","identity":"quick_test_12345","fcmToken":"test_token_123","fullName":"Quick User","image":""}' 2>&1""")

# 5. Test external access
print('\n=== Testing external access ===')
run('curl -s -H "key: dev_admin_secret" http://66.63.168.107/health')
run('curl -s -H "key: dev_admin_secret" http://66.63.168.107/setting | head -c 200')

c.close()
print('\n=== ALL DONE ===')
