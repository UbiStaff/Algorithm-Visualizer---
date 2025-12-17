#!/bin/bash
set -euo pipefail

# 项目根目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/backend"
FRONTEND_DIR="$SCRIPT_DIR/frontend"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"

echo "[One-Click] 检查环境..."
command -v java >/dev/null 2>&1 || { echo "缺少 java，请安装 JDK 17+"; exit 1; }
command -v mvn >/dev/null 2>&1 || { echo "缺少 mvn，请安装 Maven 3.9+"; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "缺少 npm，请安装 Node.js (含 npm)"; exit 1; }

echo "[One-Click] 启动后端..."
(
  cd "$BACKEND_DIR"
  # 后端日志输出到文件与控制台
  nohup mvn -q -DskipTests spring-boot:run > "$LOG_DIR/backend.log" 2>&1 &
  echo $! > "$SCRIPT_DIR/backend.pid"
) 

echo "[One-Click] 启动前端..."
(
  cd "$FRONTEND_DIR"
  # 前端日志输出到文件与控制台
  nohup npm run dev > "$LOG_DIR/frontend.log" 2>&1 &
  echo $! > "$SCRIPT_DIR/frontend.pid"
)

BACKEND_PID=$(cat "$SCRIPT_DIR/backend.pid")
FRONTEND_PID=$(cat "$SCRIPT_DIR/frontend.pid")

## 保持服务在后台运行：移除退出时清理逻辑，便于脚本结束后服务仍可用

# 等待服务就绪后自动打开浏览器
BACKEND_URL="http://localhost:8080/api/health"
FRONTEND_URL="http://localhost:5173/"

wait_http() {
  local url="$1"; local name="$2"; local retries="${3:-60}"; local delay="${4:-0.5}"
  for ((i=1; i<=retries; i++)); do
    if curl -sf "$url" >/dev/null; then
      echo "[One-Click] $name 就绪: $url"
      return 0
    fi
    sleep "$delay"
  done
  echo "[One-Click] 等待 $name 超时: $url"
  return 1
}

wait_http "$BACKEND_URL" "后端"
wait_http "$FRONTEND_URL" "前端"

echo "[One-Click] 打开浏览器..."
open "$FRONTEND_URL"
open "$BACKEND_URL"

echo "[One-Click] 已启动："
echo "  前端:   $FRONTEND_URL"
echo "  后端:   $BACKEND_URL"
echo "日志文件: logs/backend.log / logs/frontend.log"
echo "服务在后台运行。使用 stop.command 可一键停止。"