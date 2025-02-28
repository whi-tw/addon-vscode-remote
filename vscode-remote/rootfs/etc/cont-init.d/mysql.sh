#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Community Add-on: VSCode Remote
# Pre-configures the MySQL clients, if the service is available
# ==============================================================================
declare host
declare password
declare port
declare username

if bashio::services.available "mysql"; then
  host=$(bashio::services "mysql" "host")
  password=$(bashio::services "mysql" "password")
  port=$(bashio::services "mysql" "port")
  username=$(bashio::services "mysql" "username")

  mkdir -p /root/.config
  {
    echo "[client]"
    echo "host=${host}"
    echo "password=\"${password}\""
    echo "port=${port}"
    echo "user=\"${username}\""
  } >/etc/mysql/conf.d/service.cnf
fi
