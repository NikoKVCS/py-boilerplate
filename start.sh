#!/bin/sh

# 信任 VS Code 挂载目录（避免 Git 报错）
git config --global --add safe.directory /workspaces/*

if [ "$ENVIRONMENT" = "production" ]; then
  poetry run python src/main.py
else
  # 设置 code-server 密码
  export PASSWORD=684217
  code-server /app --bind-addr 0.0.0.0:9875 --auth password
fi