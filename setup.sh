#!/bin/bash
set -e

# 指定 python 版本（这里用系统默认 python3）
PYTHON_BIN=python3
if ! command -v $PYTHON_BIN &> /dev/null
then
  echo "Error: $PYTHON_BIN not found. Please install Python 3."
  exit 1
fi




echo "👉 Checking Poetry installation..."
if ! command -v poetry &> /dev/null
then
  echo "Poetry not found. Installing Poetry..."
  curl -sSL https://install.python-poetry.org | python3 -
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "Poetry found."
fi



# 查看当前虚拟环境路径（可能为空）
echo "Removing current VENV..."
poetry env remove --all || true
echo "Creating virtual environment in project folder..."

poetry env use $PYTHON_BIN
poetry install


echo "✅ Setup complete!"