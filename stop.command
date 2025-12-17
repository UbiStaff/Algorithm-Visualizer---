#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

stop_one() {
  local name="$1"; local pid_file="$2"
  if [[ -f "$pid_file" ]]; then
    local pid
    pid=$(cat "$pid_file" || true)
    if [[ -n "${pid:-}" ]]; then
      echo "[Stop] 结束 $name (PID=$pid) ..."
      kill "$pid" 2>/dev/null || true
      rm -f "$pid_file"
      echo "[Stop] $name 已结束。"
    fi
  else
    echo "[Stop] 未发现 $name 的 PID 文件：$pid_file"
  fi
}

stop_one "前端" "$SCRIPT_DIR/frontend.pid"
stop_one "后端" "$SCRIPT_DIR/backend.pid"

# 端口级别的兜底停止（处理未通过 start.command 启动、未写 PID 的进程）
stop_by_port() {
  local port="$1"; local name="$2"
  local pids
  pids=$(lsof -ti ":$port" 2>/dev/null || true)
  if [[ -n "${pids:-}" ]]; then
    echo "[Stop] 发现 $name 进程监听端口 $port: $pids，尝试结束..."
    kill $pids 2>/dev/null || true
    echo "[Stop] $name (port:$port) 已尝试结束。"
  else
    echo "[Stop] 端口 $port 未发现 $name 进程。"
  fi
}

# Vite 前端常见端口（会顺延占用）
stop_by_port 5173 "前端(Vite)"
stop_by_port 5174 "前端(Vite)"
stop_by_port 5175 "前端(Vite)"
# Spring Boot 后端端口
stop_by_port 8080 "后端(Spring Boot)"

echo "[Stop] 完成。"