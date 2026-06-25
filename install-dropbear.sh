#!/usr/bin/env bash
set -e

# 安装 Dropbear SSH 服务端作为 OpenSSH 的替代
# 监听 44322 端口，保留现有 OpenSSH

PORT=44322

apt-get update
apt-get install -y dropbear

# 配置 dropbear：监听 44322，允许 root 密码登录
mkdir -p /etc/dropbear
cat > /etc/default/dropbear <<EOF
NO_START=0
DROPBEAR_PORT=$PORT
DROPBEAR_EXTRA_ARGS=""
DROPBEAR_BANNER=""
DROPBEAR_RECEIVE_WINDOW=65536
EOF

# 放行防火墙
ufw allow $PORT/tcp

# 启动并开机自启
systemctl enable dropbear
systemctl restart dropbear

# 确认监听
ss -tlnp | grep ":$PORT"

echo "DROPBEAR_INSTALLED_ON_PORT_$PORT"
