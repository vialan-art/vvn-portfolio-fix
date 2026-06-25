#!/usr/bin/env bash
set -e

PORT=44322

# 杀掉现有 dropbear
pkill dropbear || true
sleep 1

# 启动 dropbear：允许 root 密码登录，不带 -w
/usr/sbin/dropbear -p $PORT -E -F &

# 放行防火墙
ufw allow $PORT/tcp

# 确认监听
ss -tlnp | grep ":$PORT"

echo "DROPBEAR_RUNNING_ON_PORT_$PORT"
