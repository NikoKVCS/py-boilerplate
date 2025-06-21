#!/bin/bash
set -e

# 🌐 请将此设置为服务器对应的域名
DOMAIN="mydomain.xyz"

# Flask 服务的本地端口（不要监听公网）
PORT=8000

echo "🧠 检测系统类型..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_FAMILY=$ID
else
    echo "❌ 无法识别系统类型"
    exit 1
fi

# 🟢 安装 Caddy
echo "🛠 安装 Caddy..."

if [[ "$OS_FAMILY" =~ ^(ubuntu|debian)$ ]]; then
    # 对于 Ubuntu / Debian
    sudo apt update
    sudo apt install -y curl gnupg apt-transport-https lsb-release debian-keyring debian-archive-keyring

    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
      | sudo gpg --dearmor -o /usr/share/keyrings/caddy.gpg

    echo "deb [signed-by=/usr/share/keyrings/caddy.gpg] https://dl.cloudsmith.io/public/caddy/stable/deb/$(lsb_release -cs) all main" \
      | sudo tee /etc/apt/sources.list.d/caddy.list

    sudo apt update
    sudo apt install -y caddy

elif [[ "$OS_FAMILY" =~ ^(centos|rocky|rhel|alma)$ ]]; then
    # 对于 CentOS / RHEL / Rocky / AlmaLinux
    sudo dnf install -y 'dnf-command(config-manager)' || sudo yum install -y 'yum-utils'
    sudo dnf install -y dnf-plugins-core || true

    sudo dnf copr enable @caddy/caddy -y || sudo yum-config-manager --add-repo https://rpms.remirepo.net/enterprise/remi.repo

    sudo dnf install -y caddy || sudo yum install -y caddy
else
    echo "❌ 不支持的系统：$OS_FAMILY"
    exit 1
fi

echo "✅ Caddy 安装完成"

# 📝 写入 Caddyfile
echo "📝 配置 Caddyfile"
sudo tee /etc/caddy/Caddyfile > /dev/null <<EOF
$DOMAIN {
    reverse_proxy localhost:$PORT
}
EOF

# 🔄 重启或启动 caddy
echo "🔄 重启 Caddy 服务"
sudo systemctl daemon-reexec || true
sudo systemctl enable caddy
sudo systemctl restart caddy

echo "✅ 部署完成"

echo ""
echo "🌍 请确保域名 $DOMAIN 已解析到当前服务器 IP"
echo "🔗 示例地址："
echo "   ➤ https://$DOMAIN"