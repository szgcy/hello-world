import os
import subprocess

# 获取当前用户名
current_username = os.getenv('USERNAME')

def set_password_policy(length, complexity):
    temp_dir = os.environ['TEMP']
    inf_file = os.path.join(temp_dir, 'Password.inf')
    content = f"[Version]\nsignature=\"$CHICAGO$\n[System Access]\nMinimumPasswordLength = {length}\nPasswordComplexity = {complexity}\nMaximumPasswordAge = 999"
    with open(inf_file, 'w') as f:
        f.write(content)
    # 应用配置
    subprocess.run(f'secedit /configure /db c:\\Password.sdb /cfg "{inf_file}" /log c:\\Password.log', shell=True)
    # 删除配置文件
    os.remove(inf_file)
    os.remove('c:\\Password.sdb')
    os.remove('c:\\Password.log')
    os.remove('c:\\Password.jfm')

# 强制更新组策略
subprocess.run('gpupdate /force', shell=True)
