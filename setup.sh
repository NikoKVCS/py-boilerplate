#!/bin/bash
set -e

PYTHON_VERSION="3.11.4"

SHELL_NAME=$(basename "$SHELL")
if [ "$SHELL_NAME" = "zsh" ]; then
  PROFILE="$HOME/.zshrc"
elif [ "$SHELL_NAME" = "bash" ]; then
  PROFILE="$HOME/.bashrc"
else
  PROFILE="$HOME/.profile"
fi

echo "Detected shell: $SHELL_NAME"
echo "Using profile file: $PROFILE"

if [ -f /etc/os-release ]; then
  . /etc/os-release
  if [[ "$ID" == "ubuntu" || "$ID_LIKE" == *"debian"* ]]; then
    echo "Detected Ubuntu/Debian system. Installing dependencies..."
    sudo apt update
    sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
      libreadline-dev libsqlite3-dev libffi-dev liblzma-dev wget curl git
  else
    echo "Not Ubuntu/Debian. Skipping apt package installation."
  fi
else
  echo "Cannot detect OS type. Skipping apt package installation."
fi

function append_if_not_exists() {
  local line="$1"
  local file="$2"
  grep -qxF "$line" "$file" || echo "$line" >> "$file"
}

function setup_pyenv_env() {
  append_if_not_exists 'export PATH="$HOME/.pyenv/bin:$PATH"' "$PROFILE"
  append_if_not_exists 'eval "$(pyenv init --path)"' "$PROFILE"
  append_if_not_exists 'eval "$(pyenv init -)"' "$PROFILE"
  append_if_not_exists 'eval "$(pyenv virtualenv-init -)"' "$PROFILE"
  source "$PROFILE"
  echo "Added pyenv init code to $PROFILE"
}

function setup_poetry_env() {
  local poetry_path='export PATH="$HOME/.local/bin:$PATH"'
  append_if_not_exists "$poetry_path" "$PROFILE"
  source "$PROFILE"
  echo "Added Poetry bin path to $PROFILE"
}





echo "👉 Checking pyenv installation..."
if ! command -v pyenv &> /dev/null; then
  echo "pyenv not found, installing pyenv..."
  curl https://pyenv.run | bash
  setup_pyenv_env
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
else
  echo "pyenv found."
fi





if ! pyenv versions --bare | grep -q "^${PYTHON_VERSION}$"; then
  echo "Installing Python $PYTHON_VERSION via pyenv..."
  pyenv install "$PYTHON_VERSION"
else
  echo "Python $PYTHON_VERSION already installed."
fi
pyenv local "$PYTHON_VERSION"





if ! command -v poetry &> /dev/null; then
  echo "Poetry not found, installing Poetry..."
  curl -sSL https://install.python-poetry.org | python3 -
  setup_poetry_env
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "Poetry found."
fi




# 查看当前虚拟环境路径（可能为空）
echo "Removing current VENV..."
poetry env remove --all || true
echo "Creating virtual environment in project folder..."

poetry env use $PYTHON_VERSION
poetry install


echo "✅ Setup complete!"