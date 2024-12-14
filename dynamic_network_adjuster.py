from flask import Flask, render_template
import psutil
import os
from neutronclient.v2_0 import client as neutron_client

# Inizializza l'app Flask
app = Flask(__name__)

# Crea una connessione al client Neutron
def get_neutron_client():
    return neutron_client.Client(
        username=os.getenv('OS_USERNAME'),
        password=os.getenv('OS_PASSWORD'),
        project_name=os.getenv('OS_PROJECT_NAME'),
        auth_url=os.getenv('OS_AUTH_URL'),
        user_domain_name=os.getenv('OS_USER_DOMAIN_NAME', 'Default'),
        project_domain_name=os.getenv('OS_PROJECT_DOMAIN_NAME', 'Default')
    )

# Funzione per ottenere i dati di traffico
def get_network_traffic():
    net_io = psutil.net_io_counters()
    return net_io.bytes_sent, net_io.bytes_recv

# Funzione per ottenere informazioni QoS
def get_qos_status():
    neutron = get_neutron_client()
    qos_policies = neutron.list_qos_policies()
    return qos_policies

@app.route('/')
def index():
    traffic_sent, traffic_received = get_network_traffic()
    qos_status = get_qos_status()
    return render_template('index.html', 
                           traffic_sent=traffic_sent, 
                           traffic_received=traffic_received, 
                           qos_status=qos_status)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
