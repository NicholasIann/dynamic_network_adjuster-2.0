#!/bin/bash

# Nome del plugin
PLUGIN_NAME=dynamic_network_adjuster

# Percorso del plugin
PLUGIN_DIR=/home/nick/devstack/dynamic_network_adjuster-2.0

echo "Avvio della configurazione del plugin: dynamic_network_adjuster"

function install_dynamic_network_adjuster {
    echo "Installazione delle dipendenze per Dynamic Network Adjuster"
    sudo pip install flask psutil python-openstackclient python-neutronclient
}

function configure_dynamic_network_adjuster {
    echo "Configurazione del plugin Dynamic Network Adjuster"
    mkdir -p /home/nick/devstack/dynamic_network_adjuster-2.0/logs
    touch /logs/plugin.log
}

function start_dynamic_network_adjuster {
    echo "Avvio del servizio Dynamic Network Adjuster"
    python3 /home/nick/devstack/dynamic_network_adjuster-2.0/dynamic_network_adjuster.py > /home/nick/devstack/dynamic_network_adjuster-2.0/logs/plugin.log 2>&1 &
}

if [[ "$1" == "stack" && "$2" == "install" ]]; then
    install_dynamic_network_adjuster
elif [[ "$1" == "stack" && "$2" == "post-config" ]]; then
    configure_dynamic_network_adjuster
elif [[ "$1" == "stack" && "$2" == "extra" ]]; then
    start_dynamic_network_adjuster
fi

if [[ "$1" == "unstack" ]]; then
    echo "Arresto del servizio Dynamic Network Adjuster"
    pkill -f dynamic_network_adjuster.py
fi
