from flask import Flask, render_template_string, request
import redis
import os

app = Flask(__name__)

# Configuración de Redis
redis_host = os.environ.get('REDIS_HOST', 'redis')
redis_port = int(os.environ.get('REDIS_PORT', 6379))
redis_password = os.environ.get('REDIS_PASSWORD', '')

# Conectar a Redis
try:
    if redis_password:
        r = redis.Redis(host=redis_host, port=redis_port, password=redis_password, decode_responses=True)
    else:
        r = redis.Redis(host=redis_host, port=redis_port, decode_responses=True)
    r.ping()
except:
    r = None

# Template HTML
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>Contador de Visitas - Actividad 3</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            text-align: center; 
            margin-top: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container { 
            background: rgba(255,255,255,0.1); 
            padding: 30px; 
            border-radius: 15px; 
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
        }
        .counter { 
            font-size: 4em; 
            font-weight: bold; 
            margin: 20px 0;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        .info { 
            font-size: 1.2em; 
            margin: 20px 0;
            opacity: 0.9;
        }
        .status { 
            padding: 10px; 
            border-radius: 5px; 
            margin: 10px 0;
        }
        .success { background: rgba(76, 175, 80, 0.3); }
        .error { background: rgba(244, 67, 54, 0.3); }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎯 Contador de Visitas</h1>
        <h2>Actividad 3 - Kubernetes</h2>
        
        <div class="counter">{{ visits }}</div>
        
        <div class="info">
            <p><strong>Pod:</strong> {{ pod_name }}</p>
            <p><strong>Timestamp:</strong> {{ timestamp }}</p>
        </div>
        
        <div class="status {{ 'success' if redis_status else 'error' }}">
            <strong>Estado de Redis:</strong> {{ 'Conectado' if redis_status else 'Desconectado' }}
        </div>
        
        <div class="info">
            <p>Esta aplicación está desplegada en Kubernetes con Docker Desktop</p>
            <p>Refresca la página para incrementar el contador</p>
        </div>
    </div>
</body>
</html>
"""

@app.route('/')
def index():
    visits = 0
    redis_status = False
    
    if r:
        try:
            visits = r.incr('visits')
            redis_status = True
        except:
            visits = 0
            redis_status = False
    
    pod_name = os.environ.get('HOSTNAME', 'Desconocido')
    
    from datetime import datetime
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    return render_template_string(HTML_TEMPLATE, 
                                visits=visits, 
                                pod_name=pod_name,
                                timestamp=timestamp,
                                redis_status=redis_status)

@app.route('/health')
def health():
    return {'status': 'healthy', 'timestamp': '2024-01-01'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False) 