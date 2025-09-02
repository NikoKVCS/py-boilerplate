FROM python:3.11.4-slim

ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive
ENV POETRY_VERSION=2.1.3
ENV PATH="/root/.local/bin:$PATH"

# 安装 curl 和 git（用于安装 poetry 和支持部分依赖）
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl git && \
    curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /root/.local/bin/poetry /usr/local/bin/poetry && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY pyproject.toml poetry.lock* ./

RUN poetry config virtualenvs.in-project true && \
    poetry install --no-root

COPY . .


ARG ENVIRONMENT=dev
ENV ENVIRONMENT=${ENVIRONMENT}

# 若不是 production，安装 code-server
RUN if [ "$ENVIRONMENT" != "production" ]; then \
    curl -fsSL https://code-server.dev/install.sh | sh ; \
    fi

# 启动逻辑
COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]