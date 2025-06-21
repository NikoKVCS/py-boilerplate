
#!/bin/bash

# 请将此设置为你绑定到服务器 IP 的域名
DOMAIN="mydomain.xxx"

# Flask 服务监听的本地端口，不要监听公网
PORT=8000

echo "🟢 安装 Caddy..."
sudo apt update
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl gnupg lsb-release

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
  | sudo gpg --dearmor -o /usr/share/keyrings/caddy.gpg

echo "deb [signed-by=/usr/share/keyrings/caddy.gpg] https://dl.cloudsmith.io/public/caddy/stable/deb/$(lsb_release -cs) all main" \
  | sudo tee /etc/apt/sources.list.d/caddy.list

sudo apt update
sudo apt install -y caddy

echo "✅ Caddy 安装完成"

echo "📝 配置 Caddyfile"
sudo tee /etc/caddy/Caddyfile > /dev/null <<EOF
$DOMAIN {
    reverse_proxy localhost:$PORT
}
EOF

echo "🔄 重启 Caddy 服务"
sudo systemctl restart caddy

echo "✅ 部署完成"

echo ""
echo "🌍 请确保域名 $DOMAIN 已正确解析到当前服务器 IP"
echo "📎 你现在可以用如下链接订阅日历："
echo "   ➤ https://$DOMAIN/your-path.ics"
echo "   ➤ webcal://$DOMAIN/your-path.ics"

