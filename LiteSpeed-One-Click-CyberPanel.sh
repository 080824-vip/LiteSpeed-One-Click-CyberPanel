#!/bin/bash

# Chuyển sang người dùng root
if [ "$EUID" -ne 0 ]; then
  echo "Switching to root user..."
  sudo su - <<EOF
  $(cat $0)
  exit
EOF
  exit
fi

# Cập nhật hệ thống
apt update -y && apt upgrade -y

# Cài đặt các gói cần thiết
apt install -y wget

# Tải và cài đặt CyberPanel với LiteSpeed
wget -O installer.sh https://cyberpanel.net/install.sh
chmod +x installer.sh
./installer.sh --lite

# Lấy địa chỉ IP của máy chủ
IP_ADDRESS=$(curl -s http://checkip.amazonaws.com)

# Hiển thị thông tin đăng nhập
echo "Welcome to LiteSpeed One-Click CyberPanel Server."
echo "To keep this server secure, the firewalld is enabled."
echo "CyberPanel One-Click Quickstart guide:"
echo "* https://docs.litespeedtech.com/cloud/images/cyberpanel/"
echo ""
echo "In a web browser, you can view:"
echo "* CyberPanel: https://$IP_ADDRESS:8090"
echo "* phpMyAdmin: https://$IP_ADDRESS:8090/dataBases/phpMyAdmin"
echo "* Rainloop:   https://$IP_ADDRESS:8090/rainloop"
echo ""
echo "On the server:"
echo "* You can get the CyberPanel admin password with the following command:"
echo "  cat .litespeed_password"
echo "* You can get the Mysql cyberpanel user password with the following command:"
echo "  cat .db_password"
echo ""
echo "System Status:"
echo "  Load : $(uptime | awk -F'load average:' '{ print $2 }')"
echo "  CPU  : $(top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\([0-9.]*\)%* id.*//' | awk '{print 100 - $1"%"}')"
echo "  RAM  : $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')"
echo "  Disk : $(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)", $3,$2,$5}')"
echo ""
echo "Your CyberPanel is up to date"
