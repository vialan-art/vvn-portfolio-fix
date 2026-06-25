#!/usr/bin/env bash
set -e

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# 1. 修复 Dropbear 服务：后台运行 + root 密码登录 + 开机自启
cat > /etc/systemd/system/dropbear-direct.service <<'SVC'
[Unit]
Description=Dropbear SSH server (direct)
After=network.target

[Service]
Type=forking
ExecStart=/usr/sbin/dropbear -p 44322
ExecStop=/bin/pkill dropbear
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SVC

systemctl daemon-reload
systemctl enable dropbear-direct
systemctl restart dropbear-direct

# 2. 保留 OpenSSH 作为备用
systemctl enable sshd
systemctl start sshd

# 3. 修复 UFW 防火墙
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp comment 'OpenSSH legacy'
ufw allow 22222/tcp comment 'OpenSSH alt'
ufw allow 44322/tcp comment 'Dropbear SSH'
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'
ufw allow 13883/tcp comment 'x-ui web'
ufw allow 2096/tcp comment 'x-ui web/api'
ufw allow 19857/tcp comment 'xray inbound'
ufw --force enable

# 4. 清理不再需要的包
apt-get autoremove -y

# 5. 确保 Nginx 正常
nginx -t && systemctl reload nginx

# 6. 确保 PM2 自启
pm2 save

# 7. 清理临时文件
rm -rf /tmp/vvn-fix /tmp/cleanup.sh /root/vps-setup.sh

echo "FINALIZE_COMPLETE"
