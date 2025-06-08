# Dockerfile
FROM ubuntu:22.04

# 环境变量，避免 tzdata 等交互
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHON_VERSION=3.11.4

# 安装依赖工具
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libffi-dev \
    liblzma-dev \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 安装 pyenv
RUN curl https://pyenv.run | bash

# 设置 pyenv 环境变量
ENV PATH="/root/.pyenv/shims:/root/.pyenv/bin:$PATH"
ENV PYENV_ROOT="/root/.pyenv"

# 初始化 pyenv
RUN /bin/bash -c "eval \"\$(pyenv init --path)\" && eval \"\$(pyenv init -)\" && eval \"\$(pyenv virtualenv-init -)\""

# 安装指定版本 Python
RUN /bin/bash -c "pyenv install -s $PYTHON_VERSION && pyenv global $PYTHON_VERSION"

# 安装 Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# 把 Poetry 加入 PATH
ENV PATH="/root/.local/bin:$PATH"

# 创建工作目录
WORKDIR /app

# 复制项目文件（建议复制 pyproject.toml 和 poetry.lock 先安装依赖）
COPY pyproject.toml poetry.lock* /app/

# 安装项目依赖
RUN poetry config virtualenvs.create false \
 && poetry install --no-interaction --no-ansi

# 复制全部代码
COPY . /app

# 容器默认执行（替换成你项目实际启动命令）
CMD ["poetry", "run", "python", "main.py"]
