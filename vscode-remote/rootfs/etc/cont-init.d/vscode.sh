#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Community Add-on: VSCode Remote
# Configures VSCode Machine settings
# ==============================================================================
set -euo pipefail
readonly VSCODE_MACHINE_CONFIG_PATH=/data/vscode/Machine
readonly VSCODE_BASE_CONFIG_PATH=/root/.vscode-server/data/

if ! bashio::fs.directory_exists "${VSCODE_MACHINE_CONFIG_PATH}"; then
    mkdir -p "${VSCODE_MACHINE_CONFIG_PATH}" ||
        bashio::exit.nok 'Failed to create a persistent vscode folder'

    chmod 700 "${VSCODE_MACHINE_CONFIG_PATH}" ||
        bashio::exit.nok \
            'Failed setting permissions on persistent vscode folder'
fi
mkdir -p "${VSCODE_BASE_CONFIG_PATH}" && ln -s "${VSCODE_MACHINE_CONFIG_PATH}" /root/.vscode-server/data/Machine

if bashio::addons.installed "5c53de3b_esphome" > /dev/null; then
    esphome_addon_slug="5c53de3b_esphome"
elif bashio::addons.installed "5c53de3b_esphome-dev" > /dev/null; then
    esphome_addon_slug="5c53de3b_esphome-dev"
elif bashio::addons.installed "5c53de3b_esphome-beta" > /dev/null; then
    esphome_addon_slug="5c53de3b_esphome-beta"
elif bashio::addons.installed "a0d7b954_esphome" > /dev/null; then
    esphome_addon_slug="a0d7b954_esphome"
fi

if [ -n "${esphome_addon_slug}" ]; then
    esphome_hostname="$(bashio::addon.hostname ${esphome_addon_slug})"
    esphome_port="$(bashio::addon.port 6052 ${esphome_addon_slug})"
    if [ -n "${esphome_port}" ]; then
        esphome_host="${esphome_hostname}:${esphome_port}"
    fi
fi

if ! bashio::fs.file_exists "${VSCODE_MACHINE_CONFIG_PATH}/settings.json"; then
    echo "{}" > "${VSCODE_MACHINE_CONFIG_PATH}/settings.json" ||
        bashio::exit.nok 'Failed to create persistent vscode settings.json'
fi

tmpsettings="$(mktemp settings.XXXXXXX.json)"
cp "${VSCODE_MACHINE_CONFIG_PATH}/settings.json" "${tmpsettings}"
if [ -n "${esphome_host}" ]; then
    jq --arg esphome_host "${esphome_host}" '.["esphome.dashboardUri"] = $esphome_host | .["esphome.validator"] = "dashboard"' "${VSCODE_MACHINE_CONFIG_PATH}/settings.json" > "${tmpsettings}"
    cp "${tmpsettings}" "${VSCODE_MACHINE_CONFIG_PATH}/settings.json"
fi

rm "${tmpsettings}"
