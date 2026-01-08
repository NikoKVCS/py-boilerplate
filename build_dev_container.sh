#!/bin/bash

set -e

# 要求安装 devcontainer CLI：https://containers.dev
if ! command -v devcontainer &> /dev/null; then
  echo "❌ devcontainer CLI 未安装，请先执行：npm install -g @devcontainers/cli"
  exit 1
fi

# 项目根目录，假设当前目录就是源码目录（含 .devcontainer）
WORKSPACE_DIR="$(pwd)"

echo "📦 构建开发容器..."
devcontainer build --workspace-folder "$WORKSPACE_DIR"

echo "🚀 启动并进入开发容器（同步本地代码，等同 VSCode）"
devcontainer up --workspace-folder "$WORKSPACE_DIR"

echo "✅ 容器已启动并挂载本地代码！你可以通过以下命令进入容器："
echo ""
echo "    devcontainer exec --workspace-folder \"$WORKSPACE_DIR\" bash"
echo ""