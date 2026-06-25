#!/usr/bin/env bash
set -e

# 手动启动 dropbear 绕过 init 脚本问题
PORT=44322

# 确保停止任何已有 dropbear 进程
pkill dropbear || true
sleep 1

# 直接启动 dropbear
/usr/sbin/dropbear -p $PORT -E -F -w -s &

# 放行防火墙
ufw allow $PORT/tcp

# 确认监听
ss -tlnp | grep ":$PORT"

echo "DROPBEAR_RUNNING_ON_PORT_$PORT"
