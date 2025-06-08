FROM python:3.10

# 安装 Poetry
RUN pip install poetry

# 设置工作目录
WORKDIR /app

# 拷贝并安装依赖
COPY pyproject.toml poetry.lock ./
RUN poetry config virtualenvs.create false \
 && poetry install --no-interaction --no-ansi

# 拷贝代码
COPY . .

CMD ["poetry", "run", "python", "main.py"]
