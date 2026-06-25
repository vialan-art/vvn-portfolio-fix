#!/usr/bin/env bash
set -e

# 手动启动 dropbear，允许 root 密码登录
PORT=44322

# 确保停止任何已有 dropbear 进程
pkill dropbear || true
sleep 1

# 直接启动 dropbear，去掉 -s 允许密码登录
/usr/sbin/dropbear -p $PORT -E -F -w &

# 放行防火墙
ufw allow $PORT/tcp

# 确认监听
ss -tlnp | grep ":$PORT"

echo "DROPBEAR_RUNNING_ON_PORT_$PORT"
