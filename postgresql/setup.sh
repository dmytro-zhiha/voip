#!/bin/bash
set -e

echo "[+] Installing PostgreSQL..."
apt-get update
apt-get install -y postgresql postgresql-contrib

echo "[+] Creating DB and user..."
sudo -u postgres psql -c "CREATE USER asterisk WITH PASSWORD 'asteriskpass';"
sudo -u postgres psql -c "CREATE DATABASE asterisk OWNER asterisk;"

echo "[+] Configuring PostgreSQL to allow remote connections..."
PG_CONF_DIR=$(find /etc/postgresql/ -type d -name main | head -n 1)

sed -i "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/g" "$PG_CONF_DIR/postgresql.conf"
echo "host    all             all             192.168.56.101/32         md5" >> "$PG_CONF_DIR/pg_hba.conf"

systemctl restart postgresql

echo "[✓] PostgreSQL ready."

