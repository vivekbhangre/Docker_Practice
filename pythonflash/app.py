from flask import Flask, render_template, jsonify
import time

app = Flask(__name__)

@app.route('/')
def home():
    # Serves the custom dashboard webpage
    return render_template('index.html')

@app.route('/api/audit')
def security_audit():
    # Simulates a live containerized firewall & port auditing probe
    scanned_ports = [
        {"port": 22, "service": "SSH", "status": "SECURE", "flag": "Whitehat"},
        {"port": 80, "service": "React UI (Nginx)", "status": "OPEN", "flag": "Public"},
        {"port": 5000, "service": "Flask API Core", "status": "OPEN", "flag": "Public"},
        {"port": 8080, "service": "Spring Boot Matrix", "status": "OPEN", "flag": "Public"},
        {"port": 8081, "service": "Legacy Tomcat App", "status": "OPEN", "flag": "Public"}
    ]
    
    return jsonify({
        "status": "COMPLETED",
        "node_id": "SEC-NODE-FLASK-05",
        "execution_time_ms": 42,
        "audit_timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
        "network_ports": scanned_ports
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
